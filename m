Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18C0AE7B7
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393640AbfIJKPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:15:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbfIJKPk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 06:15:40 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAEE7A70E
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 10:15:38 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id k22so16331411qtm.7
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 03:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zp0tJQdFwr9SMjNLAZ/pzy+YLP+qtmqzIu6ncuWqA/8=;
        b=e2C0jWNf9yvLQUOSpbw3rJppKHmZV8aiGc9xjuBBc/6qsdawd+wDUPB08kAm6kEVrt
         ATbf7E4pg+3OL19ZLS+iz54oZ3SaxGcMqpHe6NRHzP7BHLHxXPdWxq/tNlFGHT/b/BeF
         c7TG7fEk56MNfHLtEcSSszoocaDmRkRO7DTJ2VJZIzwHIYV5HT7LcZbi/YFF0CHxVfKE
         JMs8qlUR0kAjq3nWOJkTIKNh8muEY3dIgYHTto5WPiukQ801UWvnyU/EfuXcQPpTu2As
         tNtY4wJA9sCHpNLFoGwVJMRhjR7VL0CMU81k2FGsL5RN+Uc9PRQSwisEuNTpZJVLkc9q
         7M+w==
X-Gm-Message-State: APjAAAV/m+4/L00rtlyivTn9qgxYK1bkV6GuNDdNQwrMfcZciQDAyYEK
        7SvKzziXk7wJeZ0fhOOed0MZdFT/E2eD6Y8rvkEO9VSzN0PXY11fqexbAqcmHqH2rNs/uJ49WtF
        wwko8LMzo6As444Ll
X-Received: by 2002:ae9:ee1a:: with SMTP id i26mr28231835qkg.112.1568110537862;
        Tue, 10 Sep 2019 03:15:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy14/viNpctJbPLObEOYx1TiBkh51/KAKwcfN6RGtROOcpBnAJHtTKG1tB9vRNNny2OxE6K0g==
X-Received: by 2002:ae9:ee1a:: with SMTP id i26mr28231804qkg.112.1568110537597;
        Tue, 10 Sep 2019 03:15:37 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id h10sm10207195qtk.18.2019.09.10.03.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 03:15:36 -0700 (PDT)
Date:   Tue, 10 Sep 2019 06:15:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwankhede@nvidia.com, alex.williamson@redhat.com,
        cohuck@redhat.com, tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, idos@mellanox.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com
Subject: Re: [RFC PATCH 4/4] docs: Sample driver to demonstrate how to
 implement virtio-mdev framework
Message-ID: <20190910060531-mutt-send-email-mst@kernel.org>
References: <20190910081935.30516-1-jasowang@redhat.com>
 <20190910081935.30516-5-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910081935.30516-5-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 04:19:35PM +0800, Jason Wang wrote:
> This sample driver creates mdev device that simulate virtio net device
> over virtio mdev transport. The device is implemented through vringh
> and workqueue.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  samples/Kconfig            |   7 +
>  samples/vfio-mdev/Makefile |   1 +
>  samples/vfio-mdev/mvnet.c  | 766 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 774 insertions(+)
>  create mode 100644 samples/vfio-mdev/mvnet.c

So for a POC, this is a bit too rough to be able to judge
whether the approach is workable.
Can you get it a bit more into shape esp wrt UAPI?

> diff --git a/samples/Kconfig b/samples/Kconfig
> index c8dacb4dda80..a1a1ca2c00b7 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -131,6 +131,13 @@ config SAMPLE_VFIO_MDEV_MDPY
>  	  mediated device.  It is a simple framebuffer and supports
>  	  the region display interface (VFIO_GFX_PLANE_TYPE_REGION).
>  
> +config SAMPLE_VIRTIO_MDEV_NET
> +        tristate "Build virtio mdev net example mediated device sample code -- loadable modules only"
> +	depends on VIRTIO_MDEV_DEVICE && VHOST_RING && m
> +	help
> +	  Build a networking sample device for use as a virtio
> +	  mediated device.
> +
>  config SAMPLE_VFIO_MDEV_MDPY_FB
>  	tristate "Build VFIO mdpy example guest fbdev driver -- loadable module only"
>  	depends on FB && m
> diff --git a/samples/vfio-mdev/Makefile b/samples/vfio-mdev/Makefile
> index 10d179c4fdeb..f34af90ed0a0 100644
> --- a/samples/vfio-mdev/Makefile
> +++ b/samples/vfio-mdev/Makefile
> @@ -3,3 +3,4 @@ obj-$(CONFIG_SAMPLE_VFIO_MDEV_MTTY) += mtty.o
>  obj-$(CONFIG_SAMPLE_VFIO_MDEV_MDPY) += mdpy.o
>  obj-$(CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB) += mdpy-fb.o
>  obj-$(CONFIG_SAMPLE_VFIO_MDEV_MBOCHS) += mbochs.o
> +obj-$(CONFIG_SAMPLE_VIRTIO_MDEV_NET) += mvnet.o
> diff --git a/samples/vfio-mdev/mvnet.c b/samples/vfio-mdev/mvnet.c
> new file mode 100644
> index 000000000000..da295b41955e
> --- /dev/null
> +++ b/samples/vfio-mdev/mvnet.c
> @@ -0,0 +1,766 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Mediated virtual virtio-net device driver.
> + *
> + * Copyright (c) 2019, Red Hat Inc. All rights reserved.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + *
> + * Sample driver


Documentation on how to use this?


> that creates mdev device that simulates ethernet
> + * device virtio mdev transport.


Well not exactly. What it seems to do is short-circuit
RX and TX rings.

> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/wait.h>
> +#include <linux/uuid.h>
> +#include <linux/iommu.h>
> +#include <linux/sysfs.h>
> +#include <linux/file.h>
> +#include <linux/etherdevice.h>
> +#include <linux/mdev.h>
> +#include <uapi/linux/virtio_mdev.h>
> +
> +#define VERSION_STRING  "0.1"
> +#define DRIVER_AUTHOR   "NVIDIA Corporation"
> +
> +#define MVNET_CLASS_NAME "mvnet"
> +
> +#define MVNET_NAME       "mvnet"
> +
> +/*
> + * Global Structures
> + */
> +
> +static struct mvnet_dev {
> +	struct class	*vd_class;
> +	struct idr	vd_idr;
> +	struct device	dev;
> +} mvnet_dev;
> +
> +struct mvnet_virtqueue {
> +	struct vringh vring;
> +	struct vringh_kiov iov;
> +	unsigned short head;
> +	bool ready;
> +	u32 desc_addr_lo;
> +	u32 desc_addr_hi;
> +	u32 device_addr_lo;
> +	u32 device_addr_hi;
> +	u32 driver_addr_lo;
> +	u32 driver_addr_hi;
> +	u64 desc_addr;
> +	u64 device_addr;
> +	u64 driver_addr;
> +	void *private;
> +	irqreturn_t (*cb)(void *);
> +};
> +
> +#define MVNET_QUEUE_ALIGN PAGE_SIZE
> +#define MVNET_QUEUE_MAX 256
> +#define MVNET_MAGIC_VALUE ('v' | 'i' << 8 | 'r' << 16 | 't' << 24)
> +#define MVNET_VERSION 0x1 /* Implies virtio 1.0 */
> +#define MVNET_DEVICE_ID 0x1 /* network card */
> +#define MVNET_VENDOR_ID 0 /* is this correct ? */
> +#define MVNET_DEVICE_FEATURES VIRTIO_F_VERSION_1
> +
> +u64 mvnet_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
> +	             (1ULL << VIRTIO_F_VERSION_1) |
> +		     (1ULL << VIRTIO_F_IOMMU_PLATFORM) ;
> +
> +/* State of each mdev device */
> +struct mvnet_state {
> +	struct mvnet_virtqueue vqs[2];
> +	struct work_struct work;
> +	spinlock_t lock;
> +	struct mdev_device *mdev;
> +	struct virtio_net_config config;
> +	struct virtio_mdev_callback *cbs;
> +	void *buffer;
> +	u32 queue_sel;
> +	u32 driver_features_sel;
> +	u32 driver_features[2];
> +	u32 device_features_sel;
> +	u32 status;
> +	u32 generation;
> +	u32 num;
> +	struct list_head next;
> +};
> +
> +static struct mutex mdev_list_lock;
> +static struct list_head mdev_devices_list;
> +
> +static void mvnet_queue_ready(struct mvnet_state *mvnet, unsigned idx)
> +{
> +	struct mvnet_virtqueue *vq = &mvnet->vqs[idx];
> +	int ret;
> +
> +	vq->desc_addr = (u64)vq->desc_addr_hi << 32 | vq->desc_addr_lo;
> +	vq->device_addr = (u64)vq->device_addr_hi << 32 | vq->device_addr_lo;
> +	vq->driver_addr = (u64)vq->driver_addr_hi << 32 | vq->driver_addr_lo;
> +
> +	ret = vringh_init_kern(&vq->vring, mvnet_features, MVNET_QUEUE_MAX,
> +			       false, (struct vring_desc *)vq->desc_addr,
> +			       (struct vring_avail *)vq->driver_addr,
> +			       (struct vring_used *)vq->device_addr);
> +}
> +
> +static ssize_t mvnet_read_config(struct mdev_device *mdev,
> +				 u32 *val, loff_t pos)
> +{
> +	struct mvnet_state *mvnet;
> +	struct mvnet_virtqueue *vq;
> +	u32 queue_sel;
> +
> +	if (!mdev || !val)
> +		return -EINVAL;
> +
> +	mvnet = mdev_get_drvdata(mdev);
> +	if (!mvnet) {
> +		pr_err("%s mvnet not found\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	queue_sel = mvnet->queue_sel;
> +	vq = &mvnet->vqs[queue_sel];
> +
> +	switch (pos) {
> +	case VIRTIO_MDEV_MAGIC_VALUE:
> +		*val = MVNET_MAGIC_VALUE;
> +		break;
> +	case VIRTIO_MDEV_VERSION:
> +		*val = MVNET_VERSION;
> +		break;
> +	case VIRTIO_MDEV_DEVICE_ID:
> +		*val = MVNET_DEVICE_ID;
> +		break;
> +	case VIRTIO_MDEV_VENDOR_ID:
> +		*val = MVNET_VENDOR_ID;
> +		break;
> +	case VIRTIO_MDEV_DEVICE_FEATURES:
> +		if (mvnet->device_features_sel)
> +			*val = mvnet_features >> 32;
> +		else
> +			*val = mvnet_features;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_NUM_MAX:
> +		*val = MVNET_QUEUE_MAX;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_READY:
> +		*val = vq->ready;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_ALIGN:
> +		*val = MVNET_QUEUE_ALIGN;
> +		break;
> +	case VIRTIO_MDEV_STATUS:
> +		*val = mvnet->status;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_DESC_LOW:
> +		*val = vq->desc_addr_lo;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_DESC_HIGH:
> +		*val = vq->desc_addr_hi;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_AVAIL_LOW:
> +		*val = vq->driver_addr_lo;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_AVAIL_HIGH:
> +		*val = vq->driver_addr_hi;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_USED_LOW:
> +		*val = vq->device_addr_lo;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_USED_HIGH:
> +		*val = vq->device_addr_hi;
> +		break;
> +	case VIRTIO_MDEV_CONFIG_GENERATION:
> +		*val = 1;
> +		break;
> +	default:
> +		pr_err("Unsupported mdev read offset at 0x%x\n", pos);
> +		break;
> +	}
> +
> +	return 4;
> +}
> +
> +static ssize_t mvnet_read_net_config(struct mdev_device *mdev,
> +				     char *buf, size_t count, loff_t pos)
> +{
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +
> +	if (!mvnet) {
> +		pr_err("%s mvnet not found\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (pos + count > sizeof(mvnet->config))
> +		return -EINVAL;
> +
> +	memcpy(buf, &mvnet->config + (unsigned)pos, count);
> +
> +	return count;
> +}
> +
> +static void mvnet_vq_reset(struct mvnet_virtqueue *vq)
> +{
> +	vq->ready = 0;
> +	vq->desc_addr_lo = vq->desc_addr_hi = 0;
> +	vq->device_addr_lo = vq->device_addr_hi = 0;
> +	vq->driver_addr_lo = vq->driver_addr_hi = 0;
> +	vq->desc_addr = 0;
> +	vq->driver_addr = 0;
> +	vq->device_addr = 0;
> +	vringh_init_kern(&vq->vring, mvnet_features, MVNET_QUEUE_MAX,
> +			false, 0, 0, 0);
> +}
> +
> +static void mvnet_reset(struct mvnet_state *mvnet)
> +{
> +	int i;
> +
> +	for (i = 0; i < 2; i++)
> +		mvnet_vq_reset(&mvnet->vqs[i]);
> +
> +	mvnet->queue_sel = 0;
> +	mvnet->driver_features_sel = 0;
> +	mvnet->device_features_sel = 0;
> +	mvnet->status = 0;
> +	++mvnet->generation;
> +}
> +
> +static ssize_t mvnet_write_config(struct mdev_device *mdev,
> +				  u32 *val, loff_t pos)
> +{
> +	struct mvnet_state *mvnet;
> +	struct mvnet_virtqueue *vq;
> +	u32 queue_sel;
> +
> +	if (!mdev || !val)
> +		return -EINVAL;
> +
> +	mvnet = mdev_get_drvdata(mdev);
> +	if (!mvnet) {
> +		pr_err("%s mvnet not found\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	queue_sel = mvnet->queue_sel;
> +	vq = &mvnet->vqs[queue_sel];
> +
> +	switch (pos) {
> +	case VIRTIO_MDEV_DEVICE_FEATURES_SEL:
> +		mvnet->device_features_sel = *val;
> +		break;
> +	case VIRTIO_MDEV_DRIVER_FEATURES:
> +		mvnet->driver_features[mvnet->driver_features_sel] = *val;
> +		break;
> +	case VIRTIO_MDEV_DRIVER_FEATURES_SEL:
> +		mvnet->driver_features_sel = *val;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_SEL:
> +		mvnet->queue_sel = *val;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_NUM:
> +		mvnet->num = *val;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_READY:
> +		vq->ready = *val;
> +		if (vq->ready) {
> +			spin_lock(&mvnet->lock);
> +			mvnet_queue_ready(mvnet, queue_sel);
> +			spin_unlock(&mvnet->lock);
> +		}
> +		break;
> +	case VIRTIO_MDEV_QUEUE_NOTIFY:
> +		if (vq->ready)
> +			schedule_work(&mvnet->work);
> +		break;
> +	case VIRTIO_MDEV_STATUS:
> +		mvnet->status = *val;
> +		if (*val == 0) {
> +			spin_lock(&mvnet->lock);
> +			mvnet_reset(mvnet);
> +			spin_unlock(&mvnet->lock);
> +		}
> +		break;
> +	case VIRTIO_MDEV_QUEUE_DESC_LOW:
> +		vq->desc_addr_lo = *val;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_DESC_HIGH:
> +		vq->desc_addr_hi = *val;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_AVAIL_LOW:
> +		vq->driver_addr_lo = *val;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_AVAIL_HIGH:
> +		vq->driver_addr_hi = *val;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_USED_LOW:
> +		vq->device_addr_lo = *val;
> +		break;
> +	case VIRTIO_MDEV_QUEUE_USED_HIGH:
> +		vq->device_addr_hi = *val;
> +		break;
> +	default:
> +		pr_err("Unsupported write offset! 0x%x\n", pos);
> +		break;
> +	}
> +	spin_unlock(&mvnet->lock);
> +
> +	return 4;
> +}
> +
> +static void mvnet_work(struct work_struct *work)
> +{
> +	struct mvnet_state *mvnet = container_of(work, struct
> +						 mvnet_state, work);
> +	struct mvnet_virtqueue *txq = &mvnet->vqs[1];
> +	struct mvnet_virtqueue *rxq = &mvnet->vqs[0];
> +	size_t read, write, total_write;
> +	unsigned long flags;
> +	int err;
> +	int pkts = 0;
> +
> +	spin_lock(&mvnet->lock);
> +
> +	if (!txq->ready || !rxq->ready)
> +		goto out;
> +
> +	while (true) {
> +		total_write = 0;
> +		err = vringh_getdesc_kern(&txq->vring, &txq->iov, NULL,
> +					  &txq->head, GFP_KERNEL);
> +		if (err <= 0)
> +			break;
> +
> +		err = vringh_getdesc_kern(&rxq->vring, NULL, &rxq->iov,
> +					  &rxq->head, GFP_KERNEL);


GFP_KERNEL under a spin_lock will cause deadlocks.


> +		if (err <= 0) {
> +			vringh_complete_kern(&txq->vring, txq->head, 0);
> +			break;
> +		}
> +
> +		while (true) {
> +			read = vringh_iov_pull_kern(&txq->iov, mvnet->buffer,
> +						    PAGE_SIZE);
> +			if (read <= 0)
> +				break;
> +
> +			write = vringh_iov_push_kern(&rxq->iov, mvnet->buffer,
> +						     read);
> +			if (write <= 0)
> +				break;
> +
> +			total_write += write;
> +		}
> +
> +		/* Make sure data is wrote before advancing index */
> +		smp_wmb();
> +
> +		vringh_complete_kern(&txq->vring, txq->head, 0);
> +		vringh_complete_kern(&rxq->vring, rxq->head, total_write);
> +
> +		/* Make sure used is visible before rasing the
> +		   interrupt */
> +		smp_wmb();
> +
> +		local_bh_disable();
> +		if (txq->cb)
> +			txq->cb(txq->private);
> +		if (rxq->cb)
> +			rxq->cb(rxq->private);
> +		local_bh_enable();
> +
> +		pkts ++;

coding style problem

> +		if (pkts > 4) {
> +			schedule_work(&mvnet->work);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	spin_unlock(&mvnet->lock);
> +}
> +
> +static dma_addr_t mvnet_map_page(struct device *dev, struct page *page,
> +				 unsigned long offset, size_t size,
> +				 enum dma_data_direction dir,
> +				 unsigned long attrs)
> +{
> +	/* Vringh can only use VA */
> +	return page_address(page) + offset;
> +}
> +
> +static void mvnet_unmap_page(struct device *dev, dma_addr_t dma_addr,
> +			     size_t size, enum dma_data_direction dir,
> +			     unsigned long attrs)
> +{
> +	return ;
> +}
> +
> +static void *mvnet_alloc_coherent(struct device *dev, size_t size,
> +				  dma_addr_t *dma_addr, gfp_t flag,
> +				  unsigned long attrs)
> +{
> +	void *ret = kmalloc(size, flag);
> +
> +	if (ret == NULL)

!ret is nicer

> +		*dma_addr = DMA_MAPPING_ERROR;
> +	else
> +		*dma_addr = ret;

Not sure how does this build ... don't we need a cast?

> +
> +	return ret;
> +}
> +
> +static void mvnet_free_coherent(struct device *dev, size_t size,
> +				void *vaddr, dma_addr_t dma_addr,
> +				unsigned long attrs)
> +{
> +	kfree(dma_addr);
> +}
> +
> +static const struct dma_map_ops mvnet_dma_ops = {
> +	.map_page = mvnet_map_page,
> +	.unmap_page = mvnet_unmap_page,
> +	.alloc = mvnet_alloc_coherent,
> +	.free = mvnet_free_coherent,
> +};
> +
> +static int mvnet_create(struct kobject *kobj, struct mdev_device *mdev)
> +{
> +	struct mvnet_state *mvnet;
> +	struct virtio_net_config *config;
> +
> +	if (!mdev)
> +		return -EINVAL;
> +
> +	mvnet = kzalloc(sizeof(struct mvnet_state), GFP_KERNEL);
> +	if (mvnet == NULL)
> +		return -ENOMEM;
> +
> +	mvnet->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!mvnet->buffer) {
> +		kfree(mvnet);
> +		return -ENOMEM;
> +	}
> +
> +	config = &mvnet->config;
> +	config->mtu = 1500;
> +	config->status = VIRTIO_NET_S_LINK_UP;
> +	eth_random_addr(config->mac);
> +
> +	INIT_WORK(&mvnet->work, mvnet_work);
> +
> +	spin_lock_init(&mvnet->lock);
> +	mvnet->mdev = mdev;
> +	mdev_set_drvdata(mdev, mvnet);
> +
> +	mutex_lock(&mdev_list_lock);
> +	list_add(&mvnet->next, &mdev_devices_list);
> +	mutex_unlock(&mdev_list_lock);
> +
> +	mdev_set_dma_ops(mdev, &mvnet_dma_ops);
> +
> +	return 0;
> +}
> +
> +static int mvnet_remove(struct mdev_device *mdev)
> +{
> +	struct mvnet_state *mds, *tmp_mds;
> +	struct mvnet_state *mvnet = mdev_get_drvdata(mdev);
> +	int ret = -EINVAL;
> +
> +	mutex_lock(&mdev_list_lock);
> +	list_for_each_entry_safe(mds, tmp_mds, &mdev_devices_list, next) {
> +		if (mvnet == mds) {
> +			list_del(&mvnet->next);
> +			mdev_set_drvdata(mdev, NULL);
> +			kfree(mvnet->buffer);
> +			kfree(mvnet);
> +			ret = 0;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&mdev_list_lock);
> +
> +	return ret;
> +}
> +
> +static ssize_t mvnet_read(struct mdev_device *mdev, char __user *buf,
> +			  size_t count, loff_t *ppos)
> +{
> +	ssize_t ret;
> +
> +	if (*ppos < VIRTIO_MDEV_CONFIG) {
> +		if (count == 4)
> +			ret = mvnet_read_config(mdev, (u32 *)buf, *ppos);
> +		else
> +			ret = -EINVAL;
> +		*ppos += 4;
> +	} else if (*ppos < VIRTIO_MDEV_CONFIG + sizeof(struct virtio_net_config)) {
> +		ret = mvnet_read_net_config(mdev, buf, count,
> +					    *ppos - VIRTIO_MDEV_CONFIG);
> +		*ppos += count;
> +	} else {
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t mvnet_write(struct mdev_device *mdev, const char __user *buf,
> +			   size_t count, loff_t *ppos)
> +{
> +	int ret;
> +
> +	if (*ppos < VIRTIO_MDEV_CONFIG) {
> +		if (count == 4)
> +			ret = mvnet_write_config(mdev, (u32 *)buf, *ppos);
> +		else
> +			ret = -EINVAL;
> +		*ppos += 4;
> +	} else {
> +		/* No writable net config */
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static long mvnet_ioctl(struct mdev_device *mdev, unsigned int cmd,
> +			unsigned long arg)
> +{
> +	int ret = 0;
> +	struct mvnet_state *mvnet;
> +	struct virtio_mdev_callback *cb;
> +
> +	if (!mdev)
> +		return -EINVAL;
> +
> +	mvnet = mdev_get_drvdata(mdev);
> +	if (!mvnet)
> +		return -ENODEV;
> +
> +	spin_lock(&mvnet->lock);
> +
> +	switch (cmd) {
> +	case VIRTIO_MDEV_SET_VQ_CALLBACK:
> +		cb = (struct virtio_mdev_callback *)arg;
> +		mvnet->vqs[mvnet->queue_sel].cb = cb->callback;
> +		mvnet->vqs[mvnet->queue_sel].private = cb->private;
> +		break;
> +	case VIRTIO_MDEV_SET_CONFIG_CALLBACK:
> +		break;

success, but nothing happens.

> +	default:
> +		pr_err("Not supportted ioctl cmd 0x%x\n", cmd);
> +		ret = -ENOTTY;
> +		break;
> +	}
> +
> +	spin_unlock(&mvnet->lock);
> +
> +	return ret;
> +}
> +
> +static int mvnet_open(struct mdev_device *mdev)
> +{
> +	pr_info("%s\n", __func__);
> +	return 0;
> +}
> +
> +static void mvnet_close(struct mdev_device *mdev)
> +{
> +	pr_info("%s\n", __func__);
> +}
> +
> +static ssize_t
> +sample_mvnet_dev_show(struct device *dev, struct device_attribute *attr,
> +		     char *buf)
> +{
> +	return sprintf(buf, "This is phy device\n");


what's this?

> +}
> +
> +static DEVICE_ATTR_RO(sample_mvnet_dev);
> +
> +static struct attribute *mvnet_dev_attrs[] = {
> +	&dev_attr_sample_mvnet_dev.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group mvnet_dev_group = {
> +	.name  = "mvnet_dev",
> +	.attrs = mvnet_dev_attrs,
> +};
> +
> +static const struct attribute_group *mvnet_dev_groups[] = {
> +	&mvnet_dev_group,
> +	NULL,
> +};
> +
> +static ssize_t
> +sample_mdev_dev_show(struct device *dev, struct device_attribute *attr,
> +		     char *buf)
> +{
> +	if (mdev_from_dev(dev))
> +		return sprintf(buf, "This is MDEV %s\n", dev_name(dev));
> +
> +	return sprintf(buf, "\n");
> +}
> +
> +static DEVICE_ATTR_RO(sample_mdev_dev);
> +
> +static struct attribute *mdev_dev_attrs[] = {
> +	&dev_attr_sample_mdev_dev.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group mdev_dev_group = {
> +	.name  = "vendor",
> +	.attrs = mdev_dev_attrs,
> +};
> +
> +static const struct attribute_group *mdev_dev_groups[] = {
> +	&mdev_dev_group,
> +	NULL,
> +};
> +
> +#define MVNET_STRING_LEN 16
> +
> +static ssize_t
> +name_show(struct kobject *kobj, struct device *dev, char *buf)
> +{
> +	char name[MVNET_STRING_LEN];
> +	const char *name_str = "virtio-net";
> +
> +	snprintf(name, MVNET_STRING_LEN, "%s", dev_driver_string(dev));
> +	if (!strcmp(kobj->name, name))
> +		return sprintf(buf, "%s\n", name_str);
> +
> +	return -EINVAL;
> +}
> +
> +static MDEV_TYPE_ATTR_RO(name);
> +
> +static ssize_t
> +available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
> +{
> +	return sprintf(buf, "%d\n", INT_MAX);
> +}
> +
> +static MDEV_TYPE_ATTR_RO(available_instances);


?

> +
> +static ssize_t device_api_show(struct kobject *kobj, struct device *dev,
> +			       char *buf)
> +{
> +	return sprintf(buf, "%s\n", VIRTIO_MDEV_DEVICE_API_STRING);
> +}
> +
> +static MDEV_TYPE_ATTR_RO(device_api);
> +
> +static struct attribute *mdev_types_attrs[] = {
> +	&mdev_type_attr_name.attr,
> +	&mdev_type_attr_device_api.attr,
> +	&mdev_type_attr_available_instances.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mdev_type_group = {
> +	.name  = "",
> +	.attrs = mdev_types_attrs,
> +};
> +
> +static struct attribute_group *mdev_type_groups[] = {
> +	&mdev_type_group,
> +	NULL,
> +};
> +
> +static const struct mdev_parent_ops mdev_fops = {
> +	.owner                  = THIS_MODULE,
> +	.dev_attr_groups        = mvnet_dev_groups,
> +	.mdev_attr_groups       = mdev_dev_groups,
> +	.supported_type_groups  = mdev_type_groups,
> +	.create                 = mvnet_create,
> +	.remove			= mvnet_remove,
> +	.open                   = mvnet_open,
> +	.release                = mvnet_close,
> +	.read                   = mvnet_read,
> +	.write                  = mvnet_write,
> +	.ioctl		        = mvnet_ioctl,
> +};
> +
> +static void mvnet_device_release(struct device *dev)
> +{
> +	dev_dbg(dev, "mvnet: released\n");
> +}
> +
> +static int __init mvnet_dev_init(void)
> +{
> +	int ret = 0;
> +
> +	pr_info("mvnet_dev: %s\n", __func__);
> +
> +	memset(&mvnet_dev, 0, sizeof(mvnet_dev));
> +
> +	idr_init(&mvnet_dev.vd_idr);
> +
> +	mvnet_dev.vd_class = class_create(THIS_MODULE, MVNET_CLASS_NAME);
> +
> +	if (IS_ERR(mvnet_dev.vd_class)) {
> +		pr_err("Error: failed to register mvnet_dev class\n");
> +		ret = PTR_ERR(mvnet_dev.vd_class);
> +		goto failed1;
> +	}
> +
> +	mvnet_dev.dev.class = mvnet_dev.vd_class;
> +	mvnet_dev.dev.release = mvnet_device_release;
> +	dev_set_name(&mvnet_dev.dev, "%s", MVNET_NAME);
> +
> +	ret = device_register(&mvnet_dev.dev);
> +	if (ret)
> +		goto failed2;
> +
> +	ret = mdev_register_device(&mvnet_dev.dev, &mdev_fops);
> +	if (ret)
> +		goto failed3;
> +
> +	mutex_init(&mdev_list_lock);
> +	INIT_LIST_HEAD(&mdev_devices_list);
> +
> +	goto all_done;
> +
> +failed3:
> +
> +	device_unregister(&mvnet_dev.dev);
> +failed2:
> +	class_destroy(mvnet_dev.vd_class);
> +
> +failed1:
> +all_done:
> +	return ret;
> +}
> +
> +static void __exit mvnet_dev_exit(void)
> +{
> +	mvnet_dev.dev.bus = NULL;
> +	mdev_unregister_device(&mvnet_dev.dev);
> +
> +	device_unregister(&mvnet_dev.dev);
> +	idr_destroy(&mvnet_dev.vd_idr);
> +	class_destroy(mvnet_dev.vd_class);
> +	mvnet_dev.vd_class = NULL;
> +	pr_info("mvnet_dev: Unloaded!\n");
> +}
> +
> +module_init(mvnet_dev_init)
> +module_exit(mvnet_dev_exit)
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_INFO(supported, "Test driver that simulate serial port over PCI");
> +MODULE_VERSION(VERSION_STRING);
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> -- 
> 2.19.1
