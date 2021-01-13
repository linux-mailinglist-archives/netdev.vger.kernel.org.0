Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903772F42E1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbhAMEKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbhAMEKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A779623139;
        Wed, 13 Jan 2021 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610511010;
        bh=pc2nukmgCXvmb0R4vhA95RrsCn1ry3/qbveoL/SB2EI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WeRyyERgZ+3iFNCZ9Iqz27GEjO+ojjVDOnKnmganu83q3O1Gy7RGep//GVBJROs/j
         Y2SQAKfXIwimuIH1rTGHdMn86bS/eo4lQs2oyd6GB/S77HE7hYp2chBvQFhWRQqfKP
         Y88Fr4v07G6S+BtBOJrEiku9IisOFxwRmi/MUME7FhTqoMXgzKQbvQpvT+cTI8zzf4
         KZ4G7n0IooM1sbRTWl7w8x8enr546Mzr9w1aWmwZUPCCf/KKhXELYl98iThgMAHS/S
         OSAHbGiIpiGq4Abt7rD4l/6+qGz/3Bn9oFzjvESM2EtIcQIGzHhtWeaieO20OPHIws
         knvFfMEfsP1fA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id A220C604FD;
        Wed, 13 Jan 2021 04:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] hv_netvsc: Prevent packet loss during VF add/remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051101065.28597.1139365549910801459.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:10:10 +0000
References: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
To:     Long Li <longli@linuxonhyperv.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, longli@microsoft.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  8 Jan 2021 16:53:40 -0800 you wrote:
> From: Long Li <longli@microsoft.com>
> 
> This patch set fixes issues with packet loss on VF add/remove.
> 
> Long Li (3):
>   hv_netvsc: Check VF datapath when sending traffic to VF
>   hv_netvsc: Wait for completion on request SWITCH_DATA_PATH
>   hv_netvsc: Process NETDEV_GOING_DOWN on VF hot remove
> 
> [...]

Here is the summary with links:
  - [v2,1/3] hv_netvsc: Check VF datapath when sending traffic to VF
    https://git.kernel.org/netdev/net-next/c/69d25a6cf4ca
  - [v2,2/3] hv_netvsc: Wait for completion on request SWITCH_DATA_PATH
    https://git.kernel.org/netdev/net-next/c/8b31f8c982b7
  - [v2,3/3] hv_netvsc: Process NETDEV_GOING_DOWN on VF hot remove
    https://git.kernel.org/netdev/net-next/c/34b06a2eee44

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


