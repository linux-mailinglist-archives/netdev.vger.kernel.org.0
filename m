Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C70610935
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 06:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJ1EKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 00:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJ1EKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 00:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AD11C405;
        Thu, 27 Oct 2022 21:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F8D62622;
        Fri, 28 Oct 2022 04:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E64CEC433D7;
        Fri, 28 Oct 2022 04:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666930220;
        bh=Z5SEYz27/sD3q9cSIiG9yq/10+6LPGQJiedWTNurrFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tfENrWcRml9othhaNHb6cIj8rGQw+OJxHo7kHCuwVDc5Km0P1L7+ymd27rieRXAn3
         pNgmWpULO7Px5cnol1iD3cyI/wHl+H7px0KmSxY9qQujoI3o8FspJUBZfoqaRZj6e3
         c/XmWZ1MZmZmIDSy7G47s+qXFgJezmvogi6JlhIPi1OrO9DOLYguAm2EIt2ooEwm/d
         lOnlFJJB2FOYzEzL98Lxkg8kYZ+DOF+1LgxbMrsdTUjEpWZeyeDgPuHX64XDJGUrgS
         RHtuE+AV8ZL1d66G1VEfN/mvgqGcJhIDMiw3iud8JsZQuAUHCzKombU8kxhfZG/qiT
         3ADFX/DYkmPzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8052E270D8;
        Fri, 28 Oct 2022 04:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/10] netfilter: nft_payload: move struct
 nft_payload_set definition where it belongs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166693021981.17555.13950972523426119699.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 04:10:19 +0000
References: <20221026132227.3287-2-pablo@netfilter.org>
In-Reply-To: <20221026132227.3287-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 26 Oct 2022 15:22:18 +0200 you wrote:
> Not required to expose this header in nf_tables_core.h, move it to where
> it is used, ie. nft_payload.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables_core.h | 10 ----------
>  net/netfilter/nft_payload.c            | 10 ++++++++++
>  2 files changed, 10 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net-next,01/10] netfilter: nft_payload: move struct nft_payload_set definition where it belongs
    https://git.kernel.org/netdev/net-next/c/ac1f8c049319
  - [net-next,02/10] netfilter: nf_tables: reduce nft_pktinfo by 8 bytes
    https://git.kernel.org/netdev/net-next/c/e7a1caa67ce6
  - [net-next,03/10] netfilter: nft_objref: make it builtin
    https://git.kernel.org/netdev/net-next/c/d037abc2414b
  - [net-next,04/10] netfilter: nft_payload: access GRE payload via inner offset
    https://git.kernel.org/netdev/net-next/c/c247897d7c19
  - [net-next,05/10] netfilter: nft_payload: access ipip payload for inner offset
    https://git.kernel.org/netdev/net-next/c/3927ce8850ca
  - [net-next,06/10] netfilter: nft_inner: support for inner tunnel header matching
    https://git.kernel.org/netdev/net-next/c/3a07327d10a0
  - [net-next,07/10] netfilter: nft_inner: add percpu inner context
    https://git.kernel.org/netdev/net-next/c/0e795b37ba04
  - [net-next,08/10] netfilter: nft_meta: add inner match support
    https://git.kernel.org/netdev/net-next/c/a150d122b6bd
  - [net-next,09/10] netfilter: nft_inner: add geneve support
    https://git.kernel.org/netdev/net-next/c/0db14b95660b
  - [net-next,10/10] netfilter: nft_inner: set tunnel offset to GRE header offset
    https://git.kernel.org/netdev/net-next/c/91619eb60aec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


