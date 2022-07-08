Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D3556B0F1
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 05:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbiGHDKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 23:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiGHDKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 23:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D7E31214;
        Thu,  7 Jul 2022 20:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5872AB81A9C;
        Fri,  8 Jul 2022 03:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B18EC341C8;
        Fri,  8 Jul 2022 03:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657249814;
        bh=hUb1J/cfIQYBVKSFpdw41ZNmvs0ACmGBKvHJvHy42ro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jPXSS3qatkE8XGA+Q37axo+fmvhKlGV03kTtV4olQMlgw/6rdexi+nlXMD1zEIqdw
         1A5lTXSz7W07VLWp85l15mBdWTihZ11Qais0mZqlEOrb/0U3ovUl9Fg1X6NMkezYEH
         TttXmCwsImp4mXaJb5OXFv9VhgXxohbg3xOSRW+K06RBpqSBV2m4bLcZC+6a2ehqlH
         Dqskct21lxq4VlmN2cxIG9ttlE4YoNUszkQUPwnovFtmRZx3f5bvKfT/Ex5FDed9KU
         ksI6wrpk+DiWCyeUUq2pYwjavctOJYCl7kJnKagpo64PwRCNB0YLvzmus7z9FNDMsn
         k9iJ2Gt9YFR3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E381AE45BDC;
        Fri,  8 Jul 2022 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3 0/5] PolarFire SoC macb reset support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165724981392.15320.15228672706280247998.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 03:10:13 +0000
References: <20220706095129.828253-1-conor.dooley@microchip.com>
In-Reply-To: <20220706095129.828253-1-conor.dooley@microchip.com>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 6 Jul 2022 10:51:24 +0100 you wrote:
> Hey all,
> Jakub requested that these patches be split off from the series
> adding the reset controller itself that I sent ~yesterday~ last
> week [0].
> 
> The Cadence MACBs on PolarFire SoC (MPFS) have reset capability and are
> compatible with the zynqmp's init function. I have removed the zynqmp
> specific comments from that function & renamed it to reflect what it
> does, since it is no longer zynqmp only.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/5] dt-bindings: net: cdns,macb: document polarfire soc's macb
    https://git.kernel.org/netdev/net-next/c/b09c6f8ff731
  - [net-next,v3,2/5] net: macb: add polarfire soc reset support
    https://git.kernel.org/netdev/net-next/c/8aad66aa59be
  - [net-next,v3,3/5] net: macb: unify macb_config alignment style
    https://git.kernel.org/netdev/net-next/c/649bef9c7663
  - [net-next,v3,4/5] net: macb: simplify error paths in init_reset_optional()
    https://git.kernel.org/netdev/net-next/c/ea242f821a2d
  - [net-next,v3,5/5] net: macb: sort init_reset_optional() with other init()s
    https://git.kernel.org/netdev/net-next/c/8a78ac73de20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


