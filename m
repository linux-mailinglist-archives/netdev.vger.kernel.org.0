Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769003D72F7
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 12:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhG0KUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 06:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236131AbhG0KUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 06:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 87B0F615A4;
        Tue, 27 Jul 2021 10:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627381205;
        bh=UW2M1/4TCVNCFKsae4zdsvLm6NULJdDXEABxqQsyB0I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H+r+eWnP2H7YZbTqxrYNzU9+kavMqv3eXx9l8kR5hrlHJZ7GoHeYXMqGxDawWjR7D
         yKUN5kGlD+ah/UQIb8ULcTo69r/7i/rOuvpln2GQSMfn+NuFm3+MZFRv6MmXKQ0y/W
         AIGsxDtN4VHrAMUk4SCcspzdODhcGkg3y0e51Th+DsMUUSE9aC/a3hWhGRdZm08Ga7
         AW17crNL1bcsN2YaspZd87Oiv/2gYqgpSvOySj8QXstIaMaLxEZQwlS+cY1EkYdWhM
         7zeSOQJNL6BDfOVRsY0+8FVP8G6EKEveLtwQKbTuuUHq7frSQRNuRNKLjCcjzj5YUN
         90TU+zVA+dE7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 78D5B60A56;
        Tue, 27 Jul 2021 10:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: build all switchdev drivers as modules when the
 bridge is a module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162738120548.32176.11946701736816024763.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 10:20:05 +0000
References: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        naresh.kamboju@linaro.org, grygorii.strashko@ti.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, idosch@nvidia.com, jiri@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, lkft@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 17:25:36 +0300 you wrote:
> Currently, all drivers depend on the bool CONFIG_NET_SWITCHDEV, but only
> the drivers that call some sort of function exported by the bridge, like
> br_vlan_enabled() or whatever, have an extra dependency on CONFIG_BRIDGE.
> 
> Since the blamed commit, all switchdev drivers have a functional
> dependency upon switchdev_bridge_port_{,un}offload(), which is a pair of
> functions exported by the bridge module and not by the bridge-independent
> part of CONFIG_NET_SWITCHDEV.
> 
> [...]

Here is the summary with links:
  - [net-next] net: build all switchdev drivers as modules when the bridge is a module
    https://git.kernel.org/netdev/net-next/c/b0e81817629a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


