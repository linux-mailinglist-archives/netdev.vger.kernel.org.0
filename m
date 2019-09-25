Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F76BD9D6
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 10:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634038AbfIYI2p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Sep 2019 04:28:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:32148 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436488AbfIYI2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 04:28:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 01:28:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="179749639"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga007.jf.intel.com with ESMTP; 25 Sep 2019 01:28:39 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 01:28:38 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 01:28:38 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.235]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 16:28:35 +0800
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
Subject: RE: [PATCH V2 2/8] mdev: class id support
Thread-Topic: [PATCH V2 2/8] mdev: class id support
Thread-Index: AQHVct+7DlVP09a1X0OvNOSnqEdmvKc8D6SA
Date:   Wed, 25 Sep 2019 08:28:35 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F6AE@SHSMSX104.ccr.corp.intel.com>
References: <20190924135332.14160-1-jasowang@redhat.com>
 <20190924135332.14160-3-jasowang@redhat.com>
In-Reply-To: <20190924135332.14160-3-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDU2ZDFkZDQtNjk3NS00YzkwLWEwMGItYWZkOTA5ODRjODVhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTm5nQlNodlwvQVpaK0VGN21hdTl1WmVoUUdSUlZJcmxyQlUxdGhXNldqNSsrTkVKK0RZTmxmMnhFUWpGOGQ5djQifQ==
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

> From: Jason Wang
> Sent: Tuesday, September 24, 2019 9:53 PM
> 
> Mdev bus only supports vfio driver right now, so it doesn't implement
> match method. But in the future, we may add drivers other than vfio,
> the first driver could be virtio-mdev. This means we need to add
> device class id support in bus match method to pair the mdev device
> and mdev driver correctly.
> 
> So this patch adds id_table to mdev_driver and class_id for mdev
> parent with the match method for mdev bus.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  Documentation/driver-api/vfio-mediated-device.rst |  3 +++
>  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  1 +
>  drivers/s390/cio/vfio_ccw_ops.c                   |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c                 |  1 +
>  drivers/vfio/mdev/mdev_core.c                     |  7 +++++++
>  drivers/vfio/mdev/mdev_driver.c                   | 14 ++++++++++++++
>  drivers/vfio/mdev/mdev_private.h                  |  1 +
>  drivers/vfio/mdev/vfio_mdev.c                     |  6 ++++++
>  include/linux/mdev.h                              |  8 ++++++++
>  include/linux/mod_devicetable.h                   |  8 ++++++++
>  samples/vfio-mdev/mbochs.c                        |  1 +
>  samples/vfio-mdev/mdpy.c                          |  1 +
>  samples/vfio-mdev/mtty.c                          |  1 +
>  13 files changed, 53 insertions(+)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 25eb7d5b834b..a5bdc60d62a1 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -102,12 +102,14 @@ structure to represent a mediated device's
> driver::
>        * @probe: called when new device created
>        * @remove: called when device removed
>        * @driver: device driver structure
> +      * @id_table: the ids serviced by this driver
>        */
>       struct mdev_driver {
>  	     const char *name;
>  	     int  (*probe)  (struct device *dev);
>  	     void (*remove) (struct device *dev);
>  	     struct device_driver    driver;
> +	     const struct mdev_class_id *id_table;
>       };
> 
>  A mediated bus driver for mdev should use this structure in the function
> calls
> @@ -165,6 +167,7 @@ register itself with the mdev core driver::
>  	extern int  mdev_register_device(struct device *dev,
>  	                                 const struct mdev_parent_ops *ops);
> 
> +
>  However, the mdev_parent_ops structure is not required in the function
> call
>  that a driver should use to unregister itself with the mdev core driver::
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 23aa3e50cbf8..f793252a3d2a 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -678,6 +678,7 @@ static int intel_vgpu_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  		     dev_name(mdev_dev(mdev)));
>  	ret = 0;
> 
> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>  out:
>  	return ret;
>  }
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> b/drivers/s390/cio/vfio_ccw_ops.c
> index f0d71ab77c50..d258ef1fedb9 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -129,6 +129,7 @@ static int vfio_ccw_mdev_create(struct kobject
> *kobj, struct mdev_device *mdev)
>  			   private->sch->schid.ssid,
>  			   private->sch->schid.sch_no);
> 
> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>  	return 0;
>  }
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 5c0f53c6dde7..2cfd96112aa0 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -343,6 +343,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj,
> struct mdev_device *mdev)
>  	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>  	mutex_unlock(&matrix_dev->lock);
> 
> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>  	return 0;
>  }
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index b558d4cfd082..8764cf4a276d 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -45,6 +45,12 @@ void mdev_set_drvdata(struct mdev_device *mdev,
> void *data)
>  }
>  EXPORT_SYMBOL(mdev_set_drvdata);
> 
> +void mdev_set_class_id(struct mdev_device *mdev, u16 id)
> +{
> +	mdev->class_id = id;
> +}
> +EXPORT_SYMBOL(mdev_set_class_id);
> +
>  struct device *mdev_dev(struct mdev_device *mdev)
>  {
>  	return &mdev->dev;
> @@ -135,6 +141,7 @@ static int mdev_device_remove_cb(struct device
> *dev, void *data)
>   * mdev_register_device : Register a device
>   * @dev: device structure representing parent device.
>   * @ops: Parent device operation structure to be registered.
> + * @id: device id.

class id.

>   *
>   * Add device to list of registered parent devices.
>   * Returns a negative value on error, otherwise 0.
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c
> index 0d3223aee20b..b7c40ce86ee3 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -69,8 +69,22 @@ static int mdev_remove(struct device *dev)
>  	return 0;
>  }
> 
> +static int mdev_match(struct device *dev, struct device_driver *drv)
> +{
> +	unsigned int i;
> +	struct mdev_device *mdev = to_mdev_device(dev);
> +	struct mdev_driver *mdrv = to_mdev_driver(drv);
> +	const struct mdev_class_id *ids = mdrv->id_table;
> +
> +	for (i = 0; ids[i].id; i++)
> +		if (ids[i].id == mdev->class_id)
> +			return 1;
> +	return 0;
> +}
> +
>  struct bus_type mdev_bus_type = {
>  	.name		= "mdev",
> +	.match		= mdev_match,
>  	.probe		= mdev_probe,
>  	.remove		= mdev_remove,
>  };
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 7d922950caaf..c65f436c1869 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -33,6 +33,7 @@ struct mdev_device {
>  	struct kobject *type_kobj;
>  	struct device *iommu_device;
>  	bool active;
> +	u16 class_id;
>  };
> 
>  #define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
> diff --git a/drivers/vfio/mdev/vfio_mdev.c
> b/drivers/vfio/mdev/vfio_mdev.c
> index 30964a4e0a28..fd2a4d9a3f26 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -120,10 +120,16 @@ static void vfio_mdev_remove(struct device *dev)
>  	vfio_del_group_dev(dev);
>  }
> 
> +static struct mdev_class_id id_table[] = {
> +	{ MDEV_ID_VFIO },
> +	{ 0 },
> +};
> +
>  static struct mdev_driver vfio_mdev_driver = {
>  	.name	= "vfio_mdev",
>  	.probe	= vfio_mdev_probe,
>  	.remove	= vfio_mdev_remove,
> +	.id_table = id_table,
>  };
> 
>  static int __init vfio_mdev_init(void)
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 0ce30ca78db0..3974650c074f 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -118,6 +118,7 @@ struct mdev_type_attribute
> mdev_type_attr_##_name =		\
>   * @probe: called when new device created
>   * @remove: called when device removed
>   * @driver: device driver structure
> + * @id_table: the ids serviced by this driver.
>   *
>   **/
>  struct mdev_driver {
> @@ -125,12 +126,14 @@ struct mdev_driver {
>  	int  (*probe)(struct device *dev);
>  	void (*remove)(struct device *dev);
>  	struct device_driver driver;
> +	const struct mdev_class_id *id_table;
>  };
> 
>  #define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver)
> 
>  void *mdev_get_drvdata(struct mdev_device *mdev);
>  void mdev_set_drvdata(struct mdev_device *mdev, void *data);
> +void mdev_set_class_id(struct mdev_device *mdev, u16 id);
>  const guid_t *mdev_uuid(struct mdev_device *mdev);
> 
>  extern struct bus_type mdev_bus_type;
> @@ -145,4 +148,9 @@ struct device *mdev_parent_dev(struct
> mdev_device *mdev);
>  struct device *mdev_dev(struct mdev_device *mdev);
>  struct mdev_device *mdev_from_dev(struct device *dev);
> 
> +enum {
> +	MDEV_ID_VFIO = 1,
> +	/* New entries must be added here */
> +};
> +
>  #endif /* MDEV_H */
> diff --git a/include/linux/mod_devicetable.h
> b/include/linux/mod_devicetable.h
> index 5714fd35a83c..f32c6e44fb1a 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -821,4 +821,12 @@ struct wmi_device_id {
>  	const void *context;
>  };
> 
> +/**
> + * struct mdev_class_id - MDEV device class identifier
> + * @id: Used to identify a specific class of device, e.g vfio-mdev device.
> + */
> +struct mdev_class_id {
> +	__u16 id;
> +};
> +
>  #endif /* LINUX_MOD_DEVICETABLE_H */
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index ac5c8c17b1ff..8a8583c892b2 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -561,6 +561,7 @@ static int mbochs_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	mbochs_reset(mdev);
> 
>  	mbochs_used_mbytes += type->mbytes;
> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>  	return 0;
> 
>  err_mem:
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index cc86bf6566e4..88d7e76f3836 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -269,6 +269,7 @@ static int mdpy_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	mdpy_reset(mdev);
> 
>  	mdpy_count++;
> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>  	return 0;
>  }
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 92e770a06ea2..4e0735143b69 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -770,6 +770,7 @@ static int mtty_create(struct kobject *kobj, struct
> mdev_device *mdev)
>  	list_add(&mdev_state->next, &mdev_devices_list);
>  	mutex_unlock(&mdev_list_lock);
> 
> +	mdev_set_class_id(mdev, MDEV_ID_VFIO);
>  	return 0;
>  }
> 
> --
> 2.19.1

