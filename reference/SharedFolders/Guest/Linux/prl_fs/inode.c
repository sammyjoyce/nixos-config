#include <linux/module.h>
#include <linux/pagemap.h>
#include <linux/writeback.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/version.h>
#include "prlfs.h"

int prlfs_writepage(struct page *page, struct writeback_control *wbc) {
	struct inode *inode = page->mapping->host;
	loff_t offset = page_offset(page);
	void *buf;
	int ret;
	int rc = 0;

	buf = kmap(page);
	ret = prlfs_rw(inode, buf, PAGE_SIZE, &offset, 1, TG_REQ_COMMON);
	kunmap(page);
	if (ret < 0) {
		rc =  -EIO;
		SetPageError(page);
		mapping_set_error(page->mapping, rc);
	}

	unlock_page(page);
	return rc;
}

static int prlfs_write_end(struct file *file, struct address_space *mapping,
                           loff_t pos, unsigned int len, unsigned int copied,
                           struct page *page, void *fsdata)
{
	unsigned int from = pos & (PAGE_SIZE - 1);
	struct inode *inode = mapping->host;
	loff_t offset = pos;
	void *buf;
	int ret;

	DPRINTK("ENTER inode=%p pos=%lld len=%u copied=%u\n", inode, pos, len, copied);

	if (!PageUptodate(page) && copied < len)
		zero_user(page, from + copied, len - copied);

	buf = kmap(page);
	ret = prlfs_rw(inode, buf + from, copied, &offset, 1, TG_REQ_COMMON);
	kunmap(page);

	if (ret < 0)
		goto out;

	if (!PageUptodate(page) && len == PAGE_SIZE)
		SetPageUptodate(page);

	if (pos + copied > inode->i_size)
		i_size_write(inode, pos + copied);

out:
	unlock_page(page);
	put_page(page);

	if (ret < 0)
		return ret;

	return copied;
}

const struct address_space_operations prlfs_aops = {
	.readpage	= prlfs_readpage,
	.writepage	= prlfs_writepage,
	.write_begin	= prlfs_write_begin,
	.write_end	= prlfs_write_end,
};
