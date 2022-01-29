Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22EE4A3143
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 19:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346278AbiA2SAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 13:00:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40190 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiA2SAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 13:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F085B82807;
        Sat, 29 Jan 2022 18:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 467E5C340E7;
        Sat, 29 Jan 2022 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643479211;
        bh=cUX6zyXABgaJLSeqvqit7V5xHgkY1/1m0+E62v1u1DU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZjqOLmMQal8bBl2isJl4BxXZKsQZ5HzhOPQRK1StFa/iXD/R4qZ+bZLdBtlxgLVZN
         cx3t8t+sU53XreuVUdOgA2HwlDQ3T1zpRcspFuXw8B0Heyt5wmcSP9sZY374w8M2pn
         XjBRiCPL+k5nBVHmje/UkJ2WGdSe1R/dqf0maga6qv/V3cVjXbDdDKteqTQV7eeT7I
         HcSOlvRs+ReZKb4flMQC56rQAdXAVZRZiKeiNHsIu0ffhYU6qJjwRYAHJT+eBb1B7H
         f+4NWV7mwwSecs6cPgYfsLVvaokThEIel95IPHb5TzWlUAfDDq6yTLVoMwwlKuucF+
         MDrwgegw/Q2Fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28552E5D07E;
        Sat, 29 Jan 2022 18:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] Cadence MACB/GEM support for ZynqMP SGMII
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164347921116.25331.17257056412700364820.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Jan 2022 18:00:11 +0000
References: <20220127163736.3677478-1-robert.hancock@calian.com>
In-Reply-To: <20220127163736.3677478-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, michal.simek@xilinx.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        laurent.pinchart@ideasonboard.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 10:37:33 -0600 you wrote:
> Changes to allow SGMII mode to work properly in the GEM driver on the
> Xilinx ZynqMP platform.
> 
> Changes since v3:
> -more code formatting and error handling fixes
> 
> Changes since v2:
> -fixed missing includes in DT binding example
> -fixed phy_init and phy_power_on error handling/cleanup, moved
> phy_power_on to open rather than probe
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] dt-bindings: net: cdns,macb: added generic PHY and reset mappings for ZynqMP
    https://git.kernel.org/netdev/net-next/c/f4ea385a16c5
  - [net-next,v4,2/3] net: macb: Added ZynqMP-specific initialization
    https://git.kernel.org/netdev/net-next/c/8b73fa3ae02b
  - [net-next,v4,3/3] arm64: dts: zynqmp: Added GEM reset definitions
    https://git.kernel.org/netdev/net-next/c/e461bd6f43f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


