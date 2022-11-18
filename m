Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B3D62F31B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241047AbiKRLAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbiKRLAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B928E9151E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5580D62421
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF37BC433D6;
        Fri, 18 Nov 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668769215;
        bh=ZsFUmIliHNFxib2BqYKoKGhUiPXrCqlkYaCRUm4XW+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qbP88W19hNg+NlDrSsGOPQ7pctabAaWa/NhsHoXnzCOWBhBf9tvfFugNtAn+ts/n+
         /kI1TWx6Cq9DjRgGWiUrGuz45G4NxsaEQvD0JoOCalhJ3EbUZj8ffsa6geiSt1BPqG
         uW64ryW+nySeEgoe0d3unPiu5crtvYRPLZSKcfTpMduLeAPwfjoX3cYi9hHZ/3h0Kx
         n4eOb58mhc4KHNNyeCA4pBWww07HmMOyNhBniX+Oe4fbZd7Z6AWscbU16oU/m8jVg8
         807gjn11ioHZowVUNtoFpajUXwBz5DZs9KxYH/6WKLRSEYpOnIlZxEtGsKJoeKUG7H
         1TEYV2SIAfxiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 988B0E29F43;
        Fri, 18 Nov 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: libwx: Fix dead code for duplicate check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166876921562.13163.1974857319473976129.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 11:00:15 +0000
References: <20221116015835.1187783-1-jiawenwu@trustnetic.com>
In-Reply-To: <20221116015835.1187783-1-jiawenwu@trustnetic.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 16 Nov 2022 09:58:35 +0800 you wrote:
> Fix duplicate check on polling timeout.
> 
> Fixes: 1efa9bfe58c5 ("net: libwx: Implement interaction with firmware")
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: libwx: Fix dead code for duplicate check
    https://git.kernel.org/netdev/net-next/c/0b6ffefbb018

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


