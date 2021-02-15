Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D1E31C37E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhBOVUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhBOVUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 16:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1B73564DE0;
        Mon, 15 Feb 2021 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613424007;
        bh=nUSsHWPNyz+VbC0Hii7ZpooxAXSQDGUKEg2fdwYaUxA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WPyLSL04cAGevSwM0sX0k9ATzssv5Fvn3dozPUptXAKm8vYCx6ZY4IFKHMVqr0R6O
         eiHyBZ5IJ+75vn7UqSc3o1Q5qBWfnGMwdgfnUrte6jtj9KZ7paCsdmzSdSCqthpL5N
         J8ElKdZb6TVFoOG7tTKSNy0S2PyITr0dcmo20Elc9aNlmCaFFEdFn5wvqxx7zYPBjP
         +SyLRbPSuzhpMJ+Q5aOsHF0P268cbN6odsObrDPYSsWqmOl6+gprnlJHnQcIzNXUU2
         l11xSTPBMOUvDEzLyFDt0uqxBjQlgKPU+I4Aezyk2LNM3TGfTzJDo+/YH2Cr7DI5MY
         zwtKyHILDVpJA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12789609D9;
        Mon, 15 Feb 2021 21:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Fixing build breakage after "Merge branch
 'Propagate-extack-for-switchdev-LANs-from-DSA'"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342400707.23138.3634090108529320036.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 21:20:07 +0000
References: <20210215210912.2633895-1-olteanv@gmail.com>
In-Reply-To: <20210215210912.2633895-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Feb 2021 23:09:10 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There were two build issues in the 'Propagate extack for switchdev VLANs
> from DSA', both related to function prototypes not updated for some stub
> definitions when CONFIG_SWITCHDEV=n and CONFIG_BRIDGE_VLAN_FILTERING=n.
> 
> Vladimir Oltean (2):
>   net: bridge: fix switchdev_port_attr_set stub when CONFIG_SWITCHDEV=n
>   net: bridge: fix br_vlan_filter_toggle stub when
>     CONFIG_BRIDGE_VLAN_FILTERING=n
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: bridge: fix switchdev_port_attr_set stub when CONFIG_SWITCHDEV=n
    https://git.kernel.org/netdev/net-next/c/419dfaed7ccc
  - [net-next,2/2] net: bridge: fix br_vlan_filter_toggle stub when CONFIG_BRIDGE_VLAN_FILTERING=n
    https://git.kernel.org/netdev/net-next/c/c97f47e3c198

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


