Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532165BE334
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiITKaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiITKaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D2332AB5;
        Tue, 20 Sep 2022 03:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E51F622AB;
        Tue, 20 Sep 2022 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55FCFC433D7;
        Tue, 20 Sep 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663669815;
        bh=HwMmC3QTu8f4EuuTnEL4prXjFvNFLuqk/PsLT6aqt78=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OfOuQgdDrXpOfNojgnmKxMIjlvDcqFbK5Olr8ISIXRLpwai0GPNSzo5ghMtfVC1q0
         wtR6f//S58MXcb1Dno6f8jVcuaVL9maG0eJdxIf99412InUSnW2nEVuzueC2EvzPXf
         UM1z7z5rfAv+UpH6rkMejLEeVjEhACSfotsZzE3FrHDZS1CQwLAY3LUsgZqcBfNVCf
         JJ98pjq18vPw1koechSYoztccp59x5JJ9eFKHcVd0BlFGPHKDPPjrL4zJMWek5wUBF
         4nfC3IopNPJcnPtdt/QfKNmy2MX8azyKR32EjZw9oANZlg+JWgnqSpnuV8NcEfAg3p
         HoVvmN3FXan0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32F9CE21EDF;
        Tue, 20 Sep 2022 10:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Revert fec PTP changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166366981520.17428.6621108174286872749.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 10:30:15 +0000
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
In-Reply-To: <20220912070143.98153-1-francesco.dolcini@toradex.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, csokas.bence@prolan.hu,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, linux@roeck-us.net, andrew@lunn.ch
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 12 Sep 2022 09:01:41 +0200 you wrote:
> Revert the last 2 FEC PTP changes from Csókás Bence, they are causing multiple
> issues and we are at 6.0-rc5.
> 
> Francesco Dolcini (2):
>   Revert "fec: Restart PPS after link state change"
>   Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"
> 
> [...]

Here is the summary with links:
  - [net,1/2] Revert "fec: Restart PPS after link state change"
    https://git.kernel.org/netdev/net/c/7b15515fc1ca
  - [net,2/2] Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"
    https://git.kernel.org/netdev/net/c/01b825f997ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


