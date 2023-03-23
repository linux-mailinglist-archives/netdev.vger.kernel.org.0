Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB4A6C5EAD
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjCWFUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCWFUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DC31BCB;
        Wed, 22 Mar 2023 22:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1CAB623FC;
        Thu, 23 Mar 2023 05:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C9FCC4339B;
        Thu, 23 Mar 2023 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548819;
        bh=ePl2HzKh69zHsM77dwMHVX8U4WFciv4TLxr1n+TsI1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tAniKyApeailT1NhR+GnGSQy+ojlIfhuqUoo20ebS+Jfqg+ZS9PXeCe0xWVOx+BDx
         33qzMaXlLZxSBb4xhO7/K0MKVscn9BRE4cFEEJb+zAFF2Wcy+St7RD5uN44SyhYuIO
         iSSwbxIrX0TxqYQ3eKYgWbeIAm3JJ5jJYtuiQmEO1W3ssGjnAc7+pNrslmRWc1dTKO
         4QAxEGMtm/U7+6RXc2GonwXXmOwI8rF6GnxAor66nRwFAshkg5mN1BAnP24YCdptK1
         OtxkkVDm3rQkv0RVBsTEEk7qHOMkS113rq1gUkQdEEH4VTAISew2sEdXcuR8N1nqzy
         JxHmKuVEA++nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 362BCE4F0D7;
        Thu, 23 Mar 2023 05:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Add CPSWxG SGMII support for J7200 and J721E
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954881921.1221.2850229967308936778.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:20:19 +0000
References: <20230321111958.2800005-1-s-vadapalli@ti.com>
In-Reply-To: <20230321111958.2800005-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, rogerq@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 16:49:54 +0530 you wrote:
> Hello,
> 
> This series adds support to configure the CPSW Ethernet Switch in SGMII
> mode, using the am65-cpsw-nuss driver. SGMII mode is supported by the
> CPSWxG instances on TI's J7200 and J721E SoCs. Thus, SGMII mode is added
> in the list of extra_modes for the appropriate compatibles corresponding
> to the aforementioned SoCs.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: ethernet: ti: am65-cpsw: Simplify setting supported interface
    https://git.kernel.org/netdev/net-next/c/a2935a1cd85f
  - [net-next,2/4] net: ethernet: ti: am65-cpsw: Add support for SGMII mode
    https://git.kernel.org/netdev/net-next/c/e0f72db37547
  - [net-next,3/4] net: ethernet: ti: am65-cpsw: Enable SGMII mode for J7200
    https://git.kernel.org/netdev/net-next/c/2e20e764f24e
  - [net-next,4/4] net: ethernet: ti: am65-cpsw: Enable SGMII mode for J721E
    https://git.kernel.org/netdev/net-next/c/186016da9cca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


