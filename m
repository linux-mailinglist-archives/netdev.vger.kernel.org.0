Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9514C0197
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiBVSsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbiBVSsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:48:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0B0108BFB
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:47:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 088456158E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DB8C340E8;
        Tue, 22 Feb 2022 18:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645555659;
        bh=gJXI3KS444mr7VKV7jDxIEmChh5euuwfD4kN4mIb8Hs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Yv5MkEp4W8RtruH0ZqNqOiVJXNVGDtBHExQUwMeMXePNjsAwNQy1Y/oow6CoYapvd
         RyCD/cxIzRqdndj6gach/EBB6nX3eQqGJKzNKfLIuDKrW34o4yZN+kRKhWRU4JkDtn
         6TLBCD8WRcBpfYHnc9bNleEryc1ei6fuhyKqiw0tYclB8vfWu+KXKaeyUqrAbHmhsx
         d6dgVUyXpW/Nu3Q2tS/PWQetoMq23h+Nt/4YPvvwECRasIv2uAOCsYoWNQZLOBBXnH
         01z9BwW5UERuTgHVtYbOsXaVWjIBX3LNwM45v7gTHSmkb4FOYcCZW91tA9qHewUdq6
         toIxAjmFNWaqw==
Message-ID: <13bf5bbc-caa2-dc16-57f8-966efe1ef337@kernel.org>
Date:   Tue, 22 Feb 2022 11:47:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] ipv6: tcp: consistently use MAX_TCP_HEADER
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
References: <20220222031115.4005060-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220222031115.4005060-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/22 8:11 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> All other skbs allocated for TCP tx are using MAX_TCP_HEADER already.
> 
> MAX_HEADER can be too small for some cases (like eBPF based encapsulation),
> so this can avoid extra pskb_expand_head() in lower stacks.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/tcp_ipv6.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

