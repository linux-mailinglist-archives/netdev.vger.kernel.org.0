Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DCC331832
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhCHUKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231867AbhCHUKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 71F9F65272;
        Mon,  8 Mar 2021 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615234208;
        bh=G7OsJDG6I3N1co2iRaPmx6gpc0FQQ0V+Y+kQrRHbkcQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=STjnKjGP1TsEYT/074EZ+VdYi1uD+0U6XUww+JRePfdXN35fS5aMrHDByDrka/D+/
         mvgqascfSJ0w8lAW0lngY23lH18pEha4eb/iZGRdqCOMMcbWIi4lBgQfgxORxln4vM
         SKUDrbnACy5b1or0vy3NoDWh0gWgAFxpM6CeAMi/UQKgGiQ1btFHrVrgCAW05gHlnv
         y93w/FQuQrvxxlEBMG0V6TuxuHl5GGe+qiM8xC4rzY52knhM701/cTel1LLnmccn8K
         x4u4MQVNvBeu32rwh4qsQ49dXMW7MghK3/GW7ftsx5C6MEwWrKkDpRsmN3dkiLM8S+
         i1Lcmv6b/aswA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 60F926098E;
        Mon,  8 Mar 2021 20:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: fix switchdev objects on bridge master
 mistakenly being applied on ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161523420839.27243.12750056230898571378.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 20:10:08 +0000
References: <20210307102156.2282877-1-olteanv@gmail.com>
In-Reply-To: <20210307102156.2282877-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        tobias@waldekranz.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  7 Mar 2021 12:21:56 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Tobias reports that after the blamed patch, VLAN objects being added to
> a bridge device are being added to all slave ports instead (swp2, swp3).
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br0
> bridge vlan add dev br0 vid 100 self
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: fix switchdev objects on bridge master mistakenly being applied on ports
    https://git.kernel.org/netdev/net/c/03cbb87054c1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


