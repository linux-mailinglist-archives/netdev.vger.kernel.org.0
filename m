Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB03236640D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 05:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhDUD1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 23:27:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234062AbhDUD1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 23:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618975590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+rTFD/AcsiNi1fg4RyPaqu9yvjl1cmnkSOqYmjolBh8=;
        b=aDD6ksNJHbwiuc4jrP26mLG/KVzzO7R6ptsC3whjnCoSOGzxndhCR/mZ2uqZsbInNsNvHY
        uCSIyuTip0Oz0wm2d2IhYFWXMm7zEf7ntM0bYdbTyGReBL29wopYs2KV1hLL2v35OYBIBn
        Mm157cQdz2F3QDGJAB7XH/hsJMkO4gw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-D-BMsYZpNSyF4ya5VuwDzg-1; Tue, 20 Apr 2021 23:26:26 -0400
X-MC-Unique: D-BMsYZpNSyF4ya5VuwDzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0BBC801814;
        Wed, 21 Apr 2021 03:26:24 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D665E5D747;
        Wed, 21 Apr 2021 03:26:18 +0000 (UTC)
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <1618922142.0493622-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8e8e8f5c-16aa-668c-9567-b5c1f91e19dc@redhat.com>
Date:   Wed, 21 Apr 2021 11:26:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <1618922142.0493622-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/20 ÏÂÎç8:35, Xuan Zhuo Ð´µÀ:
>> I realize this has been merged to net-next already, but I'm getting a
>> use-after-free with KASAN in page_to_skb() with this patch. Reverting this
>> change fixes the UAF. I've included the KASAN dump below, and a couple of
>> comments inline.
> I think something went wrong, this was merged before it was acked. Based on the
> Jason Wang's comments, there are still some tests that have not been done?
>
> If it has been merged, what should I do now, can I make up the test?


I think so, please test net-next which should contains the fixes from Eric.

Thanks


>
>
> Thanks.
>

