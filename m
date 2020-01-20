Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BAA142601
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 09:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgATIoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 03:44:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47746 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726590AbgATIoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 03:44:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579509855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NaXsioYjljuVY6jZb4aFMxl3jkckcuLg1JicxfVLDqk=;
        b=bY+YZNNZR7kqxotMZLFNxFshZfuQwpll3OmWdIUXznhwqCEEl5LUyl9KIb7LvjaGWsIhls
        gQ6Rqe9YXfoznJOFdMIoBP28rb45SiqPHGh2jmdg0gxSK5PphP0uoK9USa0A7GsxWz5UHE
        BnZ1DQ43AxTWJqoT0J00M7uOqr2mG/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-bGkbTfTSOqe8wSHGCrl1cw-1; Mon, 20 Jan 2020 03:44:14 -0500
X-MC-Unique: bGkbTfTSOqe8wSHGCrl1cw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3508800D50;
        Mon, 20 Jan 2020 08:44:11 +0000 (UTC)
Received: from [10.72.12.173] (ovpn-12-173.pek2.redhat.com [10.72.12.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7B53272A1;
        Mon, 20 Jan 2020 08:43:55 +0000 (UTC)
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
To:     Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
Date:   Mon, 20 Jan 2020 16:43:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/19 =E4=B8=8B=E5=8D=885:07, Shahaf Shuler wrote:
> Friday, January 17, 2020 4:13 PM, Rob Miller:
> Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
>>> On 2020/1/17 =E4=B8=8B=E5=8D=888:13, Michael S. Tsirkin wrote:
>>>> On Thu, Jan 16, 2020 at 08:42:29PM +0800, Jason Wang wrote:
> [...]
>
>>>> + * @set_map:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Set device memory mapping, optional
>>>> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 and only needed for device that using
>>>> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 device specific DMA translation
>>>> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 (on-chip IOMMU)
>>>> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 @vdev: vdpa device
>>>> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 @iotlb: vhost memory mapping to be
>>>> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 used by the vDPA
>>>> + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 Returns integer: success (0) or error (< 0)
>>> OK so any change just swaps in a completely new mapping?
>>> Wouldn't this make minor changes such as memory hotplug
>>> quite expensive?
> What is the concern? Traversing the rb tree or fully replace the on-chi=
p IOMMU translations?
> If the latest, then I think we can take such optimization on the driver=
 level (i.e. to update only the diff between the two mapping).


This is similar to the design of platform IOMMU part of vhost-vdpa. We=20
decide to send diffs to platform IOMMU there. If it's ok to do that in=20
driver, we can replace set_map with incremental API like map()/unmap().

Then driver need to maintain rbtree itself.


> If the first one, then I think memory hotplug is a heavy flow regardles=
s. Do you think the extra cycles for the tree traverse will be visible in=
 any way?


I think if the driver can pause the DMA during the time for setting up=20
new mapping, it should be fine.


>  =20
>
>> My understanding is that the incremental updating of the on chip IOMMU
>> may degrade the=C2=A0 performance. So vendor vDPA drivers may want to =
know
>> all the mappings at once.
> Yes exact. For Mellanox case for instance many optimization can be perf=
ormed on a given memory layout.
>
>> Technically, we can keep the incremental API
>> here and let the vendor vDPA drivers to record the full mapping
>> internally which may slightly increase the complexity of vendor driver=
.
> What will be the trigger for the driver to know it received the last ma=
pping on this series and it can now push it to the on-chip IOMMU?


For GPA->HVA(HPA) mapping, we can have flag for this.

But for GIOVA_>HVA(HPA) mapping which could be changed by guest, it=20
looks to me there's no concept of "last mapping" there. I guess in this=20
case, mappings needs to be set from the ground. This could be expensive=20
but consider most application uses static mappings (e.g dpdk in guest).=20
It should be ok.

Thanks


>
>> We need more inputs from vendors here.
>>
>> Thanks
>

