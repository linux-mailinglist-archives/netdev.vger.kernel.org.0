Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C61458F45
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhKVNXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237055AbhKVNXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 08:23:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 14BCD603E9;
        Mon, 22 Nov 2021 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637587209;
        bh=Mct6dKpv2DFJDUB4do+Q+GXIK+C/FsNl2KIGy5bfMD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m1TCFYIkldWxKTMLur89rKi5gOkdRt6OQeJNB26/BdxNAdRNoSzy2wL+r8pwfQUie
         Th/eND9pKi0+/qsdgPbTGEM4DR91rIuHbck/RgEV80sJu/fGioY18SrxkPWFsEPuFK
         re/83cCI2gbDzQjqv17JgPO6Py2QcK9dV53l+SF5pSjVmZNoWG/aGZ3DzniAktMwii
         FiXeIk8g0YqIGpS71zYK5QY/B1q5AR67Kkd+0Y2cNZnSue4cw2yGjLy2w7+caiBdZX
         D0PD/vChAbL3n9e/LFzKX4Lj70yN2sejLvZDzROPRHNOQSH+M7u19o4RohPFCgxxC8
         zzzz1gxdpzviw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0A10B60972;
        Mon, 22 Nov 2021 13:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: handle NA interface mode in
 phylink_fwnode_phy_connect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758720903.30653.16278585854605589627.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 13:20:09 +0000
References: <E1mo6kA-008ZGa-Ut@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mo6kA-008ZGa-Ut@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 16:28:06 +0000 you wrote:
> Commit 4904b6ea1f9db ("net: phy: phylink: Use PHY device interface if
> N/A") introduced handling for the phy interface mode where this is not
> known at phylink creation time. This was never added to the OF/fwnode
> paths, but is necessary when the phy is present in DT, but the phy-mode
> is not specified.
> 
> Add this handling.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: handle NA interface mode in phylink_fwnode_phy_connect()
    https://git.kernel.org/netdev/net-next/c/a18e6521a7d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


