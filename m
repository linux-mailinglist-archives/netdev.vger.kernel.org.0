Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AAD6B58A4
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCKFa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCKFaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23BDEFBC;
        Fri, 10 Mar 2023 21:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E9DCB824CC;
        Sat, 11 Mar 2023 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5ADF8C433EF;
        Sat, 11 Mar 2023 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678512619;
        bh=umalgSWmoyakJHglttC6xJjAEMWDWWI2RaLGY5ujHEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SJnLKrZZyewtU70v+YeQOWZJAekQPAqtregkY+koO/M2iE7vV88EV630b1AHVayPs
         H8VNLtu4isD74gvqbmSNpxRiTwRMJ0HJxKRhAI3CLEd2IO7X/nCodAxnl7cXGF2mQ1
         5R1fjfagjQWFX8dsYKsLrOeTOwNb2Z53K9CWkyvEIQLOVcL1BR95jQ+FQa6DoNP3qC
         vmPrtLGmaQlQaE0frFcmmHkMscgKfrIhxrXTPhfBMYWL09XMHpXyBHANM0YA51++iF
         hJyywgqq4ULjZZnGZDVD3Hqq9chh4INuYzCx5cUo4FGH4XqLWgssLkYuvCMyycRfkR
         2tqSIbpE86wMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 46CCFE270C7;
        Sat, 11 Mar 2023 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] Update CPSW bindings for Serdes PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851261928.13546.13495231311749922633.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:30:19 +0000
References: <20230309073612.431287-1-s-vadapalli@ti.com>
In-Reply-To: <20230309073612.431287-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        nsekhar@ti.com, rogerq@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Mar 2023 13:06:10 +0530 you wrote:
> Hello,
> 
> This series adds documentation for the Serdes PHY. Also, the name used to
> refer to the Serdes PHY in the am65-cpsw driver is updated to match the
> documented name.
> 
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Document Serdes PHY
    https://git.kernel.org/netdev/net-next/c/aacaf7b3d19d
  - [net-next,v3,2/2] net: ethernet: ti: am65-cpsw: Update name of Serdes PHY
    https://git.kernel.org/netdev/net-next/c/bca93b20c397

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


