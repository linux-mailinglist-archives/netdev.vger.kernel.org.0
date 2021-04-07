Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E54356813
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 11:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350129AbhDGJbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 05:31:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231981AbhDGJbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 05:31:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617787865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bLU8dIeLbeTGtWFozDr6nuNlzZcXd8594Ubbl7h9kSE=;
        b=QpXbOohsb06R9kftZB9UiyJq4zOfGxhWGshefsXi6nLJFJ3umSIsMJO3UvZT8qSuuF4AfU
        WILrMDFws2Ur+lRrFuFmuooGbcmi+kmNm38x4tNaxWBYvI4R59Oy3FRX9UXXhLSGOaM73G
        /3EjZgsBdby2VdKC3MGyWxvvXKIWEUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-1eobrNgrNz2QBUqAWKPJ9Q-1; Wed, 07 Apr 2021 05:30:58 -0400
X-MC-Unique: 1eobrNgrNz2QBUqAWKPJ9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5422887A826;
        Wed,  7 Apr 2021 09:30:56 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-236.pek2.redhat.com [10.72.13.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACA6F5C1A1;
        Wed,  7 Apr 2021 09:30:46 +0000 (UTC)
Subject: Re: [PATCH net-next v3 8/8] virtio-net: free old xmit handle xsk
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>, netdev@vger.kernel.org
References: <1617787566.555242-6-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8417076f-e838-fd75-0f8f-56624c12e0a7@redhat.com>
Date:   Wed, 7 Apr 2021 17:30:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1617787566.555242-6-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/7 下午5:26, Xuan Zhuo 写道:
>>> +	__free_old_xmit(sq, false, &stats);
>> Let's use a separate patch for this kind of factoring.
>>
> It is also possible to encounter xsk here, so it should not be a separate patch.
>
> Thanks.


You can do the factoring first and add xsk stuffs on top.

Thanks


>

