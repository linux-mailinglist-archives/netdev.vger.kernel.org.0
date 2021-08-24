Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FF83F59F0
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 10:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbhHXIky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 04:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232714AbhHXIkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 04:40:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C11CD6115A;
        Tue, 24 Aug 2021 08:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629794407;
        bh=STJ/i6P3q6ssBrBIuQRH8IN9VjGwetxyFGYvH9iL0rE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cs3ye/l+eop34RIyZYhv3TGaFrfvi5IrsZQEh4RnFgfw4piozEO+5lz6GxwpSjwoW
         YsT0xm4qip4gzdIthX7cpyIQKEIEDC/ufa/qJZUUYULjhBGFECCQNUkCXNbpsq8kEP
         7rTf0O4bsoz8GYEdZz4iy5smpfh04wYfdaY4t8gMWSoET77tPfTaqrAMkc9MBZJ4Sv
         bbT1JEDjWqcWdRc6OHyRsgE5cM73CsgiLPk6C2Y9Yhq75R11a+cTcPx2l14q+/TM3C
         1A8ef65VwKhhpin7CkVbuB7tyLLGJ3mHkrTR4appuMRx/0L0S6IBD2uHQUYjGDr6FJ
         yr2VAy8A3xEHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B436060978;
        Tue, 24 Aug 2021 08:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] Plug holes in DSA's software bridging support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979440773.30048.11995709555080920336.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 08:40:07 +0000
References: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, tobias@waldekranz.com,
        kurt@linutronix.de, alsi@bang-olufsen.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Aug 2021 00:22:54 +0300 you wrote:
> Changes in v2:
> - Make sure that leaving an unoffloaded bridge works well too
> - Remove a set but unused variable
> - Tweak a commit message
> 
> This series addresses some oddities reported by Alvin while he was
> working on the new rtl8365mb driver (a driver which does not implement
> bridge offloading for now, and relies on software bridging).
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] net: dsa: don't call switchdev_bridge_port_unoffload for unoffloaded bridge ports
    https://git.kernel.org/netdev/net-next/c/09dba21b432a
  - [v2,net-next,2/4] net: dsa: properly fall back to software bridging
    https://git.kernel.org/netdev/net-next/c/67b5fb5db76d
  - [v2,net-next,3/4] net: dsa: don't advertise 'rx-vlan-filter' when not needed
    https://git.kernel.org/netdev/net-next/c/06cfb2df7eb0
  - [v2,net-next,4/4] net: dsa: let drivers state that they need VLAN filtering while standalone
    https://git.kernel.org/netdev/net-next/c/58adf9dcb15b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


