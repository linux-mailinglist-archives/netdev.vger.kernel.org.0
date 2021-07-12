Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F803C62DF
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 20:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhGLSsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 14:48:24 -0400
Received: from relay.sw.ru ([185.231.240.75]:55846 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234000AbhGLSsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 14:48:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=iAEZINJDepSq91s49rJlKY2GlIRP1NxaA+57Jcf/IuU=; b=UaNeQisPHAhOQk6p0
        R/9EJQTjFYSh2IJceO9Hc061xF5a/sUDJn9crRZpai/N012INLJB0oqw8nDXnjkyzP6Ione0d+Pj1
        1IOuh5ejnGq0uiq9sSQrEN4CA2BgWiHBbfVdPXL7S+bMj52C8x5H7F9IgSyAzNLJyZY+Jm4aYZTY0
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m30vo-003k5b-Pt; Mon, 12 Jul 2021 21:45:28 +0300
Subject: Re: [PATCH NET 1/7] skbuff: introduce pskb_realloc_headroom()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
 <cover.1626093470.git.vvs@virtuozzo.com>
 <8049e16b-3d7a-64c3-c948-ec504590a136@virtuozzo.com>
 <20210712105310.46d265a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <55c9e2ae-b060-baa2-460c-90eb3e9ded5c@virtuozzo.com>
Date:   Mon, 12 Jul 2021 21:45:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712105310.46d265a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/21 8:53 PM, Jakub Kicinski wrote:
> I saw you asked about naming in a different sub-thread, what do you
> mean by "'pskb_expand_head' have different semantic"? AFAIU the 'p'
> in pskb stands for "private", meaning not shared. In fact
> skb_realloc_headroom() should really be pskb... but it predates the 
> 'pskb' naming pattern by quite a while. Long story short
> skb_expand_head() seems like a good name. With the current patch
> pskb_realloc_headroom() vs skb_realloc_headroom() would give people
> exactly the opposite intuition of what the code does.

Thank you for feedback,
I'll change helper name back to skb_expand_head() in next patch version.

	Vasily Averin
