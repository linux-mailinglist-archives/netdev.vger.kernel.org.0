Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A328B54DCB4
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 10:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359639AbiFPIUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 04:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiFPIUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 04:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE7E5C840;
        Thu, 16 Jun 2022 01:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4424B82292;
        Thu, 16 Jun 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60F48C3411B;
        Thu, 16 Jun 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655367616;
        bh=dB/CPPMhNm1buUrV4IgV1CCH8HWEcDujPAHshjsbK04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nCzhGbpDvd2LNSYKc2BtB7/N94nxXV17DzGact8Wx1iYSFSTYJk9/2HedKZYA/wEn
         vLNIs1qRodYLq6KXei3EsrajIVEiPPXdEybjbx/EV8IYInvOOuII/D18mu4HhFZCfp
         FH8gXMulbvzByI38ojJQGUoREtTDlNuWlVE37KB1Uhf2W3zIsQDYu2bLQ5AuzSXzY5
         QWgdm+wLDkiflfM5CxT8c70O8uK25Vbvw20+RkKssrfh1aeIBR63L1/PR5JbUZiZCn
         vFWp0SlspscG8/H5RZS9yGtEBWdST/9prIkc+v4RwIuNYekuyBnastmWt74LpflRrv
         +58fOG1ASLZEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C581FD99FF;
        Thu, 16 Jun 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2 1/2] net: ethernet: stmmac: add missing sgmii
 configure for ipq806x
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165536761624.29035.5999130282955171127.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Jun 2022 08:20:16 +0000
References: <20220614112228.1998-1-ansuelsmth@gmail.com>
In-Reply-To: <20220614112228.1998-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 14 Jun 2022 13:22:27 +0200 you wrote:
> The different gmacid require different configuration based on the soc
> and on the gmac id. Add these missing configuration taken from the
> original driver.
> 
> Signed-off-by: Christian 'Ansuel' Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  1 +
>  .../ethernet/stmicro/stmmac/dwmac-ipq806x.c   | 93 +++++++++++++++----
>  2 files changed, 78 insertions(+), 16 deletions(-)

Here is the summary with links:
  - [net-next,v2,1/2] net: ethernet: stmmac: add missing sgmii configure for ipq806x
    https://git.kernel.org/netdev/net-next/c/9ec092d2feb6
  - [net-next,v2,2/2] net: ethernet: stmmac: reset force speed bit for ipq806x
    https://git.kernel.org/netdev/net-next/c/8bca458990dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


