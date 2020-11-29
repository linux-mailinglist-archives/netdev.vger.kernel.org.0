Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027DD2C7A69
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 18:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgK2Ryz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 12:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbgK2Ryz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 12:54:55 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA8FC0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 09:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=xMAq2su5hFJTjz60h6IOlYmUxvcMp056ry/21etI4+I=; b=0H5N/TM6vNiDhPoJcpTiPGCPNd
        1APApkj4yQBYp4Sm3UWdXsG+h7JElaH70GlUf+Jb6VNoTyL2luD++oRIO43oVVUYwOiGjkISebR86
        UgE4PKjINGRiRFAva4bpX0xlml+TpjRM5Dmdv1RzCEERulU+A9JvMkn+gq/llmto1cm1QI83sRP2a
        GqSX3qakKo7uvTaJ1xJ0tgMPuIx4Kk2QO1HayGUYoXAs81vd6Lop4HwLQpMFoF90pTJlyZOSyGt9o
        biCt5ZX4OOjBVnoRFYu+uLRTATSrUEzGHk2kKvtXU69r/vLOgeqK+fzFgun+/T2swCxqvqEqhnY5f
        8gt2PFcA==;
Received: from [2601:1c0:6280:3f0::cc1f]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjQth-0005Gf-NJ; Sun, 29 Nov 2020 17:54:06 +0000
Subject: Re: [PATCH 00/10 net-next] net/tipc: fix all kernel-doc and add TIPC
 networking chapter
To:     Ying Xue <ying.xue@windriver.com>
Cc:     Jon Maloy <jmaloy@redhat.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
 <bde23bb7-9c96-b107-cb06-64695726b21b@windriver.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0d94930d-45c2-f5ef-202e-f3dc2f94c11d@infradead.org>
Date:   Sun, 29 Nov 2020 09:54:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <bde23bb7-9c96-b107-cb06-64695726b21b@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/20 11:37 PM, Ying Xue wrote:
> On 11/25/20 12:20 PM, Randy Dunlap wrote:
>>
>> Question: is net/tipc/discover.c, in tipc_disc_delete() kernel-doc,
>> what is the word "duest"?  Should it be changed?
> 
> The "duest" is a typo, and it should be "dest" defined as below:
> struct tipc_discoverer {
>         u32 bearer_id;
>         struct tipc_media_addr dest; ===> "dest"
>         struct net *net;
>         u32 domain;
>         int num_nodes;
>         spinlock_t lock;
>         struct sk_buff *skb;
>         struct timer_list timer;
>         unsigned long timer_intv;
> };
> 

Thanks. I'll take care of this one and your comments
on patch #1.

-- 
~Randy

