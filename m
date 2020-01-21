Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402E5143862
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgAUIfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:35:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44655 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727312AbgAUIfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 03:35:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579595751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7dpAEkIwYs7qlTREqwW6WdsBkWtgFDA0vfOaVMiY7c=;
        b=J90SFnPaoC+Z+0CeBym/O2aFOCBXsUpeCj1zzkIyd7cWux3LPvCrr0ELxh0YCXvD/Q8cnM
        y823NBaHy0e/4Cn611n/Lm95m2CxKztLoYFaWwS8myKK1EFU9+1J8oGAyoRKdxNCVgfEBL
        Hj/z6GdsN2gyUlvxoBfNGXTxA57cvsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-bBs492L5PM6Oe7SbmYwpXw-1; Tue, 21 Jan 2020 03:35:50 -0500
X-MC-Unique: bBs492L5PM6Oe7SbmYwpXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80F95107ACC4;
        Tue, 21 Jan 2020 08:35:47 +0000 (UTC)
Received: from [10.72.12.103] (ovpn-12-103.pek2.redhat.com [10.72.12.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0429F63148;
        Tue, 21 Jan 2020 08:35:28 +0000 (UTC)
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
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
        Ariel Adam <aadam@redhat.com>, Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <2a324cec-2863-58f4-c58a-2414ee32c930@redhat.com>
 <20200121004047-mutt-send-email-mst@kernel.org>
 <b9ad744e-c4cd-82f9-f56a-1ecc185e9cd7@redhat.com>
 <20200121031506-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <028ed448-a948-79d9-f224-c325029b17ab@redhat.com>
Date:   Tue, 21 Jan 2020 16:35:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200121031506-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/21 =E4=B8=8B=E5=8D=884:15, Michael S. Tsirkin wrote:
> On Tue, Jan 21, 2020 at 04:00:38PM +0800, Jason Wang wrote:
>> On 2020/1/21 =E4=B8=8B=E5=8D=881:47, Michael S. Tsirkin wrote:
>>> On Tue, Jan 21, 2020 at 12:00:57PM +0800, Jason Wang wrote:
>>>> On 2020/1/21 =E4=B8=8A=E5=8D=881:49, Jason Gunthorpe wrote:
>>>>> On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
>>>>>> This is similar to the design of platform IOMMU part of vhost-vdpa=
. We
>>>>>> decide to send diffs to platform IOMMU there. If it's ok to do tha=
t in
>>>>>> driver, we can replace set_map with incremental API like map()/unm=
ap().
>>>>>>
>>>>>> Then driver need to maintain rbtree itself.
>>>>> I think we really need to see two modes, one where there is a fixed
>>>>> translation without dynamic vIOMMU driven changes and one that
>>>>> supports vIOMMU.
>>>> I think in this case, you meant the method proposed by Shahaf that s=
ends
>>>> diffs of "fixed translation" to device?
>>>>
>>>> It would be kind of tricky to deal with the following case for examp=
le:
>>>>
>>>> old map [4G, 16G) new map [4G, 8G)
>>>>
>>>> If we do
>>>>
>>>> 1) flush [4G, 16G)
>>>> 2) add [4G, 8G)
>>>>
>>>> There could be a window between 1) and 2).
>>>>
>>>> It requires the IOMMU that can do
>>>>
>>>> 1) remove [8G, 16G)
>>>> 2) flush [8G, 16G)
>>>> 3) change [4G, 8G)
>>>>
>>>> ....
>>> Basically what I had in mind is something like qemu memory api
>>>
>>> 0. begin
>>> 1. remove [8G, 16G)
>>> 2. add [4G, 8G)
>>> 3. commit
>>
>> This sounds more flexible e.g driver may choose to implement static ma=
pping
>> one through commit. But a question here, it looks to me this still req=
uires
>> the DMA to be synced with at least commit here. Otherwise device may g=
et DMA
>> fault? Or device is expected to be paused DMA during begin?
>>
>> Thanks
> For example, commit might switch one set of tables for another,
> without need to pause DMA.


Yes, I think that works but need confirmation from Shahaf or Jason.

Thanks



>
>>> Anyway, I'm fine with a one-shot API for now, we can
>>> improve it later.
>>>
>>>>> There are different optimization goals in the drivers for these two
>>>>> configurations.
>>>>>
>>>>>>> If the first one, then I think memory hotplug is a heavy flow
>>>>>>> regardless. Do you think the extra cycles for the tree traverse
>>>>>>> will be visible in any way?
>>>>>> I think if the driver can pause the DMA during the time for settin=
g up new
>>>>>> mapping, it should be fine.
>>>>> This is very tricky for any driver if the mapping change hits the
>>>>> virtio rings. :(
>>>>>
>>>>> Even a IOMMU using driver is going to have problems with that..
>>>>>
>>>>> Jason
>>>> Or I wonder whether ATS/PRI can help here. E.g during I/O page fault=
,
>>>> driver/device can wait for the new mapping to be set and then replay=
 the
>>>> DMA.
>>>>
>>>> Thanks
>>>>

