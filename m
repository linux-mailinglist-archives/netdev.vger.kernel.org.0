Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D630624D80
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiKJWKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiKJWKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A040545A13
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 401AE61E74
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 22:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 931FCC43143;
        Thu, 10 Nov 2022 22:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668118215;
        bh=n88NuntTkqOsfuBHVTwPMtTJfuYj5W2+XD9umvsCa1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uqSxYtXHqOuqB0OEX///g2b2xBJ67LH4TVVObzG39AxnuOu4BJNBCrZuvS/MGorvM
         fIWOFPdP/2lZGkRLptPsKyg6aE+xlX6PrCToBTwTA376SYJSBxx98d9BvhDVpASVN/
         EYVhA8F88Pbc2s6JK/eUFkQ74rU8RKZ2oJRIysoIQ8TcqdcjCnBpYPyrwehOz6z8Lr
         Fm6aQzjeqGlItirA//jhA98eMfVoXsuEIrnoq/vBHGV4HKKfMJ77yaqAztTMH12rnl
         4fU8iLlx5XQGWUKjLDdXYEgeSieN8IL/AeP9OWa62jOfBoHSczz3dSTZqf84F71DeJ
         Sd2YHvChndMOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AF50E270EF;
        Thu, 10 Nov 2022 22:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Fix warning when unregistering a port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166811821550.11680.621006502765862958.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 22:10:15 +0000
References: <20221110085150.520800-1-idosch@nvidia.com>
In-Reply-To: <20221110085150.520800-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jiri@nvidia.com,
        mlxsw@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 10:51:50 +0200 you wrote:
> When a devlink port is unregistered, its type is expected to be unset or
> otherwise a WARNING is generated [1]. This was supposed to be handled by
> cited commit by clearing the type upon 'NETDEV_PRE_UNINIT'.
> 
> The assumption was that no other events can be generated for the netdev
> after this event, but this proved to be wrong. After the event is
> generated, netdev_wait_allrefs_any() will rebroadcast a
> 'NETDEV_UNREGISTER' until the netdev's reference count drops to 1. This
> causes devlink to set the port type back to Ethernet.
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: Fix warning when unregistering a port
    https://git.kernel.org/netdev/net-next/c/1fb22ed67195

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


