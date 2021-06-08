Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942823A0619
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhFHVl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhFHVl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 17:41:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7AE9061375;
        Tue,  8 Jun 2021 21:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623188404;
        bh=CnTX+GzqUcAUmzuVB7l0JCf4hYJxelVKFuf9qhDfC4k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LzwDogR+mYwqeazs/7T+Y0Gyax9D97aMT9JZb4W+Jiy/dllSMes1YlaKkMK7Av5rn
         +vqf0xzPmlPL2WceAaPNBkcvj+TYE+3hkaGsJCTx8WO1s7X6Rr3wZaTvhW3U1ldEMv
         /oNwj3dtYkAr/m+IGGzUUfnI6+xrfreCJToNyDGV09glgz4eY7k+XmVOMX8NBmYU2Z
         m68xlSrf8KVO1As1WhilV11IIWxEkQAPOGmzWI9O3pW1M6v1L2sPnh1ZtYEe1UxF/Q
         5puwh5IoRS7skZD70vYJX+lA94+r+I8GHuY9A50ViAsKTUAYcRN3ObeiU+bjeJi2fo
         BJWC3WwldIb6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B26D60BE2;
        Tue,  8 Jun 2021 21:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/3] Enable 2.5Gbps speed for stmmac
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162318840443.3200.14704248998012548360.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 21:40:04 +0000
References: <20210608035158.4869-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20210608035158.4869-1-michael.wei.hong.sit@intel.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 11:51:55 +0800 you wrote:
> Intel mGbE supports 2.5Gbps link speed by overclocking the clock rate
> by 2.5 times to support 2.5Gbps link speed. In this mode, the serdes/PHY
> operates at a serial baud rate of 3.125 Gbps and the PCS data path and
> GMII interface of the MAC operate at 312.5 MHz instead of 125 MHz.
> This is configured in the BIOS during boot up. The kernel driver is not able
> access to modify the clock rate for 1Gbps/2.5G mode on the fly. The way to
> determine the current 1G/2.5G mode is by reading a dedicated adhoc
> register through mdio bus.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/3] net: stmmac: split xPCS setup from mdio register
    https://git.kernel.org/netdev/net-next/c/597a68ce3216
  - [net-next,v6,2/3] net: pcs: add 2500BASEX support for Intel mGbE controller
    https://git.kernel.org/netdev/net-next/c/f27abde3042a
  - [net-next,v6,3/3] net: stmmac: enable Intel mGbE 2.5Gbps link speed
    https://git.kernel.org/netdev/net-next/c/46682cb86a37

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


