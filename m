Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6875D4CB6B9
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiCCGLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiCCGK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:10:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAC4165C35
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C643C6184D
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23FF1C340F3;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646287813;
        bh=QeiWLA8P3C7WPC5i3YJOZzowxr3+zfZgljiExCND4ss=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fYBH5jA1BSJMoEwHKvuUsLmLuZ8skdFWiIovG3zQHTTba6ohBopA9juoedUg569T8
         BAwTshUHRj4Of6IahU6OQhqETk2PfHMSntyczsleYciNxB6DiXUYt+9JLF4nkBfvIC
         EK6X6JcWmqEdYbrPQybdGxtpf/gWOtaWOAVabOGkGNbJqq7viIy4SQ+hy8iZk7z9RS
         05yn97DKq3Gigjnv+YmloBEYd+PEitK3HSoonwHdBxuYb+3/nUPoesDi1zIVao5inX
         qNFhA+lOmehRb6dwVK7wB0ftKIFR0lP9uDMw98o735ylxRBqAxKjLeIJ7zdKOA0eVx
         dzdtgJAiStVBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 022CAEAC096;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/4] batman-adv: Start new development cycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628781300.31171.6191462436150067665.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:10:13 +0000
References: <20220302163522.102842-2-sw@simonwunderlich.de>
In-Reply-To: <20220302163522.102842-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Wed,  2 Mar 2022 17:35:19 +0100 you wrote:
> This version will contain all the (major or even only minor) changes for
> Linux 5.18.
> 
> The version number isn't a semantic version number with major and minor
> information. It is just encoding the year of the expected publishing as
> Linux -rc1 and the number of published versions this year (starting at 0).
> 
> [...]

Here is the summary with links:
  - [1/4] batman-adv: Start new development cycle
    https://git.kernel.org/netdev/net-next/c/94ea9392e113
  - [2/4] batman-adv: Remove redundant 'flush_workqueue()' calls
    https://git.kernel.org/netdev/net-next/c/c138f67ad472
  - [3/4] batman-adv: Migrate to linux/container_of.h
    https://git.kernel.org/netdev/net-next/c/eb7da4f17dfc
  - [4/4] batman-adv: Demote batadv-on-batadv skip error message
    https://git.kernel.org/netdev/net-next/c/6ee3c393eeb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


