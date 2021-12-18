Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4DC479859
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhLRDUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:20:16 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46434 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhLRDUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:20:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA9DDCE2745
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 03:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF7B9C36AE7;
        Sat, 18 Dec 2021 03:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639797613;
        bh=85OgP82oX9mnOVmW8d6QY4z6eocqyuVS0ltuD/JXEco=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F3+tyfYOA9+MuXhX2AuSfNzi0f4qVaEjpo/6oyqunLNeiWEwb36O1u8j8pdmeXN5J
         DREfYLNfY1awplT8N59eUS+tRnHQ5yuIiNfiTGhPTqTq9X2zfNWiB7ncsjVZlNHwfG
         R1Vg/6oZs3a2jvrZbnKib0dcjafd2guOzX12ktjq+1opNk5Gd4scPF1ItTpA9yP0lO
         QOhfV0B6WSwjZsbBPIvdjNPjPui0aAGtp6IZl81BYBJXaJQugPWFNVxoYquqkIVapb
         mPIRIDwb+iTlLsYHzGqjVsnaIiiKJSlDtp6Q6wmKNlkaamNbrVN24FEDtoqAk6HPtC
         DtNMn4/wLJSHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C895960A2F;
        Sat, 18 Dec 2021 03:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] net/sched: Fix ct zone matching for invalid
 conntrack state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979761281.13981.14649200407398672631.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:20:12 +0000
References: <20211214172435.24207-1-paulb@nvidia.com>
In-Reply-To: <20211214172435.24207-1-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, saeedm@nvidia.com,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, pshelar@ovn.org,
        davem@davemloft.net, jiri@nvidia.com, wenxu@ucloud.cn,
        kuba@kernel.org, marcelo.leitner@gmail.com, ozsh@nvidia.com,
        vladbu@nvidia.com, roid@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Dec 2021 19:24:32 +0200 you wrote:
> Hi,
> 
> Currently, when a packet is marked as invalid conntrack_in in act_ct,
> post_ct will be set, and connection info (nf_conn) will be removed
> from the skb. Later openvswitch and flower matching will parse this
> as ct_state=+trk+inv. But because the connection info is missing,
> there is also no zone info to match against even though the packet
> is tracked.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] net/sched: Extend qdisc control block with tc control block
    https://git.kernel.org/netdev/net/c/ec624fe740b4
  - [net,v3,2/3] net/sched: flow_dissector: Fix matching on zone id for invalid conns
    https://git.kernel.org/netdev/net/c/384959586616
  - [net,v3,3/3] net: openvswitch: Fix matching zone id for invalid conns arriving from tc
    https://git.kernel.org/netdev/net/c/635d448a1cce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


