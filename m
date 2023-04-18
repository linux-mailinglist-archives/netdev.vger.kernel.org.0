Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9B16E5FDA
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjDRLaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjDRLaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B8D468E;
        Tue, 18 Apr 2023 04:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 830AF61500;
        Tue, 18 Apr 2023 11:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC28FC433EF;
        Tue, 18 Apr 2023 11:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681817420;
        bh=rRRuyw16Gggmf7eYASFhnKYz5r8Dy2IULXNtZc9Bvlg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nkrMWq4qToOZjbhBPhZzz80EEZkQ92VKIKWFaMwgEkaCNSgXtCf9ZqINxjZQxGUT8
         eTUfdw6Ad4XDm4qGqLP58X5+M3x6d9qevSBnqGqw67kyV1Bdu1aEIiUd3fxZDD63jR
         OPUS7CDCWKdCisHG1/BJYr/01f46zx5ouO7xEap0wH0EDILz+YXeJur4QDHGExtEzz
         hwxOo0d+Qi9mujN5CNp6kIfdk5s4qD6CNmDMmdJNIcDc9+MDh3CHxHG2J6HiIFc8YH
         PK/2fKs9o8VRlpkJs8wCcTLcEJLjpGPxHrvLJ2riT3rl/DyidjgZZTVAzfFox4UdyQ
         TN4AUKBsbChVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA1A3C4167B;
        Tue, 18 Apr 2023 11:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [-net-next v12 0/6] Add Ethernet driver for StarFive JH7110 SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168181742075.8442.13068337635820008574.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 11:30:20 +0000
References: <20230417100251.11871-1-samin.guo@starfivetech.com>
In-Reply-To: <20230417100251.11871-1-samin.guo@starfivetech.com>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, kernel@esmil.dk,
        pmmoreir@synopsys.com, richardcochran@gmail.com, conor@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, andrew@lunn.ch, hkallweit1@gmail.com,
        pgwipeout@gmail.com, yanhong.wang@starfivetech.com,
        tomm.merciai@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 17 Apr 2023 18:02:45 +0800 you wrote:
> This series adds ethernet support for the StarFive JH7110 RISC-V SoC,
> which includes a dwmac-5.20 MAC driver (from Synopsys DesignWare).
> This series has been tested and works fine on VisionFive-2 v1.2A and
> v1.3B SBC boards.
> 
> For more information and support, you can visit RVspace wiki[1].
> You can simply review or test the patches at the link [2].
> This patchset should be applied after the patchset [3] [4].
> 
> [...]

Here is the summary with links:
  - [-net-next,v12,1/6] dt-bindings: net: snps,dwmac: Add dwmac-5.20 version
    https://git.kernel.org/netdev/net-next/c/13f9351180aa
  - [-net-next,v12,2/6] net: stmmac: platform: Add snps,dwmac-5.20 IP compatible string
    https://git.kernel.org/netdev/net-next/c/65a1d72f0c7c
  - [-net-next,v12,3/6] dt-bindings: net: snps,dwmac: Add 'ahb' reset/reset-name
    https://git.kernel.org/netdev/net-next/c/843f603762a5
  - [-net-next,v12,4/6] dt-bindings: net: Add support StarFive dwmac
    https://git.kernel.org/netdev/net-next/c/b76eaf7d7ede
  - [-net-next,v12,5/6] net: stmmac: Add glue layer for StarFive JH7110 SoC
    https://git.kernel.org/netdev/net-next/c/4bd3bb7b4526
  - [-net-next,v12,6/6] net: stmmac: dwmac-starfive: Add phy interface settings
    https://git.kernel.org/netdev/net-next/c/b4a5afa51cee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


