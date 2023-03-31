Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742F46D19DD
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjCaIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjCaIaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9EA138;
        Fri, 31 Mar 2023 01:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1256162500;
        Fri, 31 Mar 2023 08:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61B0CC4339C;
        Fri, 31 Mar 2023 08:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680251418;
        bh=7QfrtLvbG0uJ1TrCowUePYGhhQQUz93oXvSuBWFYU8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ae0pi98Q+nasfAkHWYoHFcUb1h3gd1I5498Awcf5IwdmEGh7GD4ZPF9jsoqQx/yIw
         9w5rU7q3/PxYPTF94G+oPnL85S8RtxB/CuMKVpwe8PY62/tE1W7Sed41cMyJ8ynUi3
         9wVuID9XBwlozlUy9dwwHabO3JAJuvjZP/lPiAadqwVa6r6F6bdkuWIHFtFS3Kn4jh
         sExqIpRUQLXFdUbkOdMHbxh1bKl1dmnhKEkLA9Xehv47SjYWaKhQzhLgsdSL3qUMzQ
         n6zMhpTvZtq1EGyOdbOdSXvezORCgnohYSrn58Kt02/nsp1SO4tHDnc1IGx+pPo75c
         NT2I2gwMXzFgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4723BC73FE2;
        Fri, 31 Mar 2023 08:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5 0/3] Fix PHY handle no longer parsing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168025141828.29195.16930878780114551946.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:30:18 +0000
References: <20230330091404.3293431-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20230330091404.3293431-1-michael.wei.hong.sit@intel.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        boon.leong.ong@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        hong.aun.looi@intel.com, weifeng.voon@intel.com,
        peter.jun.ann.lai@intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Mar 2023 17:14:01 +0800 you wrote:
> After the fixed link support was introduced, it is observed that PHY
> no longer attach to the MAC properly. So we introduce a helper
> function to determine if the MAC should expect to connect to a PHY
> and proceed accordingly.
> 
> Michael Sit Wei Hong (3):
>   net: phylink: add phylink_expects_phy() method
>   net: stmmac: check if MAC needs to attach to a PHY
>   net: stmmac: remove redundant fixup to support fixed-link mode
> 
> [...]

Here is the summary with links:
  - [net,v5,1/3] net: phylink: add phylink_expects_phy() method
    https://git.kernel.org/netdev/net/c/653a180957a8
  - [net,v5,2/3] net: stmmac: check if MAC needs to attach to a PHY
    https://git.kernel.org/netdev/net/c/fe2cfbc96803
  - [net,v5,3/3] net: stmmac: remove redundant fixup to support fixed-link mode
    https://git.kernel.org/netdev/net/c/6fc21a6ed595

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


