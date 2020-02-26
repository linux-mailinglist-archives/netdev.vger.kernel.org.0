Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E901716F7E2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 07:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgBZGNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 01:13:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48291 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726473AbgBZGNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 01:13:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582697588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qomx+ZbKWIrzZtErXMfwcPJrjlc3eZgjsPhGLKwY99k=;
        b=ikzo3AStrM2846tHd/S5/F/ytuVHn8z+qpwTGY8EK53fqgxvWuN3kXXuzl95M4KZIf28JZ
        hWefZKC+SCzVFyZhCds5+TrngI2OjrPDKPTF4RtqzyhDDrSoMhyldTdm+kyaCgdUEGRFRV
        aDiz701cRWmQwUVYQ0ZpTFfAyIUupO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-mlezykjlOrKrQv0WTr5MZQ-1; Wed, 26 Feb 2020 01:13:07 -0500
X-MC-Unique: mlezykjlOrKrQv0WTr5MZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4343A800053;
        Wed, 26 Feb 2020 06:13:04 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09EC0396;
        Wed, 26 Feb 2020 06:12:30 +0000 (UTC)
Subject: Re: [PATCH V4 5/5] vdpasim: vDPA device simulator
From:   Jason Wang <jasowang@redhat.com>
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
 <6c341a77-a297-b7c7-dea5-b3f7b920b1f3@redhat.com>
Message-ID: <793a1b81-4f78-c405-4aae-f32a2bf67d87@redhat.com>
Date:   Wed, 26 Feb 2020 14:12:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6c341a77-a297-b7c7-dea5-b3f7b920b1f3@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/21 =E4=B8=8B=E5=8D=883:57, Jason Wang wrote:
>
> On 2020/2/20 =E4=B8=8B=E5=8D=8811:12, Jason Gunthorpe wrote:
>> On Thu, Feb 20, 2020 at 02:11:41PM +0800, Jason Wang wrote:
>>> +static void vdpasim_device_release(struct device *dev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct vdpasim *vdpasim =3D dev_to_sim(dev);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 cancel_work_sync(&vdpasim->work);
>>> +=C2=A0=C2=A0=C2=A0 kfree(vdpasim->buffer);
>>> +=C2=A0=C2=A0=C2=A0 vhost_iotlb_free(vdpasim->iommu);
>>> +=C2=A0=C2=A0=C2=A0 kfree(vdpasim);
>>> +}
>>> +
>>> +static struct vdpasim *vdpasim_create(void)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct virtio_net_config *config;
>>> +=C2=A0=C2=A0=C2=A0 struct vhost_iotlb *iommu;
>>> +=C2=A0=C2=A0=C2=A0 struct vdpasim *vdpasim;
>>> +=C2=A0=C2=A0=C2=A0 struct device *dev;
>>> +=C2=A0=C2=A0=C2=A0 void *buffer;
>>> +=C2=A0=C2=A0=C2=A0 int ret =3D -ENOMEM;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 iommu =3D vhost_iotlb_alloc(2048, 0);
>>> +=C2=A0=C2=A0=C2=A0 if (!iommu)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 buffer =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 if (!buffer)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_buffer;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vdpasim =3D kzalloc(sizeof(*vdpasim), GFP_KERNEL)=
;
>>> +=C2=A0=C2=A0=C2=A0 if (!vdpasim)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_alloc;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vdpasim->buffer =3D buffer;
>>> +=C2=A0=C2=A0=C2=A0 vdpasim->iommu =3D iommu;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 config =3D &vdpasim->config;
>>> +=C2=A0=C2=A0=C2=A0 config->mtu =3D 1500;
>>> +=C2=A0=C2=A0=C2=A0 config->status =3D VIRTIO_NET_S_LINK_UP;
>>> +=C2=A0=C2=A0=C2=A0 eth_random_addr(config->mac);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 INIT_WORK(&vdpasim->work, vdpasim_work);
>>> +=C2=A0=C2=A0=C2=A0 spin_lock_init(&vdpasim->lock);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim-=
>iommu);
>>> +=C2=A0=C2=A0=C2=A0 vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim-=
>iommu);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 dev =3D &vdpasim->dev;
>>> +=C2=A0=C2=A0=C2=A0 dev->release =3D vdpasim_device_release;
>>> +=C2=A0=C2=A0=C2=A0 dev->coherent_dma_mask =3D DMA_BIT_MASK(64);
>>> +=C2=A0=C2=A0=C2=A0 set_dma_ops(dev, &vdpasim_dma_ops);
>>> +=C2=A0=C2=A0=C2=A0 dev_set_name(dev, "%s", VDPASIM_NAME);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D device_register(&vdpasim->dev);
>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_init;
>> It is a bit weird to be creating this dummy parent, couldn't this be
>> done by just passing a NULL parent to vdpa_alloc_device, doing
>> set_dma_ops() on the vdpasim->vdpa->dev and setting dma_device to
>> vdpasim->vdpa->dev ?
>
>
> I think it works.


Rethink about this, since most hardware vDPA driver will have a parent=20
and will use it to find the parent structure e.g

dev_get_drvdata(vdpa->dev->parent)

So I keep this dummy parent in V5.

Thanks


