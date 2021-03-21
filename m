Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A133430AB
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 03:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhCUCbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 22:31:38 -0400
Received: from [198.145.29.99] ([198.145.29.99]:52780 "EHLO mail.kernel.org"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhCUCbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Mar 2021 22:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA9E561939;
        Sun, 21 Mar 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616293808;
        bh=KQNDPUOhFlaPIWXZWgTKcdgwOYtdxAGBDvH9pwzXH6M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bsQgQQifjlCxqE9i7lj6HeRxEvVjOKB8f8HJlSTaPs+ZPAMv1Cf3RmLcWqG9RNXk+
         YYy/Ny9k9WfEFsR0h7oeylS2HkwjNKB4x5eOgs0KLfSbM/1d0pxaXYP8HpDrrKnL3U
         ACax4TIuQpYxrqyjQZFHMMZcFDYEywVxYPwSKXkMkFpJxTMFGUsyRiiAi7M7jI956Z
         eClrxT14nuGr3nlmYKsLO8cE1WtneHjrzUWiXPFZXPgRITHG83gSQOyCtl++rRgq/k
         rT/Hxw+bdUQ/iQc61ae0JSGU07ANc6idVKcB8kAmdoRdTFM16f60idOTPNFIJa8MN1
         zdvIqMDkZcqhw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2A2F626ED;
        Sun, 21 Mar 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: dsa: sja1105: Clear VLAN filtering
 offload netdev feature"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161629380792.13310.11405605907983053846.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Mar 2021 02:30:07 +0000
References: <20210320230445.2484150-1-olteanv@gmail.com>
In-Reply-To: <20210320230445.2484150-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 21 Mar 2021 01:04:45 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This reverts commit e9bf96943b408e6c99dd13fb01cb907335787c61.
> 
> The topic of the reverted patch is the support for switches with global
> VLAN filtering, added by commit 061f6a505ac3 ("net: dsa: Add
> ndo_vlan_rx_{add, kill}_vid implementation"). Be there a switch with 4
> ports swp0 -> swp3, and the following setup:
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: dsa: sja1105: Clear VLAN filtering offload netdev feature"
    https://git.kernel.org/netdev/net-next/c/a1e6f641e307

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


