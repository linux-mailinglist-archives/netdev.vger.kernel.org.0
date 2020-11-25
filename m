Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A82C3847
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgKYEuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbgKYEuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 23:50:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606279805;
        bh=t6gTTtbxt4F8w+SUw/0TysKjqQtOE4UyCsPfWYyKUE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GiQCUt4yFmBXk+KYnD6l1EmdA53mN6y5kUIH+X1nTXEQ+8sfiNxa/VSpHtcTidxHf
         mnz4q+vTgqtae12WKvLKN9waWMOf9aMytP1Tv2g8PJ5X+2n3f0CURWnmgy8//Skrr1
         2PMyLky3ZUduyRumIrbKXhp+l1P3VwW3giTlMbTo=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 1/1] tc flower: fix parsing vlan_id and
 vlan_prio
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160627980560.12972.1583906545378858314.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Nov 2020 04:50:05 +0000
References: <20201124122810.46790-1-roid@nvidia.com>
In-Reply-To: <20201124122810.46790-1-roid@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        dsahern@gmail.com, zahari.doychev@linux.com, jianbol@mellanox.com,
        jhs@mojatatu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (refs/heads/main):

On Tue, 24 Nov 2020 14:28:10 +0200 you wrote:
> When protocol is vlan then eth_type is set to the vlan eth type.
> So when parsing vlan_id and vlan_prio need to check tc_proto
> is vlan and not eth_type.
> 
> Fixes: 4c551369e083 ("tc flower: use right ethertype in icmp/arp parsing")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/1] tc flower: fix parsing vlan_id and vlan_prio
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ed40b7e2ae4d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


