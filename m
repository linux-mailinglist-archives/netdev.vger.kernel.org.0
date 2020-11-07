Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59AD2AA7F5
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgKGUuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGUuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 15:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604782205;
        bh=TkgOvLmyz87dIrmf9/JVfIy5Q5NOZ3iXKtL5HLCho1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QpSzthDHghA7pToiZfOOYVVQlRFs7G08eOyw9G2YdXQui4E5vHcL/RCNPMv5rgNF9
         s1KYWoSUmHm4+Cn6T1+NnHsrS0t4zGKEjb7tkSu1m+itlvxw5Eqffqga8qTMbJmfoY
         +hqJ0j4EwnLrFcGoKNHfvC7L9sYFtEp0plU/iHdQ=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix compilation with
 CONFIG_BRIDGE=m
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160478220549.18540.15454874231670042478.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Nov 2020 20:50:05 +0000
References: <20201106161128.24069-1-vadym.kochan@plvision.eu>
In-Reply-To: <20201106161128.24069-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     volodymyr.mytnyk@plvision.eu, andrii.savka@plvision.eu,
        davem@davemloft.net, kuba@kernel.org, oleksandr.mazur@plvision.eu,
        serhiy.boiko@plvision.eu, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mickeyr@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  6 Nov 2020 18:11:25 +0200 you wrote:
> With CONFIG_BRIDGE=m the compilation fails:
> 
>     ld: drivers/net/ethernet/marvell/prestera/prestera_switchdev.o: in function `prestera_bridge_port_event':
>     prestera_switchdev.c:(.text+0x2ebd): undefined reference to `br_vlan_enabled'
> 
> in case the driver is statically enabled.
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: prestera: fix compilation with CONFIG_BRIDGE=m
    https://git.kernel.org/netdev/net/c/4e0396c59559

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


