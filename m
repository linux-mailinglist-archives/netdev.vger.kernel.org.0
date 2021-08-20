Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CD73F2DB6
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240798AbhHTOKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 10:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240308AbhHTOKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 10:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA123610FF;
        Fri, 20 Aug 2021 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629468605;
        bh=Q53Il28m8kGMtAWjXNQShZZM0+fN0olsOdvSlZ4MQCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K0amjP+HFCKBwmd1G0haYawvfg3UNDkXXFeDlogHYDqvVTQ7JS+iLDxAnkRu+AG+J
         aZoR5gCkWQ84y2AdiHrLFVUlL0dGhSGJF0SvLcWrwjT7Gmn0/a9BcbUbStO6ZwDLLC
         pjWWuJWacTiphCGpNtabREtBW6dC3zqBXE27LyD5pHSgzQB4JLWl3quLrJoDJK9IWc
         2Hj7eVrS0KfgvUmi55QWWZnDR2FNrBPWCzsSc8xOhY/MhCrijdBUjfajXQeZR+cqBB
         Gq3BFdbT1b/pRyFiTKS9XR31NYy5Mk12C9SACvQjSIvyi0mBW+SSGdFXTG2q8TpIT5
         k1MRjDqq4Elwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC0BB60A89;
        Fri, 20 Aug 2021 14:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: bridge: mcast: add support for port/vlan
 router control
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946860569.9666.13581662949976824444.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 14:10:05 +0000
References: <20210820124255.1465672-1-razor@blackwall.org>
In-Reply-To: <20210820124255.1465672-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Aug 2021 15:42:53 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This small set adds control over port/vlan mcast router config.
> Initially I had added host vlan entry router control via vlan's global
> options but that is really unnecessary and we can use a single per-vlan
> option to control it both for port/vlan and host/vlan entries. Since
> it's all still in net-next we can convert BRIDGE_VLANDB_GOPTS_MCAST_ROUTER
> to BRIDGE_VLANDB_ENTRY_MCAST_ROUTER and use it for both. That makes much
> more sense and is easier for user-space. Patch 01 prepares the port
> router function to be used with port mcast context instead of port and
> then patch 02 converts the global vlan mcast router option to per-vlan
> mcast router option which directly gives us both host/vlan and port/vlan
> mcast router control without any additional changes.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: bridge: mcast: br_multicast_set_port_router takes multicast context as argument
    https://git.kernel.org/netdev/net-next/c/a53581d5559e
  - [net-next,2/2] net: bridge: vlan: convert mcast router global option to per-vlan entry
    https://git.kernel.org/netdev/net-next/c/2796d846d74a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


