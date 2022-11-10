Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66691623A75
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 04:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiKJDaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 22:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbiKJDaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 22:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70CA1DA42;
        Wed,  9 Nov 2022 19:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70E9861D50;
        Thu, 10 Nov 2022 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0E51C433D7;
        Thu, 10 Nov 2022 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668051018;
        bh=O14k1ggDNBHv3DRWoO/XfHSft9vlSiIXekKx5LXksTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sU6IyCI+RISMa4s6/W0SZuZJDvpYs1/n/Qlf2DIW2Vq5df4A3fcejTcs2uALMLWuA
         z1TsH5UsqdsWOGDevQB7IN4op+GckBP712Kv8tigQTD8+U//5ksoCZoy3OYPwNcNph
         4SZJHd/3t9Dtc81NWvbxE4h4kDYH09QGhYdQyOZvcVfxm0FICAT0PhVsxFbIkPjUs6
         S45OugdoxicrwMcBnIIIojqmpgHRwJIy+WThj7mHwxg2sEAlOEHLiCdd0GZG/+VB/b
         FKNvZfZL82NB422KYG28mvs7Vvrnu6oIHt7z50c9eUAsTjViJT/Wv9SCz4+09UmIOA
         ePLEq3amLBmww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A3D3BC395F6;
        Thu, 10 Nov 2022 03:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V7 0/2] net: lan743x: PCI11010 / PCI11414 devices
 Enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166805101866.26797.4654559771421215290.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 03:30:18 +0000
References: <20221107085650.991470-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20221107085650.991470-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        pabeni@redhat.com, edumazet@google.com, olteanv@gmail.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, Ian.Saturley@microchip.com
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

On Mon, 7 Nov 2022 14:26:48 +0530 you wrote:
> This patch series continues with the addition of supported features for the
> Ethernet function of the PCI11010 / PCI11414 devices to the LAN743x driver.
> 
> Raju Lakkaraju (2):
>   net: lan743x: Remove unused argument in lan743x_common_regs( )
>   net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414
>     chips
> 
> [...]

Here is the summary with links:
  - [net-next,V7,1/2] net: lan743x: Remove unused argument in lan743x_common_regs( )
    https://git.kernel.org/netdev/net-next/c/925638a2a037
  - [net-next,V7,2/2] net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414 chips
    https://git.kernel.org/netdev/net-next/c/9045220581fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


