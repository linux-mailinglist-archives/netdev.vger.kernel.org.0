Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1711435ED
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 04:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgAUDdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 22:33:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21808 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726935AbgAUDdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 22:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579577587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZ9hoh4EXoAUSSoaNodF/53MT2MqP0i4YheKRaQPqJ0=;
        b=jDGbw4I2SK2BgOroGeQINVP4J8nlLqhr6RrJ8fpAMNp3CnjESfEsO5vby4g3jQAcZlNrT2
        1Ue4uusDG3T6njGq920JYpXTshYHahpgTXl+ORcMC+etJsp3wQq+QVyPjtqXSHQEo+YS6d
        D/k8J4PhP+K6ZV3ZUnmM/g+qHLYo/H4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-IXrE8Sy2N--LpvrBi-r7Rg-1; Mon, 20 Jan 2020 22:33:05 -0500
X-MC-Unique: IXrE8Sy2N--LpvrBi-r7Rg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F6FD107ACC4;
        Tue, 21 Jan 2020 03:33:02 +0000 (UTC)
Received: from [10.72.12.208] (ovpn-12-208.pek2.redhat.com [10.72.12.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3646D5C290;
        Tue, 21 Jan 2020 03:32:44 +0000 (UTC)
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
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
 <20200119045849-mutt-send-email-mst@kernel.org>
 <d4e7fc56-c9d8-f01f-1504-dd49d5658037@redhat.com>
 <20200120070710-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f5860f7e-f6c1-5bc7-53f5-c4badddfdfe4@redhat.com>
Date:   Tue, 21 Jan 2020 11:32:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200120070710-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/20 =E4=B8=8B=E5=8D=888:09, Michael S. Tsirkin wrote:
> On Mon, Jan 20, 2020 at 04:44:34PM +0800, Jason Wang wrote:
>> On 2020/1/19 =E4=B8=8B=E5=8D=885:59, Michael S. Tsirkin wrote:
>>> On Sun, Jan 19, 2020 at 09:07:09AM +0000, Shahaf Shuler wrote:
>>>>> Technically, we can keep the incremental API
>>>>> here and let the vendor vDPA drivers to record the full mapping
>>>>> internally which may slightly increase the complexity of vendor dri=
ver.
>>>> What will be the trigger for the driver to know it received the last=
 mapping on this series and it can now push it to the on-chip IOMMU?
>>> Some kind of invalidate API?
>>>
>> The problem is how to deal with the case of vIOMMU. When vIOMMU is ena=
bling
>> there's no concept of last mapping.
>>
>> Thanks
> Most IOMMUs have a translation cache so have an invalidate API too.


Ok, then I get you.

But in this case, when vIOMMU is enabled, each new map became a "last=20
mapping".

Thanks

>

