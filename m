Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE7A4D2DF9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiCILbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiCILbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:31:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4ED14FBCC
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 03:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D6B6B820D8
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F315C36AE2;
        Wed,  9 Mar 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646825413;
        bh=6t18XxZzdNqDkRrZTXAN3dQkcbqd+XBeOWyiPZu4bIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DZRyvIGs4jlpsD5Jnj4sCYuhOOr0L/7BELAxhqGAdvRD1Hez0dqlYehMVoCcqVyry
         3wzdWld861iX5M0NJjnwe4zqh/iDrNVnOq7caAAMEl3j1XxJVBrqxpextXGBBBLMC1
         XM8B5iFFScEw1RcOyyeQ6Pv0NCyBjRB2MjFZW+L2x1N64u6W15gZj1Aa8pCiF/wKQq
         NVCwgf+0Vb7hq6eCS02FleTpdpkG+Jin7Qk11XLmyxilhfpdrBMIMKpleLf2h2IsH8
         1XXFBRCilNThzr+7Eopzs/qKEDqWnwXR9qfkBzu7LIgiQGSiQu24SzezX4o34wVFW7
         XNi8Nru5Qxwhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E21A9E73C2D;
        Wed,  9 Mar 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net/fungible: CONFIG_FUN_CORE needs SBITMAP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682541292.22286.7958746764621210532.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 11:30:12 +0000
References: <20220308081234.3517-1-dmichail@fungible.com>
In-Reply-To: <20220308081234.3517-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rdunlap@infradead.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Mar 2022 00:12:34 -0800 you wrote:
> fun_core.ko uses sbitmaps and needs to select SBITMAP.
> Fixes below errors:
> 
> ERROR: modpost: "__sbitmap_queue_get"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_finish_wait"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_clear"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_prepare_to_wait"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_init_node"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> ERROR: modpost: "sbitmap_queue_wake_all"
> [drivers/net/ethernet/fungible/funcore/funcore.ko] undefined!
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/fungible: CONFIG_FUN_CORE needs SBITMAP
    https://git.kernel.org/netdev/net-next/c/40bb09c87f0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


