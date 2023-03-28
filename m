Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5276CC219
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjC1Ocz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjC1Ocy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:32:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48945BDEE
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 07:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBFC8B81D68
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 14:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316A2C433D2;
        Tue, 28 Mar 2023 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680013969;
        bh=MF2OXpyb9vMZTPVdcqa+hCVYpNQZypzo5MMWr4zXOOU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MTaz3GHWLxHITvESQO8xVX4JD1edt7dYvy9EmYsCEOulZ2CpBsF1rZRJAFK3JwSaw
         xX3UEisicVE7mKe7Vl2qOOMaF/P0Vntqng+ITfOXUMt4fRr2rd9yZ/UTRAbal3BL57
         voNy5BchSITBRNbsNR6Oz2I/SJBjk/Cl1x/Q2JRyqgLfKwYnidcuLju/mwapEDj0St
         Bia4sxLak3rK34bxS9A+MwuLLWnDxpricXlK2fthL4tjzBWqHbSP2IDsef++1FSbew
         VHYDeAzrRzNKilAZuV3VM+D61LJS3rcrQ2/eMTBQ+A2XLp1ZAunRX9B9nFE+cVirck
         99D0z21LpQl6Q==
Message-ID: <309a47d4-86bb-2a06-1910-3f080719ed59@kernel.org>
Date:   Tue, 28 Mar 2023 08:32:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2 net-next 1/2] ipv6: Remove in6addr_any alternatives.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20230327235455.52990-1-kuniyu@amazon.com>
 <20230327235455.52990-2-kuniyu@amazon.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230327235455.52990-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/23 5:54 PM, Kuniyuki Iwashima wrote:
> Some code defines the IPv6 wildcard address as a local variable and
> use it with memcmp() or ipv6_addr_equal().
> 
> Let's use in6addr_any and ipv6_addr_any() instead.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |  5 ++---
>  include/net/ip6_fib.h                                 |  9 +++------
>  include/trace/events/fib.h                            |  5 ++---
>  include/trace/events/fib6.h                           |  5 +----
>  net/ethtool/ioctl.c                                   | 10 +++++-----
>  net/ipv4/inet_hashtables.c                            | 11 ++++-------
>  6 files changed, 17 insertions(+), 28 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


