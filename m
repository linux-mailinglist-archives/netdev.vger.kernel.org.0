Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C67101188
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfKSDFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:05:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49788 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727237AbfKSDF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574132729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGZRPhYF1Y/dzL7KaRw06TGUBnCFB2IvLddTdnFImp8=;
        b=P2mHl9QueDhK4WsLIXtyBGju7tbXTlYuEJ2vJM28TH0Dav+oOgR5Mqqy1BwZG+eHNI9IX6
        B51Jl5kgMZh355vgbLC35TDTuMWN2y1RX9SrZKbzUe0EWkSB2U0QmPoE2PrnrHJF8RmdCY
        lXHZHwqT3U+qF77hKoJ2Ne3MxfpWQxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-rUB0BZtSNwuf6b0UF2q_tQ-1; Mon, 18 Nov 2019 22:05:28 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9829A802680;
        Tue, 19 Nov 2019 03:05:22 +0000 (UTC)
Received: from [10.72.12.132] (ovpn-12-132.pek2.redhat.com [10.72.12.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F095828D3A;
        Tue, 19 Nov 2019 03:04:52 +0000 (UTC)
Subject: Re: [PATCH V13 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        gregkh@linuxfoundation.org, jgg@mellanox.com,
        netdev@vger.kernel.org, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jakub.kicinski@netronome.com, jiri@mellanox.com,
        jeffrey.t.kirsher@intel.com
References: <20191118105923.7991-1-jasowang@redhat.com>
 <20191118105923.7991-7-jasowang@redhat.com>
 <20191118164510.549c097b.cohuck@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8a4e504d-abb9-44f1-73ea-e337f596bf75@redhat.com>
Date:   Tue, 19 Nov 2019 11:04:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191118164510.549c097b.cohuck@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: rUB0BZtSNwuf6b0UF2q_tQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/18 =E4=B8=8B=E5=8D=8811:45, Cornelia Huck wrote:
> On Mon, 18 Nov 2019 18:59:23 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
> [Note: I have not looked into the reworked architecture of this *at all*
> so far; just something that I noted...]
>
>> This sample driver creates mdev device that simulate virtio net device
>> over virtio mdev transport. The device is implemented through vringh
>> and workqueue. A device specific dma ops is to make sure HVA is used
>> directly as the IOVA. This should be sufficient for kernel virtio
>> driver to work.
>>
>> Only 'virtio' type is supported right now. I plan to add 'vhost' type
>> on top which requires some virtual IOMMU implemented in this sample
>> driver.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   MAINTAINERS                        |   1 +
>>   samples/Kconfig                    |  10 +
>>   samples/vfio-mdev/Makefile         |   1 +
>>   samples/vfio-mdev/mvnet_loopback.c | 690 +++++++++++++++++++++++++++++
>>   4 files changed, 702 insertions(+)
>>   create mode 100644 samples/vfio-mdev/mvnet_loopback.c
>>
>> +static struct mvnet_dev {
>> +=09struct class=09*vd_class;
>> +=09struct idr=09vd_idr;
>> +=09struct device=09dev;
>> +} mvnet_dev;
> This structure embeds a struct device (a reference-counted structure),
> yet it is a static variable. This is giving a bad example to potential
> implementers; just allocate it dynamically.


Yes, as spotted by Greg.


>
>> +static void mvnet_device_release(struct device *dev)
>> +{
>> +=09dev_dbg(dev, "mvnet: released\n");
> And that also means you need a proper release function here, of
> course.


Right.

Thanks


>
>> +}

