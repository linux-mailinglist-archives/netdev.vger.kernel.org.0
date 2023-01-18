Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1156711F7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjARDaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjARDaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604493803F;
        Tue, 17 Jan 2023 19:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE82A61616;
        Wed, 18 Jan 2023 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C73DC433F0;
        Wed, 18 Jan 2023 03:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674012617;
        bh=omuTl0GGgedXhUw1Vk2tUrg0Bj+JCA067Dy7TMk4jf4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rtSlp0RM2dAifNHloO1bbrOirT/6VJiLDaYTkbnTXLJWEaG/9ZQ3eBeJF/3v9/LMl
         CwUKDazGZUOAfYCN3xzOJB7R6B3s/JIpiO+fVetrEg3NrPgkiDiLXeyXObJ8vh5IQJ
         qP0fjYjNL2fA4ls29qfedhn+sHcGlmHvY8idu7Cso3iJTVSD7xm0e0JldM66RVRvhx
         uxNP5hrLbkBO3B0XPgTYqSzE8bA49TRq4t19bBQ4go1HD+dZyMN2azzW9Hc06HK0Ks
         bRvMevEcKJKUwse2zxPhS2eC9ho6u4AOEsDQR8ofp7Yr85dNjc3z1x7Hk+zpV70hRE
         J8/gF/GzT/RWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E094C43159;
        Wed, 18 Jan 2023 03:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bluetooth 2023-01-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167401261718.15291.7727489631552411242.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 03:30:17 +0000
References: <20230118002944.1679845-1-luiz.dentz@gmail.com>
In-Reply-To: <20230118002944.1679845-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Jan 2023 16:29:44 -0800 you wrote:
> The following changes since commit 1f3bd64ad921f051254591fbed04fd30b306cde6:
> 
>   net: stmmac: fix invalid call to mdiobus_get_phy() (2023-01-17 13:33:19 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-01-17
> 
> [...]

Here is the summary with links:
  - pull-request: bluetooth 2023-01-17
    https://git.kernel.org/netdev/net/c/010a74f52203

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


