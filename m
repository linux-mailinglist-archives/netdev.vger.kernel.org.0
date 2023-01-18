Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD4167118B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjARDKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjARDKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7D54FCFD
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 19:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2899C615E3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 882CFC433F1;
        Wed, 18 Jan 2023 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674011416;
        bh=6A88N+gyoa+hoTZehO6C5PanE0X2orFLN/I7W+1gHN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tRenA1Ygpky8bfYpvTwXPSjbdncP/nQzh10BUcR5o9pwql1OudPn6HuiZDdpqLMEP
         Zp1ifMfYDaEM0WVm2uGLxAdAkwp1xUVLTtu4tZe+OvM0B2dIw84HFcvt07x5OluiOk
         1SYKsci1tYajNFaWuf8DNzFnxLZnGXkdCwsNZpCTuw3iCiMIO6T1bjDuFDgeviQj66
         iBf+gXHfYl30m/jnZn2YWXY1EdwkRIQImINh2zMkQW5ZnQypr9ZzTr50JKGDpYuN7h
         S9gqJYdLqzq10lPSDs2V9HlWzYYEpWVvNO/VKWd17BtsavfjiUnf/zU1l3QSRFdvFC
         mQ+3AusIQtUQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C04DC41670;
        Wed, 18 Jan 2023 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] MAINTAINERS: Update AMD XGBE driver maintainers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167401141643.5924.5111580455338897525.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 03:10:16 +0000
References: <20230116085015.443127-1-Shyam-sundar.S-k@amd.com>
In-Reply-To: <20230116085015.443127-1-Shyam-sundar.S-k@amd.com>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Raju.Rangoju@amd.com, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 16 Jan 2023 14:20:15 +0530 you wrote:
> Due to other additional responsibilities Tom would no longer
> be able to support AMD XGBE driver.
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> ---
> v1->v2
> - Update the subject prefix with "net"
> 
> [...]

Here is the summary with links:
  - [net,v2] MAINTAINERS: Update AMD XGBE driver maintainers
    https://git.kernel.org/netdev/net/c/441717b6fdf2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


