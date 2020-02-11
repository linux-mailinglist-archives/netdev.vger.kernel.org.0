Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA84158886
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 04:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgBKDF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 22:05:27 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727782AbgBKDFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 22:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581390321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KvcEiX4twRYkY9tlcW0KR6JhbG2eCzmXY2UKM+U0WS8=;
        b=F2BAN9kwmVjPvwhjS3lsVEYshy9X5xt2YZjdsEj34mVLH2cA3zaC79g1aY7CO+VXeZ0/92
        aEeUNY0KhIkM0cx2tODF7vlTyfKrEmVAOW9cLjHRnEGGfdRzi0LPqsk4pRBjcSnkIRIGEE
        cw91xtIPAXmnMRB9DKciLA/qW4cQ4gs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-ZeDow6a7McejZRi6GEvWJQ-1; Mon, 10 Feb 2020 22:05:20 -0500
X-MC-Unique: ZeDow6a7McejZRi6GEvWJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 848AB8017DF;
        Tue, 11 Feb 2020 03:05:17 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3672C60BF4;
        Tue, 11 Feb 2020 03:04:58 +0000 (UTC)
Subject: Re: [PATCH V2 4/5] virtio: introduce a vDPA based transport
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-5-jasowang@redhat.com>
 <20200210133442.GS23346@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <530d9dbe-39c0-db0c-d13a-0719e5ade777@redhat.com>
Date:   Tue, 11 Feb 2020 11:04:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200210133442.GS23346@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/10 =E4=B8=8B=E5=8D=889:34, Jason Gunthorpe wrote:
> On Mon, Feb 10, 2020 at 11:56:07AM +0800, Jason Wang wrote:
>> This patch introduces a vDPA transport for virtio. This is used to
>> use kernel virtio driver to drive the mediated device that is capable
>> of populating virtqueue directly.
> Is this comment still right? Is there a mediated device still?
>
> Jason


No, will fix.

Thanks


>

