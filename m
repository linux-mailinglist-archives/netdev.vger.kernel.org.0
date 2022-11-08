Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D97620663
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiKHCAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiKHCAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ED7193D1;
        Mon,  7 Nov 2022 18:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D63F7B80DEE;
        Tue,  8 Nov 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D85BC433D6;
        Tue,  8 Nov 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667872815;
        bh=HDQ2TDxvSS1IwfPsODkR3zIQHw40nczdjzFD2snPd5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c98SkE+33VsYWThn7G07HlSO6R+QPic0dfgxsbVUdIqCND1El9MHQsX+t1f+QhV3o
         wJP+CD6HQUSC6WaJWU+CniwGITUgN2UhQ8WFcCap6VqCBjOhRQK37spG8fX/1R7Dvi
         5kqF6BwLEQ7xdYeieh/kh+DXTga5IVaDmWWX/muo/ZkENy/hcQSvKtTM6AFjmzAbap
         NEZ4pd4W3EhnoIbcA81zkZ/vXA7woEq9869iqOfHyZmUi+MLOPM3BvFpZcEzIHuwMS
         Hq1WMN55Sb+k+Yo4RNdE5RaCNrggAra9x4mN0lgnk4032J9i8UbF4VP/w1M/X8OCqM
         LZB/l5rnPntmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39D0EC4166D;
        Tue,  8 Nov 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: fix
 meson8b_devm_clk_prepare_enable()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166787281523.2068.14718320484490843210.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 02:00:15 +0000
References: <20221104083004.2212520-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20221104083004.2212520-1-linux@rasmusvillemoes.dk>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     martin.blumenstingl@googlemail.com, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri,  4 Nov 2022 09:30:04 +0100 you wrote:
> There are two problems with meson8b_devm_clk_prepare_enable(),
> introduced in a54dc4a49045 (net: stmmac: dwmac-meson8b: Make the clock
> enabling code re-usable):
> 
> - It doesn't pass the clk argument, but instead always the
>   rgmii_tx_clk of the device.
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()
    https://git.kernel.org/netdev/net/c/ed4314f77297

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


