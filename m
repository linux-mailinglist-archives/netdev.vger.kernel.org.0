Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A846512DA2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343704AbiD1IDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343710AbiD1ID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:03:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89EB140A0;
        Thu, 28 Apr 2022 01:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCDC361F44;
        Thu, 28 Apr 2022 08:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8E82C385AF;
        Thu, 28 Apr 2022 08:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651132814;
        bh=NhzxeaiPtX29P/RQ1EZRDWoQ85Ud+xmKkVGCgk4axRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oWYnxOyhqwu9+DDI3nBKx2MYv9VAjqFHY9gZOLYQ7YbVsFEJJ2BlN+VLth0CqxAyY
         D0RIbVuZISIqam72WMojOrEbtuuJdeLTxWIr43XBLUrTSMM2wU/0RzZackNVo+znSv
         R6xYwOZN1ILqAXOmQIokF4HdL9m9mlh+R8axr5NmhzBn9QeibT6HhjaCGKK1akD++I
         NBTcWhpdT+1XK/N7PyiRmtUfZa7W7KdR4uGcZqGvrhrpcSrRk59ctb4UQJCVcsumFV
         19vY9gHiNU+PyLvznLounOc8CRMJIXkVSL5tZc5i52KP24cLttIjQg4U8PR/1U/Rq6
         L4srSq1YfbLYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC6A6F03848;
        Thu, 28 Apr 2022 08:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/3] Add reset deassertion for Aspeed MDIO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165113281383.18320.4392733597031620759.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 08:00:13 +0000
References: <20220427035501.17500-1-dylan_hung@aspeedtech.com>
In-Reply-To: <20220427035501.17500-1-dylan_hung@aspeedtech.com>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     robh+dt@kernel.org, joel@jms.id.au, andrew@aj.id.au,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        p.zabel@pengutronix.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, krzk+dt@kernel.org, BMC-SW@aspeedtech.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 27 Apr 2022 11:54:58 +0800 you wrote:
> Add missing reset deassertion for Aspeed MDIO bus controller. The reset
> is asserted by the hardware when power-on so the driver only needs to
> deassert it. To be able to work with the old DT blobs, the reset is
> optional since it may be deasserted by the bootloader or the previous
> kernel.
> 
> V6:
> - fix merge conflict for net-next
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/3] dt-bindings: net: add reset property for aspeed, ast2600-mdio binding
    https://git.kernel.org/netdev/net-next/c/65e42ad98e22
  - [net-next,v6,2/3] net: mdio: add reset control for Aspeed MDIO
    https://git.kernel.org/netdev/net-next/c/1585362250fe
  - [net-next,v6,3/3] ARM: dts: aspeed: add reset properties into MDIO nodes
    https://git.kernel.org/netdev/net-next/c/a8db203db05c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


