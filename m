Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BD030943F
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhA3KSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232788AbhA3Aus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 19:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 73AAD64E0E;
        Sat, 30 Jan 2021 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611967806;
        bh=44rntuIBVqmy3DGHADrqSpogfV20cxxT/avQ18YPDDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HnHXjA7K8FtOopIJi6xFUtSQrEKY0SglZghlGBy84VMRx/8Hkwb/4G7bZUv2hl9co
         SZ6ad91Uh+1sMs3czJDsNEGeBfUrieHg8zqcqrJm59MrDd9FzpzYWn3BT4KnFVPVYk
         AeOMxiq2KeYz5bMQgF6NCQIuW9VVLZFhULbSubc+no0yc0tBq5JeMqfCFOmmh/Y3o2
         dmYcAmQsXzw/jRoRkpOGKF4SJlxynFbzokyUeHaCC51OT/WlKwLWsCzk98by78AQlo
         q5/QacjBpV+xtHsRbprKInd8uQgsOj2GKqs3TqBM8AqYwxbCm19To5o3WCr0KTt4Ig
         rZdPFnq2TNrsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7AE9E6095C;
        Sat, 30 Jan 2021 00:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] hv_netvsc: Copy packets sent by Hyper-V out of
 the receive buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161196780649.27852.15602248378687946476.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 00:50:06 +0000
References: <20210126162907.21056-1-parri.andrea@gmail.com>
In-Reply-To: <20210126162907.21056-1-parri.andrea@gmail.com>
To:     Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        mikelley@microsoft.com, linux-hyperv@vger.kernel.org,
        skarade@microsoft.com, juvazq@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 17:29:07 +0100 you wrote:
> Pointers to receive-buffer packets sent by Hyper-V are used within the
> guest VM.  Hyper-V can send packets with erroneous values or modify
> packet fields after they are processed by the guest.  To defend against
> these scenarios, copy (sections of) the incoming packet after validating
> their length and offset fields in netvsc_filter_receive().  In this way,
> the packet can no longer be modified by the host.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] hv_netvsc: Copy packets sent by Hyper-V out of the receive buffer
    https://git.kernel.org/netdev/net-next/c/0ba35fe91ce3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


