Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD3A1514EC
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 05:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBDETw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 23:19:52 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45263 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727170AbgBDETw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 23:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580789990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qnJ7pfLwugdYhxtD4QkD0UVYEM/OAM1UnVZIU6mM8I8=;
        b=TMmBB64q+kN6FVe7DjZ2lgdnEr53dwQ96sHocmIr5exVXm+7+MA0WpZfJ/Y68ss2du8jf8
        ivD88Y1nktNC951cWLnlSLa8P2oA9bO01iSy8bcl0OwiqFH+ZWgBCnYc9/YarK1aiuVwAN
        25ztiPKhoRAr6CcCxxboEarBWWJvIMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-0vUHyZWFNFOwOQXfk-hPwA-1; Mon, 03 Feb 2020 23:19:49 -0500
X-MC-Unique: 0vUHyZWFNFOwOQXfk-hPwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 658278017DF;
        Tue,  4 Feb 2020 04:19:46 +0000 (UTC)
Received: from [10.72.12.170] (ovpn-12-170.pek2.redhat.com [10.72.12.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3602B5C1D4;
        Tue,  4 Feb 2020 04:19:29 +0000 (UTC)
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
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
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-6-jasowang@redhat.com>
 <20200116154658.GJ20978@mellanox.com>
 <aea2bff8-82c8-2c0f-19ee-e86db73e199f@redhat.com>
 <20200117141021.GW20978@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d53a864c-d96f-ccac-78ad-0c596bda2718@redhat.com>
Date:   Tue, 4 Feb 2020 12:19:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200117141021.GW20978@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/17 =E4=B8=8B=E5=8D=8810:10, Jason Gunthorpe wrote:
>>>> Netlink based lifecycle management could be implemented for vDPA
>>>> simulator as well.
>>> This is just begging for a netlink based approach.
>>>
>>> Certainly netlink driven removal should be an agreeable standard for
>>> all devices, I think.
>> Well, I think Parav had some proposals during the discussion of mdev
>> approach. But I'm not sure if he had any RFC codes for me to integrate=
 it
>> into vdpasim.
>>
>> Or do you want me to propose the netlink API? If yes, would you prefer=
 to a
>> new virtio dedicated one or be a subset of devlink?
> Well, lets see what feed back Parav has
>
> Jason


Hi Parav:

Do you have any update on this? If it still require sometime, I will=20
post V2 that sticks to sysfs based API.

Thanks

