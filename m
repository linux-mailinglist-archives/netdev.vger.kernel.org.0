Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F453A4A70
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFKVCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230017AbhFKVCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 17:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB70F613C6;
        Fri, 11 Jun 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623445213;
        bh=4mihPOL2CONCSUOGSr2nPR24uK+oNcPDUrIwpH6k1hk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YuMl4+hH0gRSiXUjAO9FRxqVXvmsLrWNN9n9kR1EgB/llV3YyCKPt0ae18hM3dSFG
         ScM1OBiMIabeDGNKa4AYtjL25wqDkKXVVlr7H9UIUGjFFMAJIl3eHguvRYSc4/FVP1
         Uq6DL3yskxTRcp5H8F16nvx4aLPfFBpS+CodDLBR+kQQqJkCLOK25zaOF1VwNQcSlk
         LgzYFsosjoqff2bGGp11Th58zep47gpQcWSFxHsLhxaEAvK2+Tkl9dxRvKbbg0OICg
         q97bYxFsI3s6pbRG8KVPFmXg80/s4AWg0uCIX7upHi6A3GzIlvEfIlPwzipjfxxAVu
         tmtjVeefovETQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F7C360BE1;
        Fri, 11 Jun 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 00/13] Port the SJA1105 DSA driver to XPCS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344521364.30951.15091113709707705012.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 21:00:13 +0000
References: <20210611200531.2384819-1-olteanv@gmail.com>
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        vee.khee.wong@linux.intel.com, boon.leong.ong@intel.com,
        michael.wei.hong.sit@intel.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        Jose.Abreu@synopsys.com, mcoquelin.stm32@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 23:05:18 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As requested when adding support for the NXP SJA1110, the SJA1105 driver
> could make use of the common XPCS driver, to eliminate some hardware
> specific code duplication.
> 
> This series modifies the XPCS driver so that it can accommodate the XPCS
> instantiation from NXP switches, and the SJA1105 driver so it can expose
> what the XPCS driver expects.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,01/13] net: pcs: xpcs: rename mdio_xpcs_args to dw_xpcs
    https://git.kernel.org/netdev/net-next/c/5673ef863804
  - [v3,net-next,02/13] net: stmmac: reverse Christmas tree notation in stmmac_xpcs_setup
    https://git.kernel.org/netdev/net-next/c/47538dbeb701
  - [v3,net-next,03/13] net: stmmac: reduce indentation when calling stmmac_xpcs_setup
    https://git.kernel.org/netdev/net-next/c/7413f9a6af00
  - [v3,net-next,04/13] net: pcs: xpcs: move register bit descriptions to a header file
    https://git.kernel.org/netdev/net-next/c/d4433d5b7b34
  - [v3,net-next,05/13] net: pcs: xpcs: add support for sgmii with no inband AN
    https://git.kernel.org/netdev/net-next/c/2031c09e6d5f
  - [v3,net-next,06/13] net: pcs: xpcs: also ignore phy id if it's all ones
    https://git.kernel.org/netdev/net-next/c/36641b045c83
  - [v3,net-next,07/13] net: pcs: xpcs: add support for NXP SJA1105
    https://git.kernel.org/netdev/net-next/c/dd0721ea4c7a
  - [v3,net-next,08/13] net: pcs: xpcs: add support for NXP SJA1110
    https://git.kernel.org/netdev/net-next/c/f7380bba42fd
  - [v3,net-next,09/13] net: pcs: xpcs: export xpcs_do_config and xpcs_link_up
    https://git.kernel.org/netdev/net-next/c/a853c68e29bb
  - [v3,net-next,10/13] net: dsa: sja1105: migrate to xpcs for SGMII
    https://git.kernel.org/netdev/net-next/c/3ad1d171548e
  - [v3,net-next,11/13] net: dsa: sja1105: register the PCS MDIO bus for SJA1110
    https://git.kernel.org/netdev/net-next/c/27871359bdf8
  - [v3,net-next,12/13] net: dsa: sja1105: SGMII and 2500base-x on the SJA1110 are 'special'
    https://git.kernel.org/netdev/net-next/c/ece578bc3ea4
  - [v3,net-next,13/13] net: dsa: sja1105: plug in support for 2500base-x
    https://git.kernel.org/netdev/net-next/c/56b63466333b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


