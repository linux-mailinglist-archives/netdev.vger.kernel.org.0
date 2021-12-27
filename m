Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AB347FC92
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 13:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhL0MUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 07:20:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60198 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbhL0MUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 07:20:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F399660F3E;
        Mon, 27 Dec 2021 12:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A38EC36AEA;
        Mon, 27 Dec 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640607610;
        bh=SQrMEFYra9C4BRKy+1neHE0XyzVXDOv1jiQv0Jv6oN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nx0H8CTcdCM68qp/B5BCcCDX74G4OZQO0/qC1muxILT+vFEe9eEUoW5jFK7DkZ8/+
         6CVurzmLO9jkNMEiMlgVbqzSN1P8FgISVYSoxEbAXtyLrK9n0sGh9Ib9J/puI2l1oU
         3XbstqNr1dNZ1fNVPaRr420Fe/0o6rG22MiFMz1yhBMPaVhsJJLneXBCJ+3eC6fwlo
         UncnHCXGnIhv2hBGZcuUJ+DXXRB/X12d7M/zqOooVpZ4bBB5XEbMHClK8uOe+UcKGn
         2CHMv26MCROBeZekjtMBiFRayqv5XxqoRsxF3S43L+par774XRoxeFFZNoIL4WQVBO
         TZSFCB4ayIjHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F7D8C395E7;
        Mon, 27 Dec 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Fix the vlan used by host ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164060761025.26361.3395221354789370724.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 12:20:10 +0000
References: <20211223140113.1954778-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211223140113.1954778-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vladimir.oltean@nxp.com, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Dec 2021 15:01:13 +0100 you wrote:
> The blamed commit changed the vlan used by the host ports to be 4095
> instead of 0.
> Because of this change the following issues are seen:
> - when the port is probed first it was adding an entry in the MAC table
>   with the wrong vlan (port->pvid which is default 0) and not HOST_PVID
> - when the port is removed from a bridge, it was using the wrong vlan to
>   add entries in the MAC table. It was using the old PVID and not the
>   HOST_PVID
> 
> [...]

Here is the summary with links:
  - [net-next] net: lan966x: Fix the vlan used by host ports
    https://git.kernel.org/netdev/net-next/c/0c94d657d2a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


