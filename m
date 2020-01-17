Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7875B140231
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 04:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbgAQDDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 22:03:38 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389001AbgAQDDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 22:03:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579230215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZHZAudpQ7YKqVHyEOwRamq1WK1H7U3kwvTz/1r/Y/lU=;
        b=gS9JXooKQ6njC2mjiEuvDFSMpDEY8KWgPGd3A9B8iufRriaQpYCxyme6ZYZ9PvzOLL9N5K
        y4e2pe8lmZq8dXjIBZOERel0Yi89Xl0+Do7K16Jo9Hq77/qRC4arTsTQ6wQG9i/KwTVppi
        sd2CQEISWNkqCu2TP6XkFf/zeffRPW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-CkGX8257OWK3y6RbnjmjLQ-1; Thu, 16 Jan 2020 22:03:33 -0500
X-MC-Unique: CkGX8257OWK3y6RbnjmjLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E08FDBA3;
        Fri, 17 Jan 2020 03:03:30 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EA4E19C5B;
        Fri, 17 Jan 2020 03:03:14 +0000 (UTC)
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200116152209.GH20978@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <03cfbcc2-fef0-c9d8-0b08-798b2a293b8c@redhat.com>
Date:   Fri, 17 Jan 2020 11:03:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200116152209.GH20978@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/16 =E4=B8=8B=E5=8D=8811:22, Jason Gunthorpe wrote:
> On Thu, Jan 16, 2020 at 08:42:29PM +0800, Jason Wang wrote:
>> vDPA device is a device that uses a datapath which complies with the
>> virtio specifications with vendor specific control path. vDPA devices
>> can be both physically located on the hardware or emulated by
>> software. vDPA hardware devices are usually implemented through PCIE
>> with the following types:
>>
>> - PF (Physical Function) - A single Physical Function
>> - VF (Virtual Function) - Device that supports single root I/O
>>    virtualization (SR-IOV). Its Virtual Function (VF) represents a
>>    virtualized instance of the device that can be assigned to differen=
t
>>    partitions
>> - VDEV (Virtual Device) - With technologies such as Intel Scalable
>>    IOV, a virtual device composed by host OS utilizing one or more
>>    ADIs.
>> - SF (Sub function) - Vendor specific interface to slice the Physical
>>    Function to multiple sub functions that can be assigned to differen=
t
>>    partitions as virtual devices.
> I really hope we don't end up with two different ways to spell this
> same thing.


I think you meant ADI vs SF. It looks to me that ADI is limited to the=20
scope of scalable IOV but SF not.


>
>> @@ -0,0 +1,2 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +obj-$(CONFIG_VDPA) +=3D vdpa.o
>> diff --git a/drivers/virtio/vdpa/vdpa.c b/drivers/virtio/vdpa/vdpa.c
>> new file mode 100644
>> index 000000000000..2b0e4a9f105d
>> +++ b/drivers/virtio/vdpa/vdpa.c
>> @@ -0,0 +1,141 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * vDPA bus.
>> + *
>> + * Copyright (c) 2019, Red Hat. All rights reserved.
>> + *     Author: Jason Wang <jasowang@redhat.com>
> 2020 tests days


Will fix.


>
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/idr.h>
>> +#include <linux/vdpa.h>
>> +
>> +#define MOD_VERSION  "0.1"
> I think module versions are discouraged these days


Will remove.


>
>> +#define MOD_DESC     "vDPA bus"
>> +#define MOD_AUTHOR   "Jason Wang <jasowang@redhat.com>"
>> +#define MOD_LICENSE  "GPL v2"
>> +
>> +static DEFINE_IDA(vdpa_index_ida);
>> +
>> +struct device *vdpa_get_parent(struct vdpa_device *vdpa)
>> +{
>> +	return vdpa->dev.parent;
>> +}
>> +EXPORT_SYMBOL(vdpa_get_parent);
>> +
>> +void vdpa_set_parent(struct vdpa_device *vdpa, struct device *parent)
>> +{
>> +	vdpa->dev.parent =3D parent;
>> +}
>> +EXPORT_SYMBOL(vdpa_set_parent);
>> +
>> +struct vdpa_device *dev_to_vdpa(struct device *_dev)
>> +{
>> +	return container_of(_dev, struct vdpa_device, dev);
>> +}
>> +EXPORT_SYMBOL_GPL(dev_to_vdpa);
>> +
>> +struct device *vdpa_to_dev(struct vdpa_device *vdpa)
>> +{
>> +	return &vdpa->dev;
>> +}
>> +EXPORT_SYMBOL_GPL(vdpa_to_dev);
> Why these trivial assessors? Seems unnecessary, or should at least be
> static inlines in a header


Will fix.


>
>> +int register_vdpa_device(struct vdpa_device *vdpa)
>> +{
> Usually we want to see symbols consistently prefixed with vdpa_*, is
> there a reason why register/unregister are swapped?


I follow the name from virtio. I will switch to vdpa_*.


>
>> +	int err;
>> +
>> +	if (!vdpa_get_parent(vdpa))
>> +		return -EINVAL;
>> +
>> +	if (!vdpa->config)
>> +		return -EINVAL;
>> +
>> +	err =3D ida_simple_get(&vdpa_index_ida, 0, 0, GFP_KERNEL);
>> +	if (err < 0)
>> +		return -EFAULT;
>> +
>> +	vdpa->dev.bus =3D &vdpa_bus;
>> +	device_initialize(&vdpa->dev);
> IMHO device_initialize should not be called inside something called
> register, toooften we find out that the caller drivers need the device
> to be initialized earlier, ie to use the kref, or something.
>
> I find the best flow is to have some init function that does the
> device_initialize and sets the device_name that the driver can call
> early.


Ok, will do.


>
> Shouldn't there be a device/driver matching process of some kind?


The question is what do we want do match here.

1) "virtio" vs "vhost", I implemented matching method for this in mdev=20
series, but it looks unnecessary for vDPA device driver to know about=20
this. Anyway we can use sysfs driver bind/unbind to switch drivers
2) virtio device id and vendor id. I'm not sure we need this consider=20
the two drivers so far (virtio/vhost) are all bus drivers.

Thanks


>
> Jason
>

