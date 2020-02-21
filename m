Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3661671DB
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 08:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgBUH54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 02:57:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46294 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730376AbgBUH5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 02:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582271874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZ2vYX6aTEtYA+Rmtsl2PSnzUra/4wEX+6A+xs3OWnE=;
        b=ZmlW3lDLLePnSLJ1QMezwCd2fEz+nLUnc8LQUdfrOLap5rQ3Q6UwKJtWofo86RvlDEVLWy
        zzkZEqiGXJ7y4NuudqsVWaHKIyz76XoS99b5uYJd/8VRllJnhxSTS6iYXtfegirzivdDUg
        pxBml2/bMV+JuEsi5YIbKbCpqzWhfJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-s328FKtIP_GiYZgic4bVwg-1; Fri, 21 Feb 2020 02:57:50 -0500
X-MC-Unique: s328FKtIP_GiYZgic4bVwg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89523107ACC5;
        Fri, 21 Feb 2020 07:57:47 +0000 (UTC)
Received: from [10.72.13.208] (ovpn-13-208.pek2.redhat.com [10.72.13.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A094B8ECFD;
        Fri, 21 Feb 2020 07:57:31 +0000 (UTC)
Subject: Re: [PATCH V4 5/5] vdpasim: vDPA device simulator
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
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200220061141.29390-1-jasowang@redhat.com>
 <20200220061141.29390-6-jasowang@redhat.com>
 <20200220151215.GU23930@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6c341a77-a297-b7c7-dea5-b3f7b920b1f3@redhat.com>
Date:   Fri, 21 Feb 2020 15:57:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200220151215.GU23930@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/20 =E4=B8=8B=E5=8D=8811:12, Jason Gunthorpe wrote:
> On Thu, Feb 20, 2020 at 02:11:41PM +0800, Jason Wang wrote:
>> +static void vdpasim_device_release(struct device *dev)
>> +{
>> +	struct vdpasim *vdpasim =3D dev_to_sim(dev);
>> +
>> +	cancel_work_sync(&vdpasim->work);
>> +	kfree(vdpasim->buffer);
>> +	vhost_iotlb_free(vdpasim->iommu);
>> +	kfree(vdpasim);
>> +}
>> +
>> +static struct vdpasim *vdpasim_create(void)
>> +{
>> +	struct virtio_net_config *config;
>> +	struct vhost_iotlb *iommu;
>> +	struct vdpasim *vdpasim;
>> +	struct device *dev;
>> +	void *buffer;
>> +	int ret =3D -ENOMEM;
>> +
>> +	iommu =3D vhost_iotlb_alloc(2048, 0);
>> +	if (!iommu)
>> +		goto err;
>> +
>> +	buffer =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>> +	if (!buffer)
>> +		goto err_buffer;
>> +
>> +	vdpasim =3D kzalloc(sizeof(*vdpasim), GFP_KERNEL);
>> +	if (!vdpasim)
>> +		goto err_alloc;
>> +
>> +	vdpasim->buffer =3D buffer;
>> +	vdpasim->iommu =3D iommu;
>> +
>> +	config =3D &vdpasim->config;
>> +	config->mtu =3D 1500;
>> +	config->status =3D VIRTIO_NET_S_LINK_UP;
>> +	eth_random_addr(config->mac);
>> +
>> +	INIT_WORK(&vdpasim->work, vdpasim_work);
>> +	spin_lock_init(&vdpasim->lock);
>> +
>> +	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
>> +	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
>> +
>> +	dev =3D &vdpasim->dev;
>> +	dev->release =3D vdpasim_device_release;
>> +	dev->coherent_dma_mask =3D DMA_BIT_MASK(64);
>> +	set_dma_ops(dev, &vdpasim_dma_ops);
>> +	dev_set_name(dev, "%s", VDPASIM_NAME);
>> +
>> +	ret =3D device_register(&vdpasim->dev);
>> +	if (ret)
>> +		goto err_init;
> It is a bit weird to be creating this dummy parent, couldn't this be
> done by just passing a NULL parent to vdpa_alloc_device, doing
> set_dma_ops() on the vdpasim->vdpa->dev and setting dma_device to
> vdpasim->vdpa->dev ?


I think it works.


>> +	vdpasim->vdpa =3D vdpa_alloc_device(dev, dev, &vdpasim_net_config_op=
s);
>> +	if (ret)
>> +		goto err_vdpa;
>> +	ret =3D vdpa_register_device(vdpasim->vdpa);
>> +	if (ret)
>> +		goto err_register;
>> +
>> +	return vdpasim;
>> +
>> +err_register:
>> +	put_device(&vdpasim->vdpa->dev);
>> +err_vdpa:
>> +	device_del(&vdpasim->dev);
>> +	goto err;
>> +err_init:
>> +	put_device(&vdpasim->dev);
>> +	goto err;
> If you do the vdmasim alloc first, and immediately do
> device_initialize() then all the failure paths can do put_device
> instead of having this ugly goto unwind split. Just check for
> vdpasim->iommu =3D=3D NULL during release.


Yes, that looks simpler.


>
>> +static int __init vdpasim_dev_init(void)
>> +{
>> +	vdpasim_dev =3D vdpasim_create();
>> +
>> +	if (!IS_ERR(vdpasim_dev))
>> +		return 0;
>> +
>> +	return PTR_ERR(vdpasim_dev);
>> +}
>> +
>> +static int vdpasim_device_remove_cb(struct device *dev, void *data)
>> +{
>> +	struct vdpa_device *vdpa =3D dev_to_vdpa(dev);
>> +
>> +	vdpa_unregister_device(vdpa);
>> +
>> +	return 0;
>> +}
>> +
>> +static void __exit vdpasim_dev_exit(void)
>> +{
>> +	device_for_each_child(&vdpasim_dev->dev, NULL,
>> +			      vdpasim_device_remove_cb);
> Why the loop? There is only one device, and it is in the global
> varaible vdmasim_dev ?


Not necessary but doesn't harm, will remove this.

Thanks


>
> Jason
>

