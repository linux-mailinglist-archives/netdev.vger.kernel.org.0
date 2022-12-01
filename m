Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7263F321
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiLAOuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLAOuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:50:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9743ABA0B
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 423E6CE1D10
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B5D1C433C1;
        Thu,  1 Dec 2022 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669906216;
        bh=c6CHoSg9JKI8+koY7ACVeNprfrnQEtOYkxjKB/ICGrI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=twu4lzfIJIPm13ru2I9Ay/J23+HNqWxu1IsKHp2MUyUIafyY67Kd7436FwGcvxSqI
         QsWhwfjLrcQYXxdym2DWnzQE7D4x3Ta+LGGkJjjAIV3U8SHxe36wmnEUKPjlYaso9T
         NCH6Dstw517ZrpjFxgDoXHgjmgmCbQEfLSYsJrF+nR2e8qsiPVlE0oa0uy4gLy31yD
         Jw67+R+HBm8Ia96HDaVHbc6VKqMxufYPN49OaWFTerWgHggNC3q0qoZwjqOLT3l+zL
         PSxsywmgu/hq9zhGGLLShO0HGetx9sSHADfP0uDnvhLZrfgh6h01HCUS84Aoj+RcYy
         C/juHRyntWzEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 202ECE21EF1;
        Thu,  1 Dec 2022 14:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH, net-next] r8169: use tp_to_dev instead of open code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166990621612.6736.17534603784407043658.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 14:50:16 +0000
References: <20221129161244.5356-1-claudiajkang@gmail.com>
In-Reply-To: <20221129161244.5356-1-claudiajkang@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 30 Nov 2022 01:12:44 +0900 you wrote:
> The open code is defined as a helper function(tp_to_dev) on r8169_main.c,
> which the open code is &tp->pci_dev->dev. The helper function was added
> in commit 1e1205b7d3e9 ("r8169: add helper tp_to_dev"). And then later,
> commit f1e911d5d0df ("r8169: add basic phylib support") added
> r8169_phylink_handler function but it didn't use the helper function.
> Thus, tp_to_dev() replaces the open code. This patch doesn't change logic.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: use tp_to_dev instead of open code
    https://git.kernel.org/netdev/net-next/c/4b6c6065fca1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


