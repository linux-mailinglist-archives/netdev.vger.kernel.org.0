Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8384A349D0C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCYXwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 19:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhCYXwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 19:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC8DB61A33;
        Thu, 25 Mar 2021 23:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616716327;
        bh=YoeSCBZuwmZaiEC1IHDfucuuBXYbPLZGL6t8Dkr/rHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ohjydKps5PRNRNh0CLaRnvHQxhcgCv0rOQBfdzt+NgAQG4A+tARA8g0+lghGlgEXU
         MNf2GNfik1yrv64qRe7u0PjCslW6mY6rBPCkyqnb062H13htRpqqeqMrvtfrrurv46
         HCvLkEHwmuhn7E8EbIfMieVM9Yobw1ezRUFnBDLOt3z0ttCOaTfB8d231wuLvMFZ2T
         l5cP+YM+haskRT2iX4DJ1tuSZBPx5atveaxDbbCqVLSnOSDfrd9MI8ZdWCYGkmES5P
         NQs81cHACzHrPAxCkarytVySOmKLeNRP5L7RM5dzKF/4mwxt14ukPHzlDIxuqG6B49
         evJ0jrIOhBkSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CBF0D609E8;
        Thu, 25 Mar 2021 23:52:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net: dsa: only unset VLAN filtering when last port
 leaves last VLAN-aware bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671632783.13409.1230205311868215983.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 23:52:07 +0000
References: <20210324095639.1354700-1-olteanv@gmail.com>
In-Reply-To: <20210324095639.1354700-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kurt@linutronix.de, tobias@waldekranz.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 24 Mar 2021 11:56:39 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA is aware of switches with global VLAN filtering since the blamed
> commit, but it makes a bad decision when multiple bridges are spanning
> the same switch:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link add br1 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br0
> ip link set swp4 master br1
> ip link set swp5 master br1
> ip link set swp5 nomaster
> ip link set swp4 nomaster
> [138665.939930] sja1105 spi0.1: port 3: dsa_core: VLAN filtering is a global setting
> [138665.947514] DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE
> 
> [...]

Here is the summary with links:
  - [v3,net] net: dsa: only unset VLAN filtering when last port leaves last VLAN-aware bridge
    https://git.kernel.org/netdev/net/c/479dc497db83

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


