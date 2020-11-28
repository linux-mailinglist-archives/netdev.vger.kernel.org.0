Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5B92C73D5
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732920AbgK1Vtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732751AbgK1TCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 14:02:49 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54808C08E85E
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 22:11:35 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id x24so6292417pfn.6
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 22:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MpUpXlQQ4uuR0+QNPbK2YACq449x19uNREWvMeeni28=;
        b=GQ0/RF40zzXRMJDo5ReNk3bt2JBnv2juwH1qem22pIkAFL6sGkf1vUgrD7km4wasyv
         mEfTIA807Qm2kytI7BADTzbfGblUj9yZyhaBSCuGgSV7lsPjiJzc276lYmYUlJRFQB3V
         AYZizl4p/CiswjunzJIltBPehJsmKf+ZV7r/DQQkNkmWIngZTdbRASysYhMojeiCfdGC
         DPBFQPybKwdHSwBBmAd8LvHn2IsyxX3CHb4xWMeEsmkuORz1z3Hk5+ZP25gW6x0D54+P
         gTJ7SQhWZptqEZ61MgNOVd+UTWZC5lNniEO0h+5+Ext+jeWWWfYqwhMo9QJbR81Ie0hP
         j8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MpUpXlQQ4uuR0+QNPbK2YACq449x19uNREWvMeeni28=;
        b=iLaqvhWslARSaWwyAaeZwht0wjMXcsfYKP5KZUWcFrzWpQxWjQpYjbfLBQuTgPRirW
         foGdpbx0IzlViL1GwM9ozMhihc3pu+OJNlp6lb+iw0pbe82Y4xF3S9UsWJ6MdI1byHWE
         wztn8bSXSQGruJwPd6WsTIbpwSQrhLfG/7gpddZpPBVcp76Sh6YGmbhTJ4vasQoxSQ7s
         sArqTvRY7JvJbzeTLMGOFWFlkXBpOqUMzLmfOaGShPOwKaOXhsd0BnPvlq45O44/pjX9
         DSaW+Qd97/uRDFRL4xvF1CKhizJIGChRX13iU+ESplmVA+ohZo1TGrtptUGMXVXB9y1P
         QxMQ==
X-Gm-Message-State: AOAM532NbfMz4POo71/nx6LhATjPBa/E4jDKmjE8odBXg1F3JaoeADa5
        C5MEUV8mjxT5Cmxiy1Aei8Lm
X-Google-Smtp-Source: ABdhPJyAzJ/cfuKXPcrzaAgYNMVI5X/XrKFfcgJWFHnu7aHBclchKXvhd0iZM1uYUmQf7NXjfa+U/g==
X-Received: by 2002:a17:90b:ec6:: with SMTP id gz6mr14438098pjb.142.1606543894482;
        Fri, 27 Nov 2020 22:11:34 -0800 (PST)
Received: from thinkpad ([2409:4072:15:c612:48ab:f1cc:6b16:2820])
        by smtp.gmail.com with ESMTPSA id s10sm12235721pjn.35.2020.11.27.22.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 22:11:33 -0800 (PST)
Date:   Sat, 28 Nov 2020 11:41:17 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     gregkh@linuxfoundation.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v13 4/4] bus: mhi: Add userspace client interface driver
Message-ID: <20201128061117.GJ3077@thinkpad>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hemant,

On Fri, Nov 27, 2020 at 07:26:06PM -0800, Hemant Kumar wrote:
> This MHI client driver allows userspace clients to transfer
> raw data between MHI device and host using standard file operations.
> Driver instantiates UCI device object which is associated to device
> file node. UCI device object instantiates UCI channel object when device
> file node is opened. UCI channel object is used to manage MHI channels
> by calling MHI core APIs for read and write operations. MHI channels
> are started as part of device open(). MHI channels remain in start
> state until last release() is called on UCI device file node. Device
> file node is created with format
> 
> /dev/mhi_<mhi_device_name>
> 
> Currently it supports QMI channel.
> 

Thanks for the update. This patch looks good to me. But as I'm going to
apply Loic's "bus: mhi: core: Indexed MHI controller name" patch, you
need to update the documentation accordingly.

> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/bus/mhi/Kconfig  |  13 +
>  drivers/bus/mhi/Makefile |   3 +
>  drivers/bus/mhi/uci.c    | 665 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 681 insertions(+)
>  create mode 100644 drivers/bus/mhi/uci.c
> 
> diff --git a/drivers/bus/mhi/Kconfig b/drivers/bus/mhi/Kconfig
> index da5cd0c..5194e8e 100644
> --- a/drivers/bus/mhi/Kconfig
> +++ b/drivers/bus/mhi/Kconfig
> @@ -29,3 +29,16 @@ config MHI_BUS_PCI_GENERIC
>  	  This driver provides MHI PCI controller driver for devices such as
>  	  Qualcomm SDX55 based PCIe modems.
>  
> +config MHI_UCI
> +	tristate "MHI UCI"
> +	depends on MHI_BUS
> +	help
> +	  MHI based Userspace Client Interface (UCI) driver is used for
> +	  transferring raw data between host and device using standard file
> +	  operations from userspace. Open, read, write, poll and close
> +	  operations are supported by this driver. Please check
> +	  mhi_uci_match_table for all supported channels that are exposed to
> +	  userspace.
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called mhi_uci.
> diff --git a/drivers/bus/mhi/Makefile b/drivers/bus/mhi/Makefile
> index 0a2d778..69f2111 100644
> --- a/drivers/bus/mhi/Makefile
> +++ b/drivers/bus/mhi/Makefile
> @@ -4,3 +4,6 @@ obj-y += core/
>  obj-$(CONFIG_MHI_BUS_PCI_GENERIC) += mhi_pci_generic.o
>  mhi_pci_generic-y += pci_generic.o
>  
> +# MHI client
> +mhi_uci-y := uci.o
> +obj-$(CONFIG_MHI_UCI) += mhi_uci.o
> diff --git a/drivers/bus/mhi/uci.c b/drivers/bus/mhi/uci.c
> new file mode 100644
> index 0000000..fb9c183
> --- /dev/null
> +++ b/drivers/bus/mhi/uci.c
> @@ -0,0 +1,665 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.*/
> +
> +#include <linux/kernel.h>
> +#include <linux/mhi.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/poll.h>
> +
> +#define MHI_DEVICE_NAME "mhi"
> +#define MHI_UCI_DRIVER_NAME "mhi_uci"
> +#define MHI_MAX_UCI_MINORS 128
> +
> +static DEFINE_IDR(uci_idr);
> +static DEFINE_MUTEX(uci_drv_mutex);
> +static struct class *uci_dev_class;
> +static int uci_dev_major;
> +
> +/**
> + * struct uci_chan - MHI channel for a UCI device
> + * @udev: associated UCI device object
> + * @ul_wq: wait queue for writer
> + * @write_lock: mutex write lock for ul channel
> + * @dl_wq: wait queue for reader
> + * @read_lock: mutex read lock for dl channel
> + * @dl_pending_lock: spin lock for dl_pending list
> + * @dl_pending: list of dl buffers userspace is waiting to read
> + * @cur_buf: current buffer userspace is reading
> + * @dl_size: size of the current dl buffer userspace is reading
> + * @ref_count: uci_chan reference count
> + */
> +struct uci_chan {
> +	struct uci_dev *udev;
> +	wait_queue_head_t ul_wq;
> +
> +	/* ul channel lock to synchronize multiple writes */
> +	struct mutex write_lock;
> +
> +	wait_queue_head_t dl_wq;
> +
> +	/* dl channel lock to synchronize multiple reads */
> +	struct mutex read_lock;
> +
> +	/*
> +	 * protects pending list in bh context, channel release, read and
> +	 * poll
> +	 */
> +	spinlock_t dl_pending_lock;
> +
> +	struct list_head dl_pending;
> +	struct uci_buf *cur_buf;
> +	size_t dl_size;
> +	struct kref ref_count;
> +};
> +
> +/**
> + * struct uci_buf - UCI buffer
> + * @data: data buffer
> + * @len: length of data buffer
> + * @node: list node of the UCI buffer
> + */
> +struct uci_buf {
> +	void *data;
> +	size_t len;
> +	struct list_head node;
> +};
> +
> +/**
> + * struct uci_dev - MHI UCI device
> + * @minor: UCI device node minor number
> + * @mhi_dev: associated mhi device object
> + * @uchan: UCI uplink and downlink channel object
> + * @mtu: max TRE buffer length
> + * @enabled: Flag to track the state of the UCI device
> + * @lock: mutex lock to manage uchan object
> + * @ref_count: uci_dev reference count
> + */
> +struct uci_dev {
> +	unsigned int minor;
> +	struct mhi_device *mhi_dev;
> +	struct uci_chan *uchan;
> +	size_t mtu;
> +	bool enabled;
> +
> +	/* synchronize open, release and driver remove */
> +	struct mutex lock;
> +	struct kref ref_count;
> +};
> +
> +static void mhi_uci_dev_chan_release(struct kref *ref)
> +{
> +	struct uci_buf *buf_itr, *tmp;
> +	struct uci_chan *uchan =
> +		container_of(ref, struct uci_chan, ref_count);
> +
> +	if (uchan->udev->enabled)
> +		mhi_unprepare_from_transfer(uchan->udev->mhi_dev);
> +
> +	spin_lock_bh(&uchan->dl_pending_lock);
> +	list_for_each_entry_safe(buf_itr, tmp, &uchan->dl_pending, node) {
> +		list_del(&buf_itr->node);
> +		kfree(buf_itr->data);
> +	}
> +	spin_unlock_bh(&uchan->dl_pending_lock);
> +
> +	wake_up(&uchan->ul_wq);
> +	wake_up(&uchan->dl_wq);
> +
> +	mutex_lock(&uchan->read_lock);
> +	if (uchan->cur_buf)
> +		kfree(uchan->cur_buf->data);
> +
> +	uchan->cur_buf = NULL;
> +	mutex_unlock(&uchan->read_lock);
> +
> +	mutex_destroy(&uchan->write_lock);
> +	mutex_destroy(&uchan->read_lock);
> +
> +	uchan->udev->uchan = NULL;
> +	kfree(uchan);
> +}
> +
> +static int mhi_queue_inbound(struct uci_dev *udev)
> +{
> +	struct mhi_device *mhi_dev = udev->mhi_dev;
> +	struct device *dev = &mhi_dev->dev;
> +	int nr_desc, i, ret = -EIO;
> +	size_t dl_buf_size;
> +	void *buf;
> +	struct uci_buf *ubuf;
> +
> +	/*
> +	 * skip queuing without error if dl channel is not supported. This
> +	 * allows open to succeed for udev, supporting ul only channel.
> +	 */
> +	if (!udev->mhi_dev->dl_chan)
> +		return 0;
> +
> +	nr_desc = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> +
> +	for (i = 0; i < nr_desc; i++) {
> +		buf = kmalloc(udev->mtu, GFP_KERNEL);
> +		if (!buf)
> +			return -ENOMEM;
> +
> +		dl_buf_size = udev->mtu - sizeof(*ubuf);
> +
> +		/* save uci_buf info at the end of buf */
> +		ubuf = buf + dl_buf_size;
> +		ubuf->data = buf;
> +
> +		dev_dbg(dev, "Allocated buf %d of %d size %zu\n", i, nr_desc,
> +			dl_buf_size);
> +
> +		ret = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, buf, dl_buf_size,
> +				    MHI_EOT);
> +		if (ret) {
> +			kfree(buf);
> +			dev_err(dev, "Failed to queue buffer %d\n", i);
> +			return ret;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int mhi_uci_dev_start_chan(struct uci_dev *udev)
> +{
> +	int ret = 0;
> +	struct uci_chan *uchan;
> +
> +	mutex_lock(&udev->lock);
> +	if (!udev->uchan || !kref_get_unless_zero(&udev->uchan->ref_count)) {
> +		uchan = kzalloc(sizeof(*uchan), GFP_KERNEL);
> +		if (!uchan) {
> +			ret = -ENOMEM;
> +			goto error_chan_start;
> +		}
> +
> +		udev->uchan = uchan;
> +		uchan->udev = udev;
> +		init_waitqueue_head(&uchan->ul_wq);
> +		init_waitqueue_head(&uchan->dl_wq);
> +		mutex_init(&uchan->write_lock);
> +		mutex_init(&uchan->read_lock);
> +		spin_lock_init(&uchan->dl_pending_lock);
> +		INIT_LIST_HEAD(&uchan->dl_pending);
> +
> +		ret = mhi_prepare_for_transfer(udev->mhi_dev);
> +		if (ret) {
> +			dev_err(&udev->mhi_dev->dev, "Error starting transfer channels\n");
> +			goto error_chan_cleanup;
> +		}
> +
> +		ret = mhi_queue_inbound(udev);
> +		if (ret)
> +			goto error_chan_cleanup;
> +
> +		kref_init(&uchan->ref_count);
> +	}
> +
> +	mutex_unlock(&udev->lock);
> +
> +	return 0;
> +
> +error_chan_cleanup:
> +	mhi_uci_dev_chan_release(&uchan->ref_count);
> +error_chan_start:
> +	mutex_unlock(&udev->lock);
> +	return ret;
> +}
> +
> +static void mhi_uci_dev_release(struct kref *ref)
> +{
> +	struct uci_dev *udev =
> +		container_of(ref, struct uci_dev, ref_count);
> +
> +	mutex_destroy(&udev->lock);
> +
> +	kfree(udev);
> +}
> +
> +static int mhi_uci_open(struct inode *inode, struct file *filp)
> +{
> +	unsigned int minor = iminor(inode);
> +	struct uci_dev *udev = NULL;
> +	int ret;
> +
> +	mutex_lock(&uci_drv_mutex);
> +	udev = idr_find(&uci_idr, minor);
> +	if (!udev) {
> +		pr_debug("uci dev: minor %d not found\n", minor);
> +		mutex_unlock(&uci_drv_mutex);
> +		return -ENODEV;
> +	}
> +
> +	kref_get(&udev->ref_count);
> +	mutex_unlock(&uci_drv_mutex);
> +
> +	ret = mhi_uci_dev_start_chan(udev);
> +	if (ret) {
> +		kref_put(&udev->ref_count, mhi_uci_dev_release);
> +		return ret;
> +	}
> +
> +	filp->private_data = udev;
> +
> +	return 0;
> +}
> +
> +static int mhi_uci_release(struct inode *inode, struct file *file)
> +{
> +	struct uci_dev *udev = file->private_data;
> +
> +	mutex_lock(&udev->lock);
> +	kref_put(&udev->uchan->ref_count, mhi_uci_dev_chan_release);
> +	mutex_unlock(&udev->lock);
> +
> +	kref_put(&udev->ref_count, mhi_uci_dev_release);
> +
> +	return 0;
> +}
> +
> +static __poll_t mhi_uci_poll(struct file *file, poll_table *wait)
> +{
> +	struct uci_dev *udev = file->private_data;
> +	struct mhi_device *mhi_dev = udev->mhi_dev;
> +	struct device *dev = &mhi_dev->dev;
> +	struct uci_chan *uchan = udev->uchan;
> +	__poll_t mask = 0;
> +
> +	poll_wait(file, &udev->uchan->ul_wq, wait);
> +	poll_wait(file, &udev->uchan->dl_wq, wait);
> +
> +	if (!udev->enabled) {
> +		mask = EPOLLERR;
> +		goto done;
> +	}
> +
> +	spin_lock_bh(&uchan->dl_pending_lock);
> +	if (!list_empty(&uchan->dl_pending) || uchan->cur_buf)
> +		mask |= EPOLLIN | EPOLLRDNORM;
> +	spin_unlock_bh(&uchan->dl_pending_lock);
> +
> +	if (mhi_get_free_desc_count(mhi_dev, DMA_TO_DEVICE) > 0)
> +		mask |= EPOLLOUT | EPOLLWRNORM;
> +
> +	dev_dbg(dev, "Client attempted to poll, returning mask 0x%x\n", mask);
> +
> +done:
> +	return mask;
> +}
> +
> +static ssize_t mhi_uci_write(struct file *file,
> +			     const char __user *buf,
> +			     size_t count,
> +			     loff_t *offp)
> +{
> +	struct uci_dev *udev = file->private_data;
> +	struct mhi_device *mhi_dev = udev->mhi_dev;
> +	struct device *dev = &mhi_dev->dev;
> +	struct uci_chan *uchan = udev->uchan;
> +	size_t bytes_xfered = 0;
> +	int ret, nr_desc = 0;
> +
> +	/* if ul channel is not supported return error */
> +	if (!mhi_dev->ul_chan)
> +		return -EOPNOTSUPP;
> +
> +	if (!buf || !count)
> +		return -EINVAL;
> +
> +	dev_dbg(dev, "%s: to xfer: %zu bytes\n", __func__, count);
> +
> +	if (mutex_lock_interruptible(&uchan->write_lock))
> +		return -EINTR;
> +
> +	while (count) {
> +		size_t xfer_size;
> +		void *kbuf;
> +		enum mhi_flags flags;
> +
> +		/* wait for free descriptors */
> +		ret = wait_event_interruptible(uchan->ul_wq,
> +					       (!udev->enabled) ||
> +				(nr_desc = mhi_get_free_desc_count(mhi_dev,
> +					       DMA_TO_DEVICE)) > 0);
> +
> +		if (ret == -ERESTARTSYS) {
> +			dev_dbg(dev, "Interrupted by a signal in %s, exiting\n",
> +				__func__);
> +			goto err_mtx_unlock;
> +		}
> +
> +		if (!udev->enabled) {
> +			ret = -ENODEV;
> +			goto err_mtx_unlock;
> +		}
> +
> +		xfer_size = min_t(size_t, count, udev->mtu);
> +		kbuf = kmalloc(xfer_size, GFP_KERNEL);
> +		if (!kbuf) {
> +			ret = -ENOMEM;
> +			goto err_mtx_unlock;
> +		}
> +
> +		ret = copy_from_user(kbuf, buf, xfer_size);
> +		if (ret) {
> +			kfree(kbuf);
> +			ret = -EFAULT;
> +			goto err_mtx_unlock;
> +		}
> +
> +		/* if ring is full after this force EOT */
> +		if (nr_desc > 1 && (count - xfer_size))
> +			flags = MHI_CHAIN;
> +		else
> +			flags = MHI_EOT;
> +
> +		ret = mhi_queue_buf(mhi_dev, DMA_TO_DEVICE, kbuf, xfer_size,
> +				    flags);
> +		if (ret) {
> +			kfree(kbuf);
> +			goto err_mtx_unlock;
> +		}
> +
> +		bytes_xfered += xfer_size;
> +		count -= xfer_size;
> +		buf += xfer_size;
> +	}
> +
> +	mutex_unlock(&uchan->write_lock);
> +	dev_dbg(dev, "%s: bytes xferred: %zu\n", __func__, bytes_xfered);
> +
> +	return bytes_xfered;
> +
> +err_mtx_unlock:
> +	mutex_unlock(&uchan->write_lock);
> +
> +	return ret;
> +}
> +
> +static ssize_t mhi_uci_read(struct file *file,
> +			    char __user *buf,
> +			    size_t count,
> +			    loff_t *ppos)
> +{
> +	struct uci_dev *udev = file->private_data;
> +	struct mhi_device *mhi_dev = udev->mhi_dev;
> +	struct uci_chan *uchan = udev->uchan;
> +	struct device *dev = &mhi_dev->dev;
> +	struct uci_buf *ubuf;
> +	size_t rx_buf_size;
> +	char *ptr;
> +	size_t to_copy;
> +	int ret = 0;
> +
> +	/* if dl channel is not supported return error */
> +	if (!mhi_dev->dl_chan)
> +		return -EOPNOTSUPP;
> +
> +	if (!buf)
> +		return -EINVAL;
> +
> +	if (mutex_lock_interruptible(&uchan->read_lock))
> +		return -EINTR;
> +
> +	spin_lock_bh(&uchan->dl_pending_lock);
> +	/* No data available to read, wait */
> +	if (!uchan->cur_buf && list_empty(&uchan->dl_pending)) {
> +		dev_dbg(dev, "No data available to read, waiting\n");
> +
> +		spin_unlock_bh(&uchan->dl_pending_lock);
> +		ret = wait_event_interruptible(uchan->dl_wq,
> +					       (!udev->enabled ||
> +					      !list_empty(&uchan->dl_pending)));
> +
> +		if (ret == -ERESTARTSYS) {
> +			dev_dbg(dev, "Interrupted by a signal in %s, exiting\n",
> +				__func__);
> +			goto err_mtx_unlock;
> +		}
> +
> +		if (!udev->enabled) {
> +			ret = -ENODEV;
> +			goto err_mtx_unlock;
> +		}
> +		spin_lock_bh(&uchan->dl_pending_lock);
> +	}
> +
> +	/* new read, get the next descriptor from the list */
> +	if (!uchan->cur_buf) {
> +		ubuf = list_first_entry_or_null(&uchan->dl_pending,
> +						struct uci_buf, node);
> +		if (!ubuf) {
> +			ret = -EIO;
> +			goto err_spin_unlock;
> +		}
> +
> +		list_del(&ubuf->node);
> +		uchan->cur_buf = ubuf;
> +		uchan->dl_size = ubuf->len;
> +		dev_dbg(dev, "Got pkt of size: %zu\n", uchan->dl_size);
> +	}
> +	spin_unlock_bh(&uchan->dl_pending_lock);
> +
> +	ubuf = uchan->cur_buf;
> +
> +	/* Copy the buffer to user space */
> +	to_copy = min_t(size_t, count, uchan->dl_size);
> +	ptr = ubuf->data + (ubuf->len - uchan->dl_size);
> +
> +	ret = copy_to_user(buf, ptr, to_copy);
> +	if (ret) {
> +		ret = -EFAULT;
> +		goto err_mtx_unlock;
> +	}
> +
> +	dev_dbg(dev, "Copied %zu of %zu bytes\n", to_copy, uchan->dl_size);
> +	uchan->dl_size -= to_copy;
> +
> +	/* we finished with this buffer, queue it back to hardware */
> +	if (!uchan->dl_size) {
> +		uchan->cur_buf = NULL;
> +
> +		rx_buf_size = udev->mtu - sizeof(*ubuf);
> +		ret = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, ubuf->data,
> +				    rx_buf_size, MHI_EOT);
> +		if (ret) {
> +			dev_err(dev, "Failed to recycle element: %d\n", ret);
> +			kfree(ubuf->data);
> +			goto err_mtx_unlock;
> +		}
> +	}
> +	mutex_unlock(&uchan->read_lock);
> +
> +	dev_dbg(dev, "%s: Returning %zu bytes\n", __func__, to_copy);
> +
> +	return to_copy;
> +
> +err_spin_unlock:
> +	spin_unlock_bh(&uchan->dl_pending_lock);
> +err_mtx_unlock:
> +	mutex_unlock(&uchan->read_lock);
> +	return ret;
> +}
> +
> +static const struct file_operations mhidev_fops = {
> +	.owner = THIS_MODULE,
> +	.open = mhi_uci_open,
> +	.release = mhi_uci_release,
> +	.read = mhi_uci_read,
> +	.write = mhi_uci_write,
> +	.poll = mhi_uci_poll,
> +};
> +
> +static void mhi_ul_xfer_cb(struct mhi_device *mhi_dev,
> +			   struct mhi_result *mhi_result)
> +{
> +	struct uci_dev *udev = dev_get_drvdata(&mhi_dev->dev);
> +	struct uci_chan *uchan = udev->uchan;
> +	struct device *dev = &mhi_dev->dev;
> +
> +	dev_dbg(dev, "%s: status: %d xfer_len: %zu\n", __func__,
> +		mhi_result->transaction_status, mhi_result->bytes_xferd);
> +
> +	kfree(mhi_result->buf_addr);
> +
> +	if (!mhi_result->transaction_status)
> +		wake_up(&uchan->ul_wq);
> +}
> +
> +static void mhi_dl_xfer_cb(struct mhi_device *mhi_dev,
> +			   struct mhi_result *mhi_result)
> +{
> +	struct uci_dev *udev = dev_get_drvdata(&mhi_dev->dev);
> +	struct uci_chan *uchan = udev->uchan;
> +	struct device *dev = &mhi_dev->dev;
> +	struct uci_buf *ubuf;
> +	size_t dl_buf_size = udev->mtu - sizeof(*ubuf);
> +
> +	dev_dbg(dev, "%s: status: %d receive_len: %zu\n", __func__,
> +		mhi_result->transaction_status, mhi_result->bytes_xferd);
> +
> +	if (mhi_result->transaction_status &&
> +	    mhi_result->transaction_status != -EOVERFLOW) {
> +		kfree(mhi_result->buf_addr);
> +		return;
> +	}
> +
> +	ubuf = mhi_result->buf_addr + dl_buf_size;
> +	ubuf->data = mhi_result->buf_addr;
> +	ubuf->len = mhi_result->bytes_xferd;
> +	spin_lock_bh(&uchan->dl_pending_lock);
> +	list_add_tail(&ubuf->node, &uchan->dl_pending);
> +	spin_unlock_bh(&uchan->dl_pending_lock);
> +
> +	wake_up(&uchan->dl_wq);
> +}
> +
> +static int mhi_uci_probe(struct mhi_device *mhi_dev,
> +			 const struct mhi_device_id *id)
> +{
> +	struct uci_dev *udev;
> +	struct device *dev;
> +	int index;
> +
> +	udev = kzalloc(sizeof(*udev), GFP_KERNEL);
> +	if (!udev)
> +		return -ENOMEM;
> +
> +	kref_init(&udev->ref_count);
> +	mutex_init(&udev->lock);
> +	udev->mhi_dev = mhi_dev;
> +
> +	mutex_lock(&uci_drv_mutex);
> +	index = idr_alloc(&uci_idr, udev, 0, MHI_MAX_UCI_MINORS, GFP_KERNEL);
> +	mutex_unlock(&uci_drv_mutex);
> +	if (index < 0) {
> +		kfree(udev);
> +		return index;
> +	}
> +
> +	udev->minor = index;
> +
> +	udev->mtu = min_t(size_t, id->driver_data, MHI_MAX_MTU);
> +	dev_set_drvdata(&mhi_dev->dev, udev);
> +	udev->enabled = true;
> +
> +	/* create device file node /dev/mhi_<mhi_dev_name> */
> +	dev = device_create(uci_dev_class, &mhi_dev->dev,
> +			    MKDEV(uci_dev_major, index), udev,
> +			    MHI_DEVICE_NAME "_%s", dev_name(&mhi_dev->dev));
> +	if (IS_ERR(dev)) {
> +		mutex_lock(&uci_drv_mutex);
> +		idr_remove(&uci_idr, udev->minor);
> +		mutex_unlock(&uci_drv_mutex);
> +		dev_set_drvdata(&mhi_dev->dev, NULL);
> +		kfree(udev);
> +		return PTR_ERR(dev);
> +	}
> +
> +	dev_dbg(&mhi_dev->dev, "probed uci dev: %s\n", id->chan);
> +
> +	return 0;
> +};
> +
> +static void mhi_uci_remove(struct mhi_device *mhi_dev)
> +{
> +	struct uci_dev *udev = dev_get_drvdata(&mhi_dev->dev);
> +
> +	/* disable the node */
> +	mutex_lock(&udev->lock);
> +	udev->enabled = false;
> +
> +	/* delete the node to prevent new opens */
> +	device_destroy(uci_dev_class, MKDEV(uci_dev_major, udev->minor));
> +
> +	/* return error for any blocked read or write */
> +	if (udev->uchan) {
> +		wake_up(&udev->uchan->ul_wq);
> +		wake_up(&udev->uchan->dl_wq);
> +	}
> +	mutex_unlock(&udev->lock);
> +
> +	mutex_lock(&uci_drv_mutex);
> +	idr_remove(&uci_idr, udev->minor);
> +	kref_put(&udev->ref_count, mhi_uci_dev_release);
> +	mutex_unlock(&uci_drv_mutex);
> +}
> +
> +/* .driver_data stores max mtu */
> +static const struct mhi_device_id mhi_uci_match_table[] = {
> +	{ .chan = "QMI", .driver_data = 0x1000},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(mhi, mhi_uci_match_table);
> +
> +static struct mhi_driver mhi_uci_driver = {
> +	.id_table = mhi_uci_match_table,
> +	.remove = mhi_uci_remove,
> +	.probe = mhi_uci_probe,
> +	.ul_xfer_cb = mhi_ul_xfer_cb,
> +	.dl_xfer_cb = mhi_dl_xfer_cb,
> +	.driver = {
> +		.name = MHI_UCI_DRIVER_NAME,
> +	},
> +};
> +
> +static int __init mhi_uci_init(void)
> +{
> +	int ret;
> +
> +	ret = register_chrdev(0, MHI_UCI_DRIVER_NAME, &mhidev_fops);
> +	if (ret < 0)
> +		return ret;
> +
> +	uci_dev_major = ret;
> +	uci_dev_class = class_create(THIS_MODULE, MHI_UCI_DRIVER_NAME);
> +	if (IS_ERR(uci_dev_class)) {
> +		unregister_chrdev(uci_dev_major, MHI_UCI_DRIVER_NAME);
> +		return PTR_ERR(uci_dev_class);
> +	}
> +
> +	ret = mhi_driver_register(&mhi_uci_driver);
> +	if (ret) {
> +		class_destroy(uci_dev_class);
> +		unregister_chrdev(uci_dev_major, MHI_UCI_DRIVER_NAME);
> +	}
> +
> +	return ret;
> +}
> +
> +static void __exit mhi_uci_exit(void)
> +{
> +	mhi_driver_unregister(&mhi_uci_driver);
> +	class_destroy(uci_dev_class);
> +	unregister_chrdev(uci_dev_major, MHI_UCI_DRIVER_NAME);
> +	idr_destroy(&uci_idr);
> +}
> +
> +module_init(mhi_uci_init);
> +module_exit(mhi_uci_exit);
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("MHI UCI Driver");
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
