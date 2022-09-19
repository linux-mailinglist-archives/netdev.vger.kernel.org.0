Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9796E5BD63F
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiISVUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiISVUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E163CBC9
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 14:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 057D76207C
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 21:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6968EC433D7;
        Mon, 19 Sep 2022 21:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663622414;
        bh=gbwQEXM11AGmh9O0yseOZ/ecdNTJgGSxnmg9MOdzPHw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WeIbOEEesRgJQE9mq0PIjYtRWijnaNa4VYBTMTfUJQstOGKqNl2abmfVyFebAIqyI
         KAGORyLMeKSNBqwIF4FbJjmMiGQGhsyMebDAE9eLxHkGPAUcTIIKS3oGGgy9f2dnWD
         Zi7EboRa1GiklbqnH+5FHZCTBe3KjDB6gZHA7usiiKOZzM1Aq3uJ/EThcBN9nOAGfh
         4MTZimCOi8Qeq58ENstqHNwQwftJwkFlGo7Na95qgK5L8Qktqrnm+pbmGtVeU9xm5I
         i1XfQOJ2wP4OA5cf6KqGRaU0L+6d8UgN5T25uv8HrqVdHpeKQnFB+ZAmg6vOZqD08l
         8j07DUE0TTTyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4223DE52535;
        Mon, 19 Sep 2022 21:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: disable detection of chip version 36
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166362241426.4330.15070032226416813962.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Sep 2022 21:20:14 +0000
References: <ac622d4a-ae0a-3817-710f-849db4015c78@gmail.com>
In-Reply-To: <ac622d4a-ae0a-3817-710f-849db4015c78@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
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

On Fri, 9 Sep 2022 08:00:22 +0200 you wrote:
> I found no evidence that this chip version ever made it to the mass
> market. Therefore disable detection. Like in similar cases before:
> If nobody complains, we'll remove support for this chip version after
> few months.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: disable detection of chip version 36
    https://git.kernel.org/netdev/net-next/c/42666b2c452c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


