Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE77163CBC
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 06:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgBSFgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 00:36:01 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725842AbgBSFgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 00:36:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582090559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FnMyrS2ffrGzjTv2kAsMGrfcVGfLXQvqbV7CHWKXWPg=;
        b=fxY2EoGMrH8FuWEyKwW35X7caTPa93kMMNvgTinZ+7VYVUcxCUR1OlGo8Ig+dpip/LjqdU
        TevjBksX2gj3PVLC/KpKAoZeQwKSeIwL2ecep927+Ntm6tSk1FXWeKbCOw3zXWTWULT4Uh
        4a4KyduwXkA+s750anNYFNNs/L3sBCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-wJx9yaKzM8O55fVO3NXE4Q-1; Wed, 19 Feb 2020 00:35:52 -0500
X-MC-Unique: wJx9yaKzM8O55fVO3NXE4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E95B1085925;
        Wed, 19 Feb 2020 05:35:49 +0000 (UTC)
Received: from [10.72.13.212] (ovpn-13-212.pek2.redhat.com [10.72.13.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44D3D87B1A;
        Wed, 19 Feb 2020 05:35:27 +0000 (UTC)
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
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
References: <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <8b3e6a9c-8bfd-fb3c-12a8-2d6a3879f1ae@redhat.com>
 <20200214135232.GB4271@mellanox.com>
 <01c86ebb-cf4b-691f-e682-2d6f93ddbcf7@redhat.com>
 <20200218135608.GS4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bbfc608b-2bfa-e4c7-c2b9-dbcfe63518cb@redhat.com>
Date:   Wed, 19 Feb 2020 13:35:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200218135608.GS4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/18 =E4=B8=8B=E5=8D=889:56, Jason Gunthorpe wrote:
> On Mon, Feb 17, 2020 at 02:08:03PM +0800, Jason Wang wrote:
>
>> I thought you were copied in the patch [1], maybe we can move vhost re=
lated
>> discussion there to avoid confusion.
>>
>> [1] https://lwn.net/Articles/811210/
> Wow, that is .. confusing.
>
> So this is supposed to duplicate the uAPI of vhost-user?


It tries to reuse the uAPI of vhost with some extension.


> But it is
> open coded and duplicated because .. vdpa?


I'm not sure I get here, vhost module is reused for vhost-vdpa and all=20
current vhost device (e.g net) uses their own char device.


>
>> So it's cheaper and simpler to introduce a new bus instead of refactor=
ing a
>> well known bus and API where brunches of drivers and devices had been
>> implemented for years.
> If you reason for this approach is to ease the implementation then you
> should talk about it in the cover letters/etc


I will add more rationale in both cover letter and this patch.

Thanks


>
> Maybe it is reasonable to do this because the rework is too great, I
> don't know, but to me this whole thing looks rather messy.
>
> Remember this stuff is all uAPI as it shows up in sysfs, so you can
> easilly get stuck with it forever.
>
> Jason
>

