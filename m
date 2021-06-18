Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29F73AD2D7
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhFRTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233325AbhFRTcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 01A6B613E2;
        Fri, 18 Jun 2021 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044605;
        bh=wlfeWrsEg7RaNI3XHVL5Q4/17K5hPzW0G2L1iHTZ3vA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sg7NSlbFSqNOpypVKPtUyw8TtsGfRgBelalzh32P2WrAdtttNiIShOJu4BcsdwXTE
         8tpf54E9+E/tV0jE0UxzyRRK+gqoIzJfm+XWKUHGI8EBrCIavcXMQ7V1FYWTyBsFUE
         gYZKi0MKzmhEl+vhfd+jtuVOV0wBw2KTLdUD+yXIs8JtMEsCVTjC1PqCxIkl9WTLD8
         8fwtNwGW5PiREll3TJ30oHjuvBBmps5farF2IJP1KGGiNvDlV5rWxgRKikWhpvyf+d
         9KZwO0P8f5aRxedD9nj0J+eWu4H+AZ4GMCj4L0mrnG7p/uxW1vuFxutx/4+eg08HAn
         Bb2868jFKas6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ECB1160CDF;
        Fri, 18 Jun 2021 19:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: allow the TTEthernet
 configuration in the static config for SJA1110
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404460496.16989.16734594196961016146.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:30:04 +0000
References: <20210618134400.2970928-1-olteanv@gmail.com>
In-Reply-To: <20210618134400.2970928-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 16:44:00 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently sja1105_static_config_check_valid() is coded up to detect
> whether TTEthernet is supported based on device ID, and this check was
> not updated to cover SJA1110.
> 
> However, it is desirable to have as few checks for the device ID as
> possible, so the driver core is more generic. So what we can do is look
> at the static config table operations implemented by that specific
> switch family (populated by sja1105_static_config_init) whether the
> schedule table has a non-zero maximum entry count (meaning that it is
> supported) or not.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: allow the TTEthernet configuration in the static config for SJA1110
    https://git.kernel.org/netdev/net-next/c/1303e7f9b64f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


