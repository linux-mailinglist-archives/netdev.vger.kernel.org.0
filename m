Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20F714060E
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 10:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgAQJdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 04:33:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45173 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726925AbgAQJdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 04:33:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579253584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHvGcF9xzuVRZeTw2ecPotSnBNnYfAGaG6neQxJf86E=;
        b=dN35GK7zGCUpG0LFQSUBSG1CgLt1FSOGs6m7zva8+yffm/jwGGI3wr/AylucgVT3ycN/T7
        GMFGws07c4tYx5RRAdQD8nvBMxjGGaPcti+njxy9BsSHDqnE9JPifItR2VVyvNYZoeNEHW
        uY4H0fJmi0jE+XgOYZIxVs6kn5qp6UA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-IavVhmtuNH2UPO5_fDnW7w-1; Fri, 17 Jan 2020 04:33:03 -0500
X-MC-Unique: IavVhmtuNH2UPO5_fDnW7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46405107ACC7;
        Fri, 17 Jan 2020 09:33:00 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 291178121F;
        Fri, 17 Jan 2020 09:32:40 +0000 (UTC)
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
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
        "mhabets@solarflare.com" <mhabets@solarflare.com>, kuba@kernel.org
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-6-jasowang@redhat.com>
 <20200116154658.GJ20978@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <aea2bff8-82c8-2c0f-19ee-e86db73e199f@redhat.com>
Date:   Fri, 17 Jan 2020 17:32:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200116154658.GJ20978@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/16 =E4=B8=8B=E5=8D=8811:47, Jason Gunthorpe wrote:
> On Thu, Jan 16, 2020 at 08:42:31PM +0800, Jason Wang wrote:
>> This patch implements a software vDPA networking device. The datapath
>> is implemented through vringh and workqueue. The device has an on-chip
>> IOMMU which translates IOVA to PA. For kernel virtio drivers, vDPA
>> simulator driver provides dma_ops. For vhost driers, set_map() methods
>> of vdpa_config_ops is implemented to accept mappings from vhost.
>>
>> A sysfs based management interface is implemented, devices are
>> created and removed through:
>>
>> /sys/devices/virtual/vdpa_simulator/netdev/{create|remove}
> This is very gross, creating a class just to get a create/remove and
> then not using the class for anything else? Yuk.


It includes more information, e.g the devices and the link from vdpa_sim=20
device and vdpa device.


>
>> Netlink based lifecycle management could be implemented for vDPA
>> simulator as well.
> This is just begging for a netlink based approach.
>
> Certainly netlink driven removal should be an agreeable standard for
> all devices, I think.


Well, I think Parav had some proposals during the discussion of mdev=20
approach. But I'm not sure if he had any RFC codes for me to integrate=20
it into vdpasim.

Or do you want me to propose the netlink API? If yes, would you prefer=20
to a new virtio dedicated one or be a subset of devlink?

But it might be better to reach an agreement for all the vendors here.

Rob, Steve, Tiwei, Lingshan, Harpreet, Martin, Jakub, please share your=20
thoughts about the management API here.


>
>> +struct vdpasim_virtqueue {
>> +	struct vringh vring;
>> +	struct vringh_kiov iov;
>> +	unsigned short head;
>> +	bool ready;
>> +	u64 desc_addr;
>> +	u64 device_addr;
>> +	u64 driver_addr;
>> +	u32 num;
>> +	void *private;
>> +	irqreturn_t (*cb)(void *data);
>> +};
>> +
>> +#define VDPASIM_QUEUE_ALIGN PAGE_SIZE
>> +#define VDPASIM_QUEUE_MAX 256
>> +#define VDPASIM_DEVICE_ID 0x1
>> +#define VDPASIM_VENDOR_ID 0
>> +#define VDPASIM_VQ_NUM 0x2
>> +#define VDPASIM_CLASS_NAME "vdpa_simulator"
>> +#define VDPASIM_NAME "netdev"
>> +
>> +u64 vdpasim_features =3D (1ULL << VIRTIO_F_ANY_LAYOUT) |
>> +		       (1ULL << VIRTIO_F_VERSION_1)  |
>> +		       (1ULL << VIRTIO_F_IOMMU_PLATFORM);
> Is not using static here intentional?


No, let me fix.


>
>> +static void vdpasim_release_dev(struct device *_d)
>> +{
>> +	struct vdpa_device *vdpa =3D dev_to_vdpa(_d);
>> +	struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
>> +
>> +	sysfs_remove_link(vdpasim_dev->devices_kobj, vdpasim->name);
>> +
>> +	mutex_lock(&vsim_list_lock);
>> +	list_del(&vdpasim->next);
>> +	mutex_unlock(&vsim_list_lock);
>> +
>> +	kfree(vdpasim->buffer);
>> +	kfree(vdpasim);
>> +}
> It is again a bit weird to see a realease function in a driver. This
> stuff is usually in the remove remove function.


Will fix.


>
>> +static int vdpasim_create(const guid_t *uuid)
>> +{
>> +	struct vdpasim *vdpasim, *tmp;
>> +	struct virtio_net_config *config;
>> +	struct vdpa_device *vdpa;
>> +	struct device *dev;
>> +	int ret =3D -ENOMEM;
>> +
>> +	mutex_lock(&vsim_list_lock);
>> +	list_for_each_entry(tmp, &vsim_devices_list, next) {
>> +		if (guid_equal(&tmp->uuid, uuid)) {
>> +			mutex_unlock(&vsim_list_lock);
>> +			return -EEXIST;
>> +		}
>> +	}
>> +
>> +	vdpasim =3D kzalloc(sizeof(*vdpasim), GFP_KERNEL);
>> +	if (!vdpasim)
>> +		goto err_vdpa_alloc;
>> +
>> +	vdpasim->buffer =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>> +	if (!vdpasim->buffer)
>> +		goto err_buffer_alloc;
>> +
>> +	vdpasim->iommu =3D vhost_iotlb_alloc(2048, 0);
>> +	if (!vdpasim->iommu)
>> +		goto err_iotlb;
>> +
>> +	config =3D &vdpasim->config;
>> +	config->mtu =3D 1500;
>> +	config->status =3D VIRTIO_NET_S_LINK_UP;
>> +	eth_random_addr(config->mac);
>> +
>> +	INIT_WORK(&vdpasim->work, vdpasim_work);
>> +	spin_lock_init(&vdpasim->lock);
>> +
>> +	guid_copy(&vdpasim->uuid, uuid);
>> +
>> +	list_add(&vdpasim->next, &vsim_devices_list);
>> +	vdpa =3D &vdpasim->vdpa;
>> +
>> +	mutex_unlock(&vsim_list_lock);
>> +
>> +	vdpa =3D &vdpasim->vdpa;
>> +	vdpa->config =3D &vdpasim_net_config_ops;
>> +	vdpa_set_parent(vdpa, &vdpasim_dev->dev);
>> +	vdpa->dev.release =3D vdpasim_release_dev;
>> +
>> +	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
>> +	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
>> +
>> +	dev =3D &vdpa->dev;
>> +	dev->coherent_dma_mask =3D DMA_BIT_MASK(64);
>> +	set_dma_ops(dev, &vdpasim_dma_ops);
>> +
>> +	ret =3D register_vdpa_device(vdpa);
>> +	if (ret)
>> +		goto err_register;
>> +
>> +	sprintf(vdpasim->name, "%pU", uuid);
>> +
>> +	ret =3D sysfs_create_link(vdpasim_dev->devices_kobj, &vdpa->dev.kobj=
,
>> +				vdpasim->name);
>> +	if (ret)
>> +		goto err_link;
> The goto err_link does the wrong unwind, once register is completed
> the error unwind is unregister & put_device, not kfree. This is why I
> recommend to always initalize the device early, and always using
> put_device during error unwinds.


Will fix.


>
> This whole guid thing seems unncessary when the device is immediately
> assigned a vdpa index from the ida.


The problem here is that user need to know which vdpa_sim is the one=20
that is just created.


> If you were not using syfs you'd
> just return that index from the creation netlink.


Yes it is.

Thanks


>
> Jason
>

