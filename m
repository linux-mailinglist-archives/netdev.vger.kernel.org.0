Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00393A1F9B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFIWCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhFIWCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DE4C7613EF;
        Wed,  9 Jun 2021 22:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623276025;
        bh=nBnMXm6KGqdrOxYMuMLHvKdi0ixTY3+jw/4uIChlD+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d+5WIKZDE/jisTsH2iD9TsU818McdcjXp+KUliZcU8qjLFN/Cvt0+YtAy7hISmlaB
         iQ7KQUivXO9nQ9JAGwprRC/nTogf1n9AhPlouCEYxmelgfCOgeQPaWrvscAqMI8msG
         TzGE9lUQ/5o81pH1pWbG47tyftQuFsphDBd2oQ8i0unwCjT2fG+Ad+0e6EH2R3J0Tx
         +T9OU4i5++kthsfrZRbH4o90SzP7y5NCE+RyNA8LgzHXslRTTbbKOzX4pIXPUYCDta
         N0pBWMsIGoWKZk+SHv85kc3olFGSphTQe3Xp+msNHmT6YFaomK8FYhiwuUJJd92eVr
         yVUKpyFDBRX6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD599609E3;
        Wed,  9 Jun 2021 22:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rtnetlink: Fix regression in bridge VLAN configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327602583.7324.14263517606029743607.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:00:25 +0000
References: <20210609111753.1739008-1-idosch@idosch.org>
In-Reply-To: <20210609111753.1739008-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nikolay@nvidia.com, roopa@nvidia.com,
        jiapeng.chong@linux.alibaba.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  9 Jun 2021 14:17:53 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Cited commit started returning errors when notification info is not
> filled by the bridge driver, resulting in the following regression:
> 
>  # ip link add name br1 type bridge vlan_filtering 1
>  # bridge vlan add dev br1 vid 555 self pvid untagged
>  RTNETLINK answers: Invalid argument
> 
> [...]

Here is the summary with links:
  - [net] rtnetlink: Fix regression in bridge VLAN configuration
    https://git.kernel.org/netdev/net/c/d2e381c49636

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


