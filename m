Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4143B23AD
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 00:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFWWwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 18:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFWWwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 18:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B5926044F;
        Wed, 23 Jun 2021 22:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624488603;
        bh=ibs3CY5e94B0KKNSU4Td8H8DmHFlEdGp5UFEB2opioU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TZ+d5bIAWNnu7h8yk6EpuEA6xPR7Ew6us9uaHuolF7cF2zKRFvhNshkNWj6JJiy0u
         T68oPmitv+Ek7nVUJ8qeYbxQ1y6JauJrl8CUEyjq4pZx1Fs5vpMV253u3mbh2dEOut
         E6/53Z58nG9CwBfDwhIS2OyEMxNwtFUq59IQmsIgeaydnXGoIcJT4F+LBcBRDHcmbo
         nsURTdxOZBBgjz9UsKQv500/vnWLyiG+JR4isE57qvS/HQBkD05z1B5NvVrJIY5asO
         nwE4KqTASQ7wnbn83JRNEq3dJRgaH5d+TYDmuLLJNdfzDrv+YSewvGC2e2mdmvnNUj
         LK4BX6ytjOx8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 798B660A2F;
        Wed, 23 Jun 2021 22:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Fixes for devlink rate objects API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162448860349.14508.16122130005796050829.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 22:50:03 +0000
References: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
In-Reply-To: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
To:     Dmytro Linkin <dlinkin@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, parav@nvidia.com, vladbu@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 23 Jun 2021 16:43:12 +0300 you wrote:
> From: Dmytro Linkin <dlinkin@nvidia.com>
> 
> Patch #1 fixes not decreased refcount of parent node for destroyed leaf
> object.
> 
> Patch #2 fixes incorect eswitch mode check.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] devlink: Decrease refcnt of parent rate object on leaf destroy
    https://git.kernel.org/netdev/net-next/c/1321ed5e7648
  - [net-next,2/3] devlink: Remove eswitch mode check for mode set call
    https://git.kernel.org/netdev/net-next/c/ff99324ded01
  - [net-next,3/3] devlink: Protect rate list with lock while switching modes
    https://git.kernel.org/netdev/net-next/c/a3e5e5797faa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


