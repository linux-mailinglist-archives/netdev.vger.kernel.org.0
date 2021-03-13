Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5070533A1BB
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 23:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhCMWk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 17:40:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhCMWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 17:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 613B464ED0;
        Sat, 13 Mar 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615675209;
        bh=SzmcOc3b7s8uTEQNZzn+rEGLCD+Ox6G1adM4XfdZExM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FUo7miGJ3UsVcWU4+akLHRDHRb6mVyETZnJ4wmvPeaXPR52ENQD/gMTX+fKeQVb8m
         4zENBE6cByJu2iqzB/aHbQqBIfrPbR+T7ReVIE+g8bNvfdvTxw1tPMvRIsIk2RipXH
         Prfm9xSPI7ZkVE5gvfMibfvdS8FFFZsF4zOm8gBLtL0rYvR+JUWDezKE5ic5T91g3Y
         C8hib8RAqCRLLPayoygUdQnSKS+tWD4EQ/X8ynH4tNArtX9sgnFNXZF8ZBDLogfaMg
         PG3vAq6el+KkJxzkeGiXUNwOdcU2Quht2nwxa94JqMfDrVrFa8U8nkMP988dhXUh03
         LUnzK5rWODAcw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 506FB60A5C;
        Sat, 13 Mar 2021 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/3] net/sched: act_police: add support for
 packet-per-second policing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161567520932.31370.758359706075759193.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 22:40:09 +0000
References: <20210312140831.23346-1-simon.horman@netronome.com>
In-Reply-To: <20210312140831.23346-1-simon.horman@netronome.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xingfeng.hu@corigine.com,
        baowen.zheng@corigine.com, louis.peens@netronome.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Mar 2021 15:08:28 +0100 you wrote:
> This series enhances the TC policer action implementation to allow a
> policer action instance to enforce a rate-limit based on
> packets-per-second, configurable using a packet-per-second rate and burst
> parameters.
> 
> In the hope of aiding review this is broken up into three patches.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/3] flow_offload: add support for packet-per-second policing
    https://git.kernel.org/netdev/net-next/c/25660156f4cc
  - [v3,net-next,2/3] flow_offload: reject configuration of packet-per-second policing in offload drivers
    https://git.kernel.org/netdev/net-next/c/6a56e19902af
  - [v3,net-next,3/3] net/sched: act_police: add support for packet-per-second policing
    https://git.kernel.org/netdev/net-next/c/2ffe0395288a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


