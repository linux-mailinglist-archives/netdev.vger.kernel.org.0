Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022756DEE61
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjDLIlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjDLIlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB3D7A98;
        Wed, 12 Apr 2023 01:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C926A62FFC;
        Wed, 12 Apr 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34CCEC4339C;
        Wed, 12 Apr 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681288819;
        bh=qOkIca4/8jj3nQqDneNarsb/U3LETLQotVRPGZMN/BI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vn6IR9vvGjKkaKAAM3BErP9Uizxv+DEY79u0XOjy5mvhlfYkrSkquI+wgw6tLSCBQ
         2NVpMqZj/D2IaWmZho5hwLDA0XpUnccIE/kcAZh5EV8TeOV5oUMsPhR0RSmT9hp/A+
         vy7mW7FkOVfftrrF+oQFO2mIn96ssHj9uNCHY0aQVZosDzTpfj80qiiKJrj9ghkGDz
         0y6GjVO3U2P3WNpz6gGZ7YPCjHkqYPQGUY1Dpr9AvOZeIFirbiaQNCR5XnNW/nF2Di
         dou0AlP/LIVS+MqucNGAFgB7JlAgtNgfBJEhkkYPAOIgqK5cCPW3rEBTWDWbOJaCfi
         FlWKtQXaTev+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18ED1E5244E;
        Wed, 12 Apr 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 0/2] Fix RK3588 error prints
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168128881909.3903.13367548922290396185.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 08:40:19 +0000
References: <20230407161129.70601-1-sebastian.reichel@collabora.com>
In-Reply-To: <20230407161129.70601-1-sebastian.reichel@collabora.com>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  7 Apr 2023 18:11:27 +0200 you wrote:
> Hi,
> 
> This fixes a couple of false positive error messages printed by stmmac on
> RK3588. I added Fixes tags, but I expect them to go via net-next, since
> the patches are more or less cleanups :)
> 
> Changes since PATCHv2:
>  * https://lore.kernel.org/all/20230405161043.46190-1-sebastian.reichel@collabora.com/
>  * Remove regulator NULL check
>  * Switch to devm_clk_bulk_get_optional as suggested by Andrew Lunn
> 
> [...]

Here is the summary with links:
  - [PATCHv3,1/2] net: ethernet: stmmac: dwmac-rk: rework optional clock handling
    https://git.kernel.org/netdev/net-next/c/ea449f7fa0bf
  - [PATCHv3,2/2] net: ethernet: stmmac: dwmac-rk: fix optional phy regulator handling
    https://git.kernel.org/netdev/net-next/c/db21973263f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


