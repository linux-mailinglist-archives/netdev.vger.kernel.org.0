Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB9B4D54B4
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245739AbiCJWlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbiCJWlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:41:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA4A186431
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA39361C04
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 22:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5549DC340EB;
        Thu, 10 Mar 2022 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646952011;
        bh=xiI64uPCXCCmXExH8vGGE+m13WCYe2BT07WjQcLkTTA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sxhzCghnTeX8JA6lC2FARdoFUJxY7U95buHtdN0bB0O4y2ZHdSNv4V2TQYTfXwOFu
         GlyCsdsohuH01NfR/Syf5p4cEOeMF8N8DIRBmVWuIPzeQ2gQQA7780AJTsygKhuFSq
         uzZmR2YNcl+hPBiIw/Y9dEKvnw+pNfka2gFIsqG1n2sL2wrBhncbc92vsiwZK/wR72
         oYPdfwAyW8Oi5+QRuq5QtCwAatXbm//NFiMLd2ewIM15aeuTu8FcO3emcEceac1Br3
         ACHInAhw/ajkMgj2mr5yKsyBiQO1+pWZY3uuFwRwUl1sv5KzYok5HP1r+OB0OEc1iP
         QDid6wIhqz8Aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 395F0E8DD5B;
        Thu, 10 Mar 2022 22:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/5] net/mlx5: Fix size field in bufferx_reg struct
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695201123.27699.8281743298948152683.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 22:40:11 +0000
References: <20220309201517.589132-2-saeed@kernel.org>
In-Reply-To: <20220309201517.589132-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        mohammadkab@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com
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

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed,  9 Mar 2022 12:15:13 -0800 you wrote:
> From: Mohammad Kabat <mohammadkab@nvidia.com>
> 
> According to HW spec the field "size" should be 16 bits
> in bufferx register.
> 
> Fixes: e281682bf294 ("net/mlx5_core: HW data structs/types definitions cleanup")
> Signed-off-by: Mohammad Kabat <mohammadkab@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,1/5] net/mlx5: Fix size field in bufferx_reg struct
    https://git.kernel.org/netdev/net/c/ac77998b7ac3
  - [net,2/5] net/mlx5: Fix a race on command flush flow
    https://git.kernel.org/netdev/net/c/063bd3555954
  - [net,3/5] net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE
    https://git.kernel.org/netdev/net/c/39bab83b119f
  - [net,4/5] net/mlx5e: Lag, Only handle events from highest priority multipath entry
    https://git.kernel.org/netdev/net/c/ad11c4f1d8fd
  - [net,5/5] net/mlx5e: SHAMPO, reduce TIR indication
    https://git.kernel.org/netdev/net/c/99a2b9be077a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


