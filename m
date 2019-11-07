Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953D0F38D2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfKGTjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:39:53 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10382 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfKGTjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 14:39:52 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc472c60000>; Thu, 07 Nov 2019 11:38:46 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 07 Nov 2019 11:39:46 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 07 Nov 2019 11:39:46 -0800
Received: from [10.25.75.102] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Nov
 2019 19:39:24 +0000
Subject: Re: [PATCH V11 3/6] mdev: introduce device specific ops
To:     Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <alex.williamson@redhat.com>, <mst@redhat.com>,
        <tiwei.bie@intel.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <cohuck@redhat.com>,
        <maxime.coquelin@redhat.com>, <cunming.liang@intel.com>,
        <zhihong.wang@intel.com>, <rob.miller@broadcom.com>,
        <xiao.w.wang@intel.com>, <haotian.wang@sifive.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
        <farman@linux.ibm.com>, <pasic@linux.ibm.com>,
        <sebott@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <heiko.carstens@de.ibm.com>, <gor@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <akrowiak@linux.ibm.com>,
        <freude@linux.ibm.com>, <lingshan.zhu@intel.com>,
        <eperezma@redhat.com>, <lulu@redhat.com>, <parav@mellanox.com>,
        <christophe.de.dinechin@gmail.com>, <kevin.tian@intel.com>,
        <stefanha@redhat.com>, <rdunlap@infradead.org>
References: <20191107151109.23261-1-jasowang@redhat.com>
 <20191107151109.23261-4-jasowang@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <26a2dedf-c8c6-ba0b-1a73-9fec082d572e@nvidia.com>
Date:   Fri, 8 Nov 2019 01:09:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191107151109.23261-4-jasowang@redhat.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573155526; bh=huOsw4TCJvN0fCSwZr8zZKc46u8D7LDIYCH44uLPByk=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=fgFJhL4ZMHKuwtWgiTjpTbe0lBksRKOjY6CgrMRKwQiGok3kEWAIQmMac9Mhf2X0X
         6BbW1W1QFzsqi2Hw3PReZOgC+2zx5o2Gp9evETcX6ci6lFkkf4FRyksddGIO86bMRe
         sD3apfwEjPF8f9wzwelk/Y/CmCSvIuQfNEEAkPE8GPwwtWsCkzw8QIKlzXFrRg+x1F
         ZoTYAQ1Gpn1kEh+UTrtFNTOn1izXHKm0nT7onq0h4KbCEIMxoROUt71aEqF4qvIEU/
         FEyH0UTIuA6XZh3kqHvnkC8OkXEJi2R/tHF2yZ9M+QsLd/fr59aJOZ2Bjm5q7ML9gt
         bOVvAHVMCJFpg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/7/2019 8:41 PM, Jason Wang wrote:
> Currently, except for the create and remove, the rest of
> mdev_parent_ops is designed for vfio-mdev driver only and may not help
> for kernel mdev driver. With the help of class id, this patch
> introduces device specific callbacks inside mdev_device
> structure. This allows different set of callback to be used by
> vfio-mdev and virtio-mdev.
> 
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>


Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

Thanks,
Kirti

> ---
>   .../driver-api/vfio-mediated-device.rst       | 35 +++++++++----
>   MAINTAINERS                                   |  1 +
>   drivers/gpu/drm/i915/gvt/kvmgt.c              | 18 ++++---
>   drivers/s390/cio/vfio_ccw_ops.c               | 18 ++++---
>   drivers/s390/crypto/vfio_ap_ops.c             | 14 +++--
>   drivers/vfio/mdev/mdev_core.c                 | 24 ++++++++-
>   drivers/vfio/mdev/mdev_private.h              |  5 ++
>   drivers/vfio/mdev/vfio_mdev.c                 | 37 ++++++-------
>   include/linux/mdev.h                          | 43 ++++-----------
>   include/linux/mdev_vfio_ops.h                 | 52 +++++++++++++++++++
>   samples/vfio-mdev/mbochs.c                    | 20 ++++---
>   samples/vfio-mdev/mdpy.c                      | 20 ++++---
>   samples/vfio-mdev/mtty.c                      | 18 ++++---
>   13 files changed, 206 insertions(+), 99 deletions(-)
>   create mode 100644 include/linux/mdev_vfio_ops.h
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 6709413bee29..04d56884c357 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -152,15 +152,6 @@ callbacks per mdev parent device, per mdev type, or any other categorization.
>   Vendor drivers are expected to be fully asynchronous in this respect or
>   provide their own internal resource protection.)
>   
> -The callbacks in the mdev_parent_ops structure are as follows:
> -
> -* open: open callback of mediated device
> -* close: close callback of mediated device
> -* ioctl: ioctl callback of mediated device
> -* read : read emulation callback
> -* write: write emulation callback
> -* mmap: mmap emulation callback
> -
>   A driver should use the mdev_parent_ops structure in the function call to
>   register itself with the mdev core driver::
>   
> @@ -172,10 +163,34 @@ that a driver should use to unregister itself with the mdev core driver::
>   
>   	extern void mdev_unregister_device(struct device *dev);
>   
> -It is also required to specify the class_id in create() callback through::
> +As multiple types of mediated devices may be supported, class id needs
> +to be specified in the create() callback. This could be done
> +explicitly for the device that interacts with the mdev device directly
> +through::
>   
>   	int mdev_set_class(struct mdev_device *mdev, u16 id);
>   
> +For the device that uses the mdev bus for its operation, the class
> +should provide helper function to set class id and device specific
> +ops. E.g for vfio-mdev devices, the function to be called is::
> +
> +	int mdev_set_vfio_ops(struct mdev_device *mdev,
> +                              const struct mdev_vfio_device_ops *vfio_ops);
> +
> +The class id (set by this function to MDEV_CLASS_ID_VFIO) is used to
> +match a device with an mdev driver via its id table. The device
> +specific callbacks (specified in *vfio_ops) are obtainable via
> +mdev_get_vfio_ops() (for use by the mdev bus driver). A vfio-mdev
> +device (class id MDEV_CLASS_ID_VFIO) uses the following
> +device-specific ops:
> +
> +* open: open callback of vfio mediated device
> +* close: close callback of vfio mediated device
> +* ioctl: ioctl callback of vfio mediated device
> +* read : read emulation callback
> +* write: write emulation callback
> +* mmap: mmap emulation callback
> +
>   Mediated Device Management Interface Through sysfs
>   ==================================================
>   
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cba1095547fd..f661d13344d6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17121,6 +17121,7 @@ S:	Maintained
>   F:	Documentation/driver-api/vfio-mediated-device.rst
>   F:	drivers/vfio/mdev/
>   F:	include/linux/mdev.h
> +F:	include/linux/mdev_vfio_ops.h
>   F:	samples/vfio-mdev/
>   
>   VFIO PLATFORM DRIVER
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 6420f0dbd31b..662f3a672372 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -42,6 +42,7 @@
>   #include <linux/kvm_host.h>
>   #include <linux/vfio.h>
>   #include <linux/mdev.h>
> +#include <linux/mdev_vfio_ops.h>
>   #include <linux/debugfs.h>
>   
>   #include <linux/nospec.h>
> @@ -643,6 +644,8 @@ static void kvmgt_put_vfio_device(void *vgpu)
>   	vfio_device_put(((struct intel_vgpu *)vgpu)->vdev.vfio_device);
>   }
>   
> +static const struct mdev_vfio_device_ops intel_vfio_vgpu_dev_ops;
> +
>   static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
>   {
>   	struct intel_vgpu *vgpu = NULL;
> @@ -678,7 +681,7 @@ static int intel_vgpu_create(struct kobject *kobj, struct mdev_device *mdev)
>   		     dev_name(mdev_dev(mdev)));
>   	ret = 0;
>   
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &intel_vfio_vgpu_dev_ops);
>   out:
>   	return ret;
>   }
> @@ -1599,20 +1602,21 @@ static const struct attribute_group *intel_vgpu_groups[] = {
>   	NULL,
>   };
>   
> -static struct mdev_parent_ops intel_vgpu_ops = {
> -	.mdev_attr_groups       = intel_vgpu_groups,
> -	.create			= intel_vgpu_create,
> -	.remove			= intel_vgpu_remove,
> -
> +static const struct mdev_vfio_device_ops intel_vfio_vgpu_dev_ops = {
>   	.open			= intel_vgpu_open,
>   	.release		= intel_vgpu_release,
> -
>   	.read			= intel_vgpu_read,
>   	.write			= intel_vgpu_write,
>   	.mmap			= intel_vgpu_mmap,
>   	.ioctl			= intel_vgpu_ioctl,
>   };
>   
> +static struct mdev_parent_ops intel_vgpu_ops = {
> +	.mdev_attr_groups       = intel_vgpu_groups,
> +	.create			= intel_vgpu_create,
> +	.remove			= intel_vgpu_remove,
> +};
> +
>   static int kvmgt_host_init(struct device *dev, void *gvt, const void *ops)
>   {
>   	struct attribute **kvm_type_attrs;
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index cf2c013ae32f..fa473ded71c7 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -12,6 +12,7 @@
>   
>   #include <linux/vfio.h>
>   #include <linux/mdev.h>
> +#include <linux/mdev_vfio_ops.h>
>   #include <linux/nospec.h>
>   #include <linux/slab.h>
>   
> @@ -110,6 +111,8 @@ static struct attribute_group *mdev_type_groups[] = {
>   	NULL,
>   };
>   
> +static const struct mdev_vfio_device_ops mdev_vfio_ops;
> +
>   static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>   {
>   	struct vfio_ccw_private *private =
> @@ -129,7 +132,7 @@ static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>   			   private->sch->schid.ssid,
>   			   private->sch->schid.sch_no);
>   
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &mdev_vfio_ops);
>   	return 0;
>   }
>   
> @@ -575,11 +578,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
>   	}
>   }
>   
> -static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
> -	.owner			= THIS_MODULE,
> -	.supported_type_groups  = mdev_type_groups,
> -	.create			= vfio_ccw_mdev_create,
> -	.remove			= vfio_ccw_mdev_remove,
> +static const struct mdev_vfio_device_ops mdev_vfio_ops = {
>   	.open			= vfio_ccw_mdev_open,
>   	.release		= vfio_ccw_mdev_release,
>   	.read			= vfio_ccw_mdev_read,
> @@ -587,6 +586,13 @@ static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
>   	.ioctl			= vfio_ccw_mdev_ioctl,
>   };
>   
> +static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
> +	.owner			= THIS_MODULE,
> +	.supported_type_groups  = mdev_type_groups,
> +	.create			= vfio_ccw_mdev_create,
> +	.remove			= vfio_ccw_mdev_remove,
> +};
> +
>   int vfio_ccw_mdev_reg(struct subchannel *sch)
>   {
>   	return mdev_register_device(&sch->dev, &vfio_ccw_mdev_ops);
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 07c31070afeb..7bdc62393112 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -16,6 +16,7 @@
>   #include <linux/bitops.h>
>   #include <linux/kvm_host.h>
>   #include <linux/module.h>
> +#include <linux/mdev_vfio_ops.h>
>   #include <asm/kvm.h>
>   #include <asm/zcrypt.h>
>   
> @@ -321,6 +322,8 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>   	matrix->adm_max = info->apxa ? info->Nd : 15;
>   }
>   
> +static const struct mdev_vfio_device_ops mdev_vfio_ops;
> +
>   static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>   {
>   	struct ap_matrix_mdev *matrix_mdev;
> @@ -343,7 +346,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>   	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>   	mutex_unlock(&matrix_dev->lock);
>   
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &mdev_vfio_ops);
>   	return 0;
>   }
>   
> @@ -1281,15 +1284,18 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>   	return ret;
>   }
>   
> +static const struct mdev_vfio_device_ops mdev_vfio_ops = {
> +	.open			= vfio_ap_mdev_open,
> +	.release		= vfio_ap_mdev_release,
> +	.ioctl			= vfio_ap_mdev_ioctl,
> +};
> +
>   static const struct mdev_parent_ops vfio_ap_matrix_ops = {
>   	.owner			= THIS_MODULE,
>   	.supported_type_groups	= vfio_ap_mdev_type_groups,
>   	.mdev_attr_groups	= vfio_ap_mdev_attr_groups,
>   	.create			= vfio_ap_mdev_create,
>   	.remove			= vfio_ap_mdev_remove,
> -	.open			= vfio_ap_mdev_open,
> -	.release		= vfio_ap_mdev_release,
> -	.ioctl			= vfio_ap_mdev_ioctl,
>   };
>   
>   int vfio_ap_mdev_register(void)
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 7bfa2e46e829..4e70f19ac145 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -47,7 +47,8 @@ EXPORT_SYMBOL(mdev_set_drvdata);
>   
>   /*
>    * Specify the class for the mdev device, this must be called during
> - * create() callback.
> + * create() callback explicitly or implicitly through the helpers
> + * provided by each class.
>    */
>   void mdev_set_class(struct mdev_device *mdev, u16 id)
>   {
> @@ -56,6 +57,27 @@ void mdev_set_class(struct mdev_device *mdev, u16 id)
>   }
>   EXPORT_SYMBOL(mdev_set_class);
>   
> +/*
> + * Specify the mdev device to be a VFIO mdev device, and set VFIO
> + * device ops for it. This must be called from the create() callback
> + * for VFIO mdev device.
> + */
> +void mdev_set_vfio_ops(struct mdev_device *mdev,
> +		       const struct mdev_vfio_device_ops *vfio_ops)
> +{
> +	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev->vfio_ops = vfio_ops;
> +}
> +EXPORT_SYMBOL(mdev_set_vfio_ops);
> +
> +/* Get the VFIO device ops for the mdev device. */
> +const struct mdev_vfio_device_ops *mdev_get_vfio_ops(struct mdev_device *mdev)
> +{
> +	WARN_ON(mdev->class_id != MDEV_CLASS_ID_VFIO);
> +	return mdev->vfio_ops;
> +}
> +EXPORT_SYMBOL(mdev_get_vfio_ops);
> +
>   struct device *mdev_dev(struct mdev_device *mdev)
>   {
>   	return &mdev->dev;
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index c65f436c1869..411227373625 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -10,6 +10,8 @@
>   #ifndef MDEV_PRIVATE_H
>   #define MDEV_PRIVATE_H
>   
> +#include <linux/mdev_vfio_ops.h>
> +
>   int  mdev_bus_register(void);
>   void mdev_bus_unregister(void);
>   
> @@ -34,6 +36,9 @@ struct mdev_device {
>   	struct device *iommu_device;
>   	bool active;
>   	u16 class_id;
> +	union {
> +		const struct mdev_vfio_device_ops *vfio_ops;
> +	};
>   };
>   
>   #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> index a6641cd8b5a3..c01e2194e4b3 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -14,6 +14,7 @@
>   #include <linux/slab.h>
>   #include <linux/vfio.h>
>   #include <linux/mdev.h>
> +#include <linux/mdev_vfio_ops.h>
>   
>   #include "mdev_private.h"
>   
> @@ -24,16 +25,16 @@
>   static int vfio_mdev_open(void *device_data)
>   {
>   	struct mdev_device *mdev = device_data;
> -	struct mdev_parent *parent = mdev->parent;
> +	const struct mdev_vfio_device_ops *ops = mdev_get_vfio_ops(mdev);
>   	int ret;
>   
> -	if (unlikely(!parent->ops->open))
> +	if (unlikely(!ops->open))
>   		return -EINVAL;
>   
>   	if (!try_module_get(THIS_MODULE))
>   		return -ENODEV;
>   
> -	ret = parent->ops->open(mdev);
> +	ret = ops->open(mdev);
>   	if (ret)
>   		module_put(THIS_MODULE);
>   
> @@ -43,10 +44,10 @@ static int vfio_mdev_open(void *device_data)
>   static void vfio_mdev_release(void *device_data)
>   {
>   	struct mdev_device *mdev = device_data;
> -	struct mdev_parent *parent = mdev->parent;
> +	const struct mdev_vfio_device_ops *ops = mdev_get_vfio_ops(mdev);
>   
> -	if (likely(parent->ops->release))
> -		parent->ops->release(mdev);
> +	if (likely(ops->release))
> +		ops->release(mdev);
>   
>   	module_put(THIS_MODULE);
>   }
> @@ -55,47 +56,47 @@ static long vfio_mdev_unlocked_ioctl(void *device_data,
>   				     unsigned int cmd, unsigned long arg)
>   {
>   	struct mdev_device *mdev = device_data;
> -	struct mdev_parent *parent = mdev->parent;
> +	const struct mdev_vfio_device_ops *ops = mdev_get_vfio_ops(mdev);
>   
> -	if (unlikely(!parent->ops->ioctl))
> +	if (unlikely(!ops->ioctl))
>   		return -EINVAL;
>   
> -	return parent->ops->ioctl(mdev, cmd, arg);
> +	return ops->ioctl(mdev, cmd, arg);
>   }
>   
>   static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
>   			      size_t count, loff_t *ppos)
>   {
>   	struct mdev_device *mdev = device_data;
> -	struct mdev_parent *parent = mdev->parent;
> +	const struct mdev_vfio_device_ops *ops = mdev_get_vfio_ops(mdev);
>   
> -	if (unlikely(!parent->ops->read))
> +	if (unlikely(!ops->read))
>   		return -EINVAL;
>   
> -	return parent->ops->read(mdev, buf, count, ppos);
> +	return ops->read(mdev, buf, count, ppos);
>   }
>   
>   static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
>   			       size_t count, loff_t *ppos)
>   {
>   	struct mdev_device *mdev = device_data;
> -	struct mdev_parent *parent = mdev->parent;
> +	const struct mdev_vfio_device_ops *ops = mdev_get_vfio_ops(mdev);
>   
> -	if (unlikely(!parent->ops->write))
> +	if (unlikely(!ops->write))
>   		return -EINVAL;
>   
> -	return parent->ops->write(mdev, buf, count, ppos);
> +	return ops->write(mdev, buf, count, ppos);
>   }
>   
>   static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
>   {
>   	struct mdev_device *mdev = device_data;
> -	struct mdev_parent *parent = mdev->parent;
> +	const struct mdev_vfio_device_ops *ops = mdev_get_vfio_ops(mdev);
>   
> -	if (unlikely(!parent->ops->mmap))
> +	if (unlikely(!ops->mmap))
>   		return -EINVAL;
>   
> -	return parent->ops->mmap(mdev, vma);
> +	return ops->mmap(mdev, vma);
>   }
>   
>   static const struct vfio_device_ops vfio_mdev_dev_ops = {
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 78b69d09eb54..9e37506d1987 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -10,7 +10,13 @@
>   #ifndef MDEV_H
>   #define MDEV_H
>   
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/mdev.h>
> +#include <uapi/linux/uuid.h>
> +
>   struct mdev_device;
> +struct mdev_vfio_device_ops;
>   
>   /*
>    * Called by the parent device driver to set the device which represents
> @@ -48,30 +54,7 @@ struct device *mdev_get_iommu_device(struct device *dev);
>    *			@mdev: mdev_device device structure which is being
>    *			       destroyed
>    *			Returns integer: success (0) or error (< 0)
> - * @open:		Open mediated device.
> - *			@mdev: mediated device.
> - *			Returns integer: success (0) or error (< 0)
> - * @release:		release mediated device
> - *			@mdev: mediated device.
> - * @read:		Read emulation callback
> - *			@mdev: mediated device structure
> - *			@buf: read buffer
> - *			@count: number of bytes to read
> - *			@ppos: address.
> - *			Retuns number on bytes read on success or error.
> - * @write:		Write emulation callback
> - *			@mdev: mediated device structure
> - *			@buf: write buffer
> - *			@count: number of bytes to be written
> - *			@ppos: address.
> - *			Retuns number on bytes written on success or error.
> - * @ioctl:		IOCTL callback
> - *			@mdev: mediated device structure
> - *			@cmd: ioctl command
> - *			@arg: arguments to ioctl
> - * @mmap:		mmap callback
> - *			@mdev: mediated device structure
> - *			@vma: vma structure
> + *
>    * Parent device that support mediated device should be registered with mdev
>    * module with mdev_parent_ops structure.
>    **/
> @@ -83,15 +66,6 @@ struct mdev_parent_ops {
>   
>   	int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
>   	int     (*remove)(struct mdev_device *mdev);
> -	int     (*open)(struct mdev_device *mdev);
> -	void    (*release)(struct mdev_device *mdev);
> -	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
> -			size_t count, loff_t *ppos);
> -	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
> -			 size_t count, loff_t *ppos);
> -	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> -			 unsigned long arg);
> -	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
>   };
>   
>   /* interface for exporting mdev supported type attributes */
> @@ -135,6 +109,9 @@ void *mdev_get_drvdata(struct mdev_device *mdev);
>   void mdev_set_drvdata(struct mdev_device *mdev, void *data);
>   const guid_t *mdev_uuid(struct mdev_device *mdev);
>   void mdev_set_class(struct mdev_device *mdev, u16 id);
> +void mdev_set_vfio_ops(struct mdev_device *mdev,
> +		       const struct mdev_vfio_device_ops *vfio_ops);
> +const struct mdev_vfio_device_ops *mdev_get_vfio_ops(struct mdev_device *mdev);
>   
>   extern struct bus_type mdev_bus_type;
>   
> diff --git a/include/linux/mdev_vfio_ops.h b/include/linux/mdev_vfio_ops.h
> new file mode 100644
> index 000000000000..317518f30621
> --- /dev/null
> +++ b/include/linux/mdev_vfio_ops.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * VFIO Mediated device definition
> + */
> +
> +#ifndef MDEV_VFIO_OPS_H
> +#define MDEV_VFIO_OPS_H
> +
> +#include <linux/mdev.h>
> +
> +/**
> + * struct mdev_vfio_device_ops - Structure to be registered for each
> + * mdev device to register the device to vfio-mdev module.
> + *
> + * @open:		Open mediated device.
> + *			@mdev: mediated device.
> + *			Returns integer: success (0) or error (< 0)
> + * @release:		release mediated device
> + *			@mdev: mediated device.
> + * @read:		Read emulation callback
> + *			@mdev: mediated device structure
> + *			@buf: read buffer
> + *			@count: number of bytes to read
> + *			@ppos: address.
> + *			Retuns number on bytes read on success or error.
> + * @write:		Write emulation callback
> + *			@mdev: mediated device structure
> + *			@buf: write buffer
> + *			@count: number of bytes to be written
> + *			@ppos: address.
> + *			Retuns number on bytes written on success or error.
> + * @ioctl:		IOCTL callback
> + *			@mdev: mediated device structure
> + *			@cmd: ioctl command
> + *			@arg: arguments to ioctl
> + * @mmap:		mmap callback
> + *			@mdev: mediated device structure
> + *			@vma: vma structure
> + */
> +struct mdev_vfio_device_ops {
> +	int     (*open)(struct mdev_device *mdev);
> +	void    (*release)(struct mdev_device *mdev);
> +	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
> +			size_t count, loff_t *ppos);
> +	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
> +			 size_t count, loff_t *ppos);
> +	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> +			 unsigned long arg);
> +	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> +};
> +
> +#endif
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 115bc5074656..12963767ba37 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -30,6 +30,7 @@
>   #include <linux/iommu.h>
>   #include <linux/sysfs.h>
>   #include <linux/mdev.h>
> +#include <linux/mdev_vfio_ops.h>
>   #include <linux/pci.h>
>   #include <linux/dma-buf.h>
>   #include <linux/highmem.h>
> @@ -516,6 +517,8 @@ static int mbochs_reset(struct mdev_device *mdev)
>   	return 0;
>   }
>   
> +static const struct mdev_vfio_device_ops mdev_vfio_ops;
> +
>   static int mbochs_create(struct kobject *kobj, struct mdev_device *mdev)
>   {
>   	const struct mbochs_type *type = mbochs_find_type(kobj);
> @@ -561,7 +564,7 @@ static int mbochs_create(struct kobject *kobj, struct mdev_device *mdev)
>   	mbochs_reset(mdev);
>   
>   	mbochs_used_mbytes += type->mbytes;
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &mdev_vfio_ops);
>   	return 0;
>   
>   err_mem:
> @@ -1419,12 +1422,7 @@ static struct attribute_group *mdev_type_groups[] = {
>   	NULL,
>   };
>   
> -static const struct mdev_parent_ops mdev_fops = {
> -	.owner			= THIS_MODULE,
> -	.mdev_attr_groups	= mdev_dev_groups,
> -	.supported_type_groups	= mdev_type_groups,
> -	.create			= mbochs_create,
> -	.remove			= mbochs_remove,
> +static const struct mdev_vfio_device_ops mdev_vfio_ops = {
>   	.open			= mbochs_open,
>   	.release		= mbochs_close,
>   	.read			= mbochs_read,
> @@ -1433,6 +1431,14 @@ static const struct mdev_parent_ops mdev_fops = {
>   	.mmap			= mbochs_mmap,
>   };
>   
> +static const struct mdev_parent_ops mdev_fops = {
> +	.owner			= THIS_MODULE,
> +	.mdev_attr_groups	= mdev_dev_groups,
> +	.supported_type_groups	= mdev_type_groups,
> +	.create			= mbochs_create,
> +	.remove			= mbochs_remove,
> +};
> +
>   static const struct file_operations vd_fops = {
>   	.owner		= THIS_MODULE,
>   };
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 665614574d50..50ee6c98b2af 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -26,6 +26,7 @@
>   #include <linux/iommu.h>
>   #include <linux/sysfs.h>
>   #include <linux/mdev.h>
> +#include <linux/mdev_vfio_ops.h>
>   #include <linux/pci.h>
>   #include <drm/drm_fourcc.h>
>   #include "mdpy-defs.h"
> @@ -226,6 +227,8 @@ static int mdpy_reset(struct mdev_device *mdev)
>   	return 0;
>   }
>   
> +static const struct mdev_vfio_device_ops mdev_vfio_ops;
> +
>   static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
>   {
>   	const struct mdpy_type *type = mdpy_find_type(kobj);
> @@ -269,7 +272,7 @@ static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
>   	mdpy_reset(mdev);
>   
>   	mdpy_count++;
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &mdev_vfio_ops);
>   	return 0;
>   }
>   
> @@ -726,12 +729,7 @@ static struct attribute_group *mdev_type_groups[] = {
>   	NULL,
>   };
>   
> -static const struct mdev_parent_ops mdev_fops = {
> -	.owner			= THIS_MODULE,
> -	.mdev_attr_groups	= mdev_dev_groups,
> -	.supported_type_groups	= mdev_type_groups,
> -	.create			= mdpy_create,
> -	.remove			= mdpy_remove,
> +static const struct mdev_vfio_device_ops mdev_vfio_ops = {
>   	.open			= mdpy_open,
>   	.release		= mdpy_close,
>   	.read			= mdpy_read,
> @@ -740,6 +738,14 @@ static const struct mdev_parent_ops mdev_fops = {
>   	.mmap			= mdpy_mmap,
>   };
>   
> +static const struct mdev_parent_ops mdev_fops = {
> +	.owner			= THIS_MODULE,
> +	.mdev_attr_groups	= mdev_dev_groups,
> +	.supported_type_groups	= mdev_type_groups,
> +	.create			= mdpy_create,
> +	.remove			= mdpy_remove,
> +};
> +
>   static const struct file_operations vd_fops = {
>   	.owner		= THIS_MODULE,
>   };
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 90da12ff7fd9..be476e7ad1f8 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -27,6 +27,7 @@
>   #include <linux/ctype.h>
>   #include <linux/file.h>
>   #include <linux/mdev.h>
> +#include <linux/mdev_vfio_ops.h>
>   #include <linux/pci.h>
>   #include <linux/serial.h>
>   #include <uapi/linux/serial_reg.h>
> @@ -708,6 +709,8 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
>   	return ret;
>   }
>   
> +static const struct mdev_vfio_device_ops vfio_dev_ops;
> +
>   static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
>   {
>   	struct mdev_state *mdev_state;
> @@ -755,7 +758,7 @@ static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
>   	list_add(&mdev_state->next, &mdev_devices_list);
>   	mutex_unlock(&mdev_list_lock);
>   
> -	mdev_set_class(mdev, MDEV_CLASS_ID_VFIO);
> +	mdev_set_vfio_ops(mdev, &vfio_dev_ops);
>   	return 0;
>   }
>   
> @@ -1388,6 +1391,14 @@ static struct attribute_group *mdev_type_groups[] = {
>   	NULL,
>   };
>   
> +static const struct mdev_vfio_device_ops vfio_dev_ops = {
> +	.open		= mtty_open,
> +	.release	= mtty_close,
> +	.read		= mtty_read,
> +	.write		= mtty_write,
> +	.ioctl		= mtty_ioctl,
> +};
> +
>   static const struct mdev_parent_ops mdev_fops = {
>   	.owner                  = THIS_MODULE,
>   	.dev_attr_groups        = mtty_dev_groups,
> @@ -1395,11 +1406,6 @@ static const struct mdev_parent_ops mdev_fops = {
>   	.supported_type_groups  = mdev_type_groups,
>   	.create                 = mtty_create,
>   	.remove			= mtty_remove,
> -	.open                   = mtty_open,
> -	.release                = mtty_close,
> -	.read                   = mtty_read,
> -	.write                  = mtty_write,
> -	.ioctl		        = mtty_ioctl,
>   };
>   
>   static void mtty_device_release(struct device *dev)
> 
