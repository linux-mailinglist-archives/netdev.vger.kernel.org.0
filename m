Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02B8685EBB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjBAFKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBAFKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D882B4FAE4;
        Tue, 31 Jan 2023 21:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD4360B0D;
        Wed,  1 Feb 2023 05:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFA43C4339B;
        Wed,  1 Feb 2023 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228219;
        bh=/NjIkaljrd3Egap7rXJKp0TJO/lsHoW6pjZpsK9ELA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eqhtt4prr3LI7abi3PZIw/8+neQOiGGO3grYXPi7pmiV//qqpJcMEBaWSKYcUDpQg
         VRkr2DD5+MgIBp4GwxXXEN9zSZNX72GjYLW8Sp1iY2EFj150iRKFGzlCtrwKlmVMJk
         CRUQcLfRXc15nlX3+oDqEV35sMBIjAYvpuypKNa5D9Dax6okU6r6Xr3Pm+sqxlyJoG
         uvRhKGEnL/cgjIzpog8Jpqlv1jSlD4MrNPm0FgnRP5B6dZn8OKT7mXjWIFsocEPSnX
         usLAj0fHx4m6e6fD01sCuilXobzscsDjEscho0PEs5ymZ56OVskepvi3+ir/ld9CBm
         WOCpm6PvUJGkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA72FE21EEC;
        Wed,  1 Feb 2023 05:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] net: mdio: add amlogic gxl mdio mux support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522821982.27789.12071351228778814707.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:10:19 +0000
References: <20230130151616.375168-1-jbrunet@baylibre.com>
In-Reply-To: <20230130151616.375168-1-jbrunet@baylibre.com>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-amlogic@lists.infradead.org, khilman@baylibre.com,
        neil.armstrong@linaro.org, da@lessconfused.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 30 Jan 2023 16:16:14 +0100 you wrote:
> Add support for the MDIO multiplexer found in the Amlogic GXL SoC family.
> This multiplexer allows to choose between the external (SoC pins) MDIO bus,
> or the internal one leading to the integrated 10/100M PHY.
> 
> This multiplexer has been handled with the mdio-mux-mmioreg generic driver
> so far. When it was added, it was thought the logic was handled by a
> single register.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] dt-bindings: net: add amlogic gxl mdio multiplexer
    https://git.kernel.org/netdev/net-next/c/cc732d235126
  - [v2,net-next,2/2] net: mdio: add amlogic gxl mdio mux support
    https://git.kernel.org/netdev/net-next/c/9a24e1ff4326

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


