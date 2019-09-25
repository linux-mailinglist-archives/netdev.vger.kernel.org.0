Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECB6BDA95
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 11:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbfIYJJe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Sep 2019 05:09:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:38724 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbfIYJJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 05:09:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 02:09:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="191280732"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 25 Sep 2019 02:09:29 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 02:09:29 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 02:09:23 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.92]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 17:09:20 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "idos@mellanox.com" <idos@mellanox.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "christophe.de.dinechin@gmail.com" <christophe.de.dinechin@gmail.com>
Subject: RE: [PATCH V2 6/8] mdev: introduce virtio device and its device ops
Thread-Topic: [PATCH V2 6/8] mdev: introduce virtio device and its device ops
Thread-Index: AQHVct/nWfANpdabEEm3hvDI5WX0fqc8F18A
Date:   Wed, 25 Sep 2019 09:09:19 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F7DA@SHSMSX104.ccr.corp.intel.com>
References: <20190924135332.14160-1-jasowang@redhat.com>
 <20190924135332.14160-7-jasowang@redhat.com>
In-Reply-To: <20190924135332.14160-7-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjZkMjkzMjAtZTRmMy00NjZlLTg4NGQtMjk0MGE1YTdhNjhlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQStldm53XC92NkNoYndOZTZYXC9Fc1FPZEtpb3ZESVdKME9ZQ003eUw4U2tOZXl6THpyWFFoRWVkenNzc3BWclBQIn0=
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Tuesday, September 24, 2019 9:54 PM
> 
> This patch implements basic support for mdev driver that supports
> virtio transport for kernel virtio driver.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  include/linux/mdev.h        |   2 +
>  include/linux/virtio_mdev.h | 145
> ++++++++++++++++++++++++++++++++++++
>  2 files changed, 147 insertions(+)
>  create mode 100644 include/linux/virtio_mdev.h
> 
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 3414307311f1..73ac27b3b868 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -126,6 +126,8 @@ struct mdev_device *mdev_from_dev(struct device
> *dev);
> 
>  enum {
>  	MDEV_ID_VFIO = 1,
> +	MDEV_ID_VIRTIO = 2,
> +	MDEV_ID_VHOST = 3,
>  	/* New entries must be added here */
>  };
> 
> diff --git a/include/linux/virtio_mdev.h b/include/linux/virtio_mdev.h
> new file mode 100644
> index 000000000000..d1a40a739266
> --- /dev/null
> +++ b/include/linux/virtio_mdev.h
> @@ -0,0 +1,145 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Virtio mediated device driver
> + *
> + * Copyright 2019, Red Hat Corp.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + */
> +#ifndef _LINUX_VIRTIO_MDEV_H
> +#define _LINUX_VIRTIO_MDEV_H
> +
> +#include <linux/interrupt.h>
> +#include <linux/mdev.h>
> +#include <uapi/linux/vhost.h>
> +
> +#define VIRTIO_MDEV_DEVICE_API_STRING		"virtio-mdev"
> +#define VIRTIO_MDEV_VERSION 0x1

Just be curious. is this version identical to virtio spec version that below
callbacks are created for, or just irrelevant?

> +
> +struct virtio_mdev_callback {
> +	irqreturn_t (*callback)(void *data);
> +	void *private;
> +};
> +
> +/**
> + * struct vfio_mdev_device_ops - Structure to be registered for each
> + * mdev device to register the device to virtio-mdev module.
> + *
> + * @set_vq_address:		Set the address of virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@desc_area: address of desc area
> + *				@driver_area: address of driver area
> + *				@device_area: address of device area
> + *				Returns integer: success (0) or error (< 0)
> + * @set_vq_num:		Set the size of virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@num: the size of virtqueue
> + * @kick_vq:			Kick the virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + * @set_vq_cb:			Set the interrut calback function for
> + *				a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@cb: virtio-mdev interrupt callback
> structure
> + * @set_vq_ready:		Set ready status for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@ready: ready (true) not ready(false)
> + * @get_vq_ready:		Get ready status for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				Returns boolean: ready (true) or not (false)
> + * @set_vq_state:		Set the state for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				@state: virtqueue state (last_avail_idx)
> + *				Returns integer: success (0) or error (< 0)
> + * @get_vq_state:		Get the state for a virtqueue
> + *				@mdev: mediated device
> + *				@idx: virtqueue index
> + *				Returns virtqueue state (last_avail_idx)
> + * @get_vq_align:		Get the virtqueue align requirement
> + *				for the device
> + *				@mdev: mediated device
> + *				Returns virtqueue algin requirement
> + * @get_features:		Get virtio features supported by the device
> + *				@mdev: mediated device
> + *				Returns the features support by the
> + *				device
> + * @get_features:		Set virtio features supported by the driver
> + *				@mdev: mediated device
> + *				@features: feature support by the driver
> + *				Returns integer: success (0) or error (< 0)
> + * @set_config_cb:		Set the config interrupt callback
> + *				@mdev: mediated device
> + *				@cb: virtio-mdev interrupt callback
> structure
> + * @get_device_id:		Get virtio device id
> + *				@mdev: mediated device
> + *				Returns u32: virtio device id
> + * @get_vendor_id:		Get virtio vendor id
> + *				@mdev: mediated device
> + *				Returns u32: virtio vendor id
> + * @get_status:		Get the device status
> + *				@mdev: mediated device
> + *				Returns u8: virtio device status
> + * @set_status:		Set the device status
> + *				@mdev: mediated device
> + *				@status: virtio device status
> + * @get_config:		Read from device specific confiugration
> space

configuration (and similar typos downward)

> + *				@mdev: mediated device
> + *				@offset: offset from the beginning of
> + *				configuration space
> + *				@buf: buffer used to read to
> + *				@len: the length to read from
> + *				configration space
> + * @set_config:		Write to device specific confiugration space
> + *				@mdev: mediated device
> + *				@offset: offset from the beginning of
> + *				configuration space
> + *				@buf: buffer used to write from
> + *				@len: the length to write to
> + *				configration space
> + * @get_version:		Get the version of virtio mdev device
> + *				@mdev: mediated device
> + *				Returns integer: version of the device
> + * @get_generation:		Get device generaton
> + *				@mdev: mediated device
> + *				Returns u32: device generation
> + */
> +struct virtio_mdev_device_ops {
> +	/* Virtqueue ops */
> +	int (*set_vq_address)(struct mdev_device *mdev,
> +			      u16 idx, u64 desc_area, u64 driver_area,
> +			      u64 device_area);
> +	void (*set_vq_num)(struct mdev_device *mdev, u16 idx, u32 num);
> +	void (*kick_vq)(struct mdev_device *mdev, u16 idx);
> +	void (*set_vq_cb)(struct mdev_device *mdev, u16 idx,
> +			  struct virtio_mdev_callback *cb);
> +	void (*set_vq_ready)(struct mdev_device *mdev, u16 idx, bool
> ready);
> +	bool (*get_vq_ready)(struct mdev_device *mdev, u16 idx);
> +	int (*set_vq_state)(struct mdev_device *mdev, u16 idx, u64 state);
> +	u64 (*get_vq_state)(struct mdev_device *mdev, u16 idx);
> +
> +	/* Device ops */
> +	u16 (*get_vq_align)(struct mdev_device *mdev);
> +	u64 (*get_features)(struct mdev_device *mdev);
> +	int (*set_features)(struct mdev_device *mdev, u64 features);
> +	void (*set_config_cb)(struct mdev_device *mdev,
> +			      struct virtio_mdev_callback *cb);
> +	u16 (*get_queue_max)(struct mdev_device *mdev);
> +	u32 (*get_device_id)(struct mdev_device *mdev);
> +	u32 (*get_vendor_id)(struct mdev_device *mdev);
> +	u8 (*get_status)(struct mdev_device *mdev);
> +	void (*set_status)(struct mdev_device *mdev, u8 status);
> +	void (*get_config)(struct mdev_device *mdev, unsigned int offset,
> +			   void *buf, unsigned int len);
> +	void (*set_config)(struct mdev_device *mdev, unsigned int offset,
> +			   const void *buf, unsigned int len);
> +	int (*get_version)(struct mdev_device *mdev);
> +	u32 (*get_generation)(struct mdev_device *mdev);
> +};

I'm not sure how stable above ops are. Does it make sense if defining
just two callbacks here, e.g. vq_ctrl and device_ctrl, and then let the
vendor driver to handle specific ops in each category (similar to how
ioctl works)?

Thanks
Kevin

