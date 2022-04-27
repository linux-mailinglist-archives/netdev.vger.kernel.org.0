Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1449E510D87
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356516AbiD0Axh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356499AbiD0Ax1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CD611A1E;
        Tue, 26 Apr 2022 17:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB6AB61AF2;
        Wed, 27 Apr 2022 00:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3C28C385A0;
        Wed, 27 Apr 2022 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020612;
        bh=MwmPAc3mXaQAY/JmKfl1Jub/wzo0Wnhd1Nmr194igt8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=icpqaKWtspwfdxK9xOUr1MbWPsuY8jjKeZ+UQe+NccevNL7RjOomJBDZFLUxiI5iM
         yNnkz/mRFMFTr96/NjHCzZebJeWAak0+uuC7Vx+vMwg49upQzAQ6Sj4YnOvrJeD9Rd
         T41rUsM7CsVBcZ6vHqojYRMxRGNHiaCpn8AcQqJeu/zTxbIUB/TPTeRDp/3fbaV20x
         ZvhMsTuOHugl9OfSkNMjAa12EvV/V9elKraPz1fr4tPrBT1tnt0+BEMKbREX7yAfNZ
         4FIiH/+XkhIfGKf6xJceladMSgEtfxAs63NlcLP6Vaikd6UtC9LxMEHm6/6G2DCFvX
         2F6lFAuJmInYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4EB1E8DD67;
        Wed, 27 Apr 2022 00:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] net: stmmac: dwmac-imx: comment spelling fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165102061186.18100.14886294105816558907.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 00:50:11 +0000
References: <20220425154856.169499-1-marcel@ziswiler.com>
In-Reply-To: <20220425154856.169499-1-marcel@ziswiler.com>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     netdev@vger.kernel.org, marcel.ziswiler@toradex.com,
        alexandre.torgue@foss.st.com, davem@davemloft.net,
        festevam@gmail.com, fugang.duan@nxp.com, peppe.cavallaro@st.com,
        kuba@kernel.org, joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-imx@nxp.com, pabeni@redhat.com, kernel@pengutronix.de,
        s.hauer@pengutronix.de, shawnguo@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 25 Apr 2022 17:48:56 +0200 you wrote:
> From: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> 
> Fix spelling in comment.
> 
> Fixes: 94abdad6974a ("net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip")
> Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> 
> [...]

Here is the summary with links:
  - [v1] net: stmmac: dwmac-imx: comment spelling fix
    https://git.kernel.org/netdev/net-next/c/b1190d5175ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


