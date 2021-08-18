Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861AE3F0044
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhHRJUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232016AbhHRJUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 05:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 61C7E6108D;
        Wed, 18 Aug 2021 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629278406;
        bh=E34R3QMCFjgiYXKgWkhWxihDMxJtNjNnxGvDvKZjm9s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OwmjyKOXfwyMSIzEHF/rode6uPijPJxUHyD/WNkYvlVGE5eeAZoA+dfOb3xhHkiax
         YKLIAUkztOassMf7qvEcoUb6V+PflKU+RJBgStKNAlRiwb/czevOgFPnSph3BuXskm
         bKMVzkwxf0MDvVOQxWiGIsVBYeGXoBWOyyoX43Y9GeztjYihxLBKr5n7eZigDj9dPq
         6fYX3q2/4QuMRchwziwU/Z6qS2dPLEMZkYW9G7i7ZQ8cooU3pu3c0fr+2fjzaascr/
         u5SecyxKSgQYZikxDac3I/0u4+N1CgKXfh3byXvzBMuHxvEjqOvxFmVqxFa54p43e0
         /z0wCgab2kHUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5385F60A2E;
        Wed, 18 Aug 2021 09:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mptcp: Add full mesh path manager option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162927840633.7428.12959095508156490312.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 09:20:06 +0000
References: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        geliangtang@xiaomi.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 15:07:21 -0700 you wrote:
> The path manager in MPTCP controls the creation of additional subflows
> after the initial connection is created. As each peer advertises
> available endpoints with the ADD_ADDR MPTCP option, the recipient of
> those advertisements must decide which subflows to create from the known
> local and remote interfaces that are available for use by MPTCP.
> 
> The existing in-kernel path manager will create one additional subflow
> when an ADD_ADDR is received, or a local address is newly configured for
> MPTCP use. The maximum number of subflows has a configurable limit.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mptcp: drop flags and ifindex arguments
    https://git.kernel.org/netdev/net-next/c/ee285257a9c1
  - [net-next,2/6] mptcp: remote addresses fullmesh
    https://git.kernel.org/netdev/net-next/c/2843ff6f36db
  - [net-next,3/6] mptcp: local addresses fullmesh
    https://git.kernel.org/netdev/net-next/c/1a0d6136c5f0
  - [net-next,4/6] selftests: mptcp: set and print the fullmesh flag
    https://git.kernel.org/netdev/net-next/c/371b90377e60
  - [net-next,5/6] selftests: mptcp: add fullmesh testcases
    https://git.kernel.org/netdev/net-next/c/4f49d63352da
  - [net-next,6/6] selftests: mptcp: delete uncontinuous removing ids
    https://git.kernel.org/netdev/net-next/c/f7713dd5d23a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


