Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B106D32DD3A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhCDWkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:40:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhCDWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C643164FF9;
        Thu,  4 Mar 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614897608;
        bh=9kkPpGdsGU5bMMNwGCo1G/gHG/+VPUbQSFXT+FJl2to=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JqA/Ul00nAWzDDRBZHts6Sm7tn9S0eUKOWBLkPawzrJ8pf8baUhY9NmUnwm7bEbW6
         8w6uT+RZ2c3m+dlhXsRc7Qwv+oWqPomqXNNpj8GaCBXGa0rV+OTX4tP0B97m3G7Nro
         cUmS5ro7SqvFnMG1jPXptZ8Qt4dl/i0wHe3mH5Mhj0yYJaW62d6Ec1oON9xd40t4sm
         WZBJAGZaZUwJLHiGpNWSVGjVqa6wdZmiqGZMkwekTSA+om6Q1NcBjlnCjYqhWJO31l
         V4l30LkLdNcwOrL36TmgxIU4f7LuqRRb89BWyb3lwsmT1JhuLIBJzYc4wqTmHPrPD6
         +OT6v6VtuFo6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B9D3B609E7;
        Thu,  4 Mar 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/9] mptcp: Fixes for v5.12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489760875.17160.2919416232115076199.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:40:08 +0000
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 13:32:07 -0800 you wrote:
> These patches from the MPTCP tree fix a few multipath TCP issues:
> 
> 
> Patches 1 and 5 clear some stale pointers when subflows close.
> 
> Patches 2, 4, and 9 plug some memory leaks.
> 
> [...]

Here is the summary with links:
  - [net,1/9] mptcp: reset last_snd on subflow close
    https://git.kernel.org/netdev/net/c/e0be4931f3fe
  - [net,2/9] mptcp: put subflow sock on connect error
    https://git.kernel.org/netdev/net/c/f07157792c63
  - [net,3/9] mptcp: fix memory accounting on allocation error
    https://git.kernel.org/netdev/net/c/eaeef1ce55ec
  - [net,4/9] mptcp: dispose initial struct socket when its subflow is closed
    https://git.kernel.org/netdev/net/c/17aee05dc882
  - [net,5/9] mptcp: reset 'first' and ack_hint on subflow close
    https://git.kernel.org/netdev/net/c/c8fe62f0768c
  - [net,6/9] mptcp: factor out __mptcp_retrans helper()
    https://git.kernel.org/netdev/net/c/2948d0a1e5ae
  - [net,7/9] mptcp: fix race in release_cb
    https://git.kernel.org/netdev/net/c/c2e6048fa1cf
  - [net,8/9] mptcp: fix missing wakeup
    https://git.kernel.org/netdev/net/c/417789df4a03
  - [net,9/9] mptcp: free resources when the port number is mismatched
    https://git.kernel.org/netdev/net/c/9238e900d6ec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


