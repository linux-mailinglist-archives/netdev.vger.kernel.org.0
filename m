Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0F3144BA3
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 07:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgAVGS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 01:18:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36613 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725805AbgAVGS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 01:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579673905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=46Fyq8DajrI/VyojMmIDzfpBih5cCQHJwjUiK8iJUVM=;
        b=Wn5QGTxLd1d4T+nvQ1/tbd8pOdgc1gV7cxWM7/f5R+P8aM/ai/mzhws4hkncNceXwY8mzQ
        tyDOTyLz8wUCY6NLE13esPXRH87H6Ns8vQyrelWP0QYg5FMNTE7Wd8whb6ox5jkUyM5ert
        kZkPbLwQi36fA8FrqpOlvMGBOJzSd1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-koa7asbiOJCyfjv1xRzSyw-1; Wed, 22 Jan 2020 01:18:24 -0500
X-MC-Unique: koa7asbiOJCyfjv1xRzSyw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED1991902EA0;
        Wed, 22 Jan 2020 06:18:20 +0000 (UTC)
Received: from [10.72.12.103] (ovpn-12-103.pek2.redhat.com [10.72.12.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 957EB5D9E2;
        Wed, 22 Jan 2020 06:18:02 +0000 (UTC)
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
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
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <2a324cec-2863-58f4-c58a-2414ee32c930@redhat.com>
 <20200121004047-mutt-send-email-mst@kernel.org>
 <b9ad744e-c4cd-82f9-f56a-1ecc185e9cd7@redhat.com>
 <20200121031506-mutt-send-email-mst@kernel.org>
 <20200121140456.GA12330@mellanox.com>
 <20200121091636-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <26fa6211-6625-6dc6-f5df-7a124d8c53ae@redhat.com>
Date:   Wed, 22 Jan 2020 14:18:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200121091636-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/21 =E4=B8=8B=E5=8D=8810:17, Michael S. Tsirkin wrote:
> On Tue, Jan 21, 2020 at 02:05:04PM +0000, Jason Gunthorpe wrote:
>> On Tue, Jan 21, 2020 at 03:15:43AM -0500, Michael S. Tsirkin wrote:
>>>> This sounds more flexible e.g driver may choose to implement static =
mapping
>>>> one through commit. But a question here, it looks to me this still r=
equires
>>>> the DMA to be synced with at least commit here. Otherwise device may=
 get DMA
>>>> fault? Or device is expected to be paused DMA during begin?
>>>>
>>>> Thanks
>>> For example, commit might switch one set of tables for another,
>>> without need to pause DMA.
>> I'm not aware of any hardware that can do something like this
>> completely atomically..
> FWIW VTD can do this atomically.
>
>> Any mapping change API has to be based around add/remove regions
>> without any active DMA (ie active DMA is a guest error the guest can
>> be crashed if it does this)
>>
>> Jason
> Right, lots of cases are well served by only changing parts of
> mapping that aren't in active use. Memory hotplug is such a case.
> That's not the same as a completely static mapping.


For hotplug it should be fine with current Qemu since it belongs to=20
different memory regions. So each dimm should have its own dedicated map=20
entries in IOMMU.

But I'm not sure if the merging logic in current vhost memory listener=20
may cause any trouble, we may need to disable it.

Thanks


>

