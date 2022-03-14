Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3704D804C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiCNLBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiCNLBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A5A37BC9;
        Mon, 14 Mar 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CB9C61006;
        Mon, 14 Mar 2022 11:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6A85C340ED;
        Mon, 14 Mar 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647255613;
        bh=IiJhlYhZ6g/TA/bacm+eqYg+DkQp9+bkqaktgR5tNaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qZCXU+SIvg6ejPfjxgFwM94cwUr+dGrbSxKdwLCR582qjnMu4VvxbyChoa5R0+Kyy
         CUhGsIXxr4u5VruBHQBwcQSzebAWtC0e+pt/9IMyEtJpVA/7hixf+ixW8RrsG9rqCz
         rVgk2dDs7mEghjiR2R4IqYNPLfLzlc22fs0y7t6EHkksjrhqLjBv68PtshoiTwJZ27
         SHx7PM1I0NLAGBuWurySVzSF/uwHLhrvb4PR5reHMI/VJRm9kXk5BDPpswg5dC02am
         xkJ6O5ZkijqHch311ICB4xJ7Muq3Oke2n69Cq7pROywKk1sK7GQktXgBJHrA2r9aCT
         Cnjs16i6Y8jPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7636EAC095;
        Mon, 14 Mar 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/8] dpaa2-mac: add support for changing the
 protocol at runtime
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164725561368.8211.12808979702945617706.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 11:00:13 +0000
References: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
In-Reply-To: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Mar 2022 23:22:20 +0200 you wrote:
> This patch set adds support for changing the Ethernet protocol at
> runtime on Layerscape SoCs which have the Lynx 28G SerDes block.
> 
> The first two patches add a new generic PHY driver for the Lynx 28G and
> the bindings file associated. The driver reads the PLL configuration at
> probe time (the frequency provided to the lanes) and determines what
> protocols can be supported.
> Based on this the driver can deny or approve a request from the
> dpaa2-mac to setup a new protocol.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/8] phy: add support for the Layerscape SerDes 28G
    https://git.kernel.org/netdev/net-next/c/8f73b37cf3fb
  - [net-next,v5,2/8] dt-bindings: phy: add bindings for Lynx 28G PHY
    https://git.kernel.org/netdev/net-next/c/c553f22e0531
  - [net-next,v5,3/8] dpaa2-mac: add the MC API for retrieving the version
    https://git.kernel.org/netdev/net-next/c/38d28b02a08e
  - [net-next,v5,4/8] dpaa2-mac: add the MC API for reconfiguring the protocol
    https://git.kernel.org/netdev/net-next/c/332b9ea59e56
  - [net-next,v5,5/8] dpaa2-mac: retrieve API version and detect features
    https://git.kernel.org/netdev/net-next/c/dff953813e7d
  - [net-next,v5,6/8] dpaa2-mac: move setting up supported_interfaces into a function
    https://git.kernel.org/netdev/net-next/c/aa95c3711241
  - [net-next,v5,7/8] dpaa2-mac: configure the SerDes phy on a protocol change
    https://git.kernel.org/netdev/net-next/c/f978fe85b8d1
  - [net-next,v5,8/8] arch: arm64: dts: lx2160a: describe the SerDes block #1
    https://git.kernel.org/netdev/net-next/c/3cbe93a1f540

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


