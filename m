Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5E362B15
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhDPWak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233514AbhDPWah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 529296137D;
        Fri, 16 Apr 2021 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618612212;
        bh=LgUBioq4NItV47bYdgEBJoPGDw3DHMitnqMfUN9oSVw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sw0KscQAM2fBo/VaCzCY+7ruGIt9O81seAEMqoFqdSnAkviMbcpbU5xy16oQha3M6
         NAh2dWAizt7wqdNg0tvJTg9Rg24VV+Sp0L5x1jukvQSCX/qv4UL0fo+Q1uKeuWx4aB
         oKl0u8bz2xfCfvc1ZnuAWapq1X++Pa1U0eRZ7H6hP5p6XRovNUoLqdbiekogNkUjwd
         YEsqvNw19ylShoOFM5xd3YVZmA7zPHVIHd6ifY8WQSEwlyShSRZcFfTlN3VIpooQBn
         SQHzKf9SHTWrY+2gXYMX7jZnWpk8rxPbp/tQVNlbVPIe2CZvOrwWzqP0FDUfbp48wh
         Q75M09vMfb9eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4DC73609AF;
        Fri, 16 Apr 2021 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] mptcp: Improve socket option handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861221231.19916.16274065213493408212.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:30:12 +0000
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Apr 2021 16:44:49 -0700 you wrote:
> MPTCP sockets have previously had limited socket option support. The
> architecture of MPTCP sockets (one userspace-facing MPTCP socket that
> manages one or more in-kernel TCP subflow sockets) adds complexity for
> passing options through to lower levels. This patch set adds MPTCP
> support for socket options commonly used with TCP.
> 
> Patch 1 reverts an interim socket option fix (a socket option blocklist)
> that was merged in the net tree for v5.12.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] mptcp: revert "mptcp: forbit mcast-related sockopt on MPTCP sockets"
    https://git.kernel.org/netdev/net-next/c/bd005f53862b
  - [net-next,02/13] mptcp: move sockopt function into a new file
    https://git.kernel.org/netdev/net-next/c/0abdde82b163
  - [net-next,03/13] mptcp: only admit explicitly supported sockopt
    https://git.kernel.org/netdev/net-next/c/d9e4c1291810
  - [net-next,04/13] mptcp: add skeleton to sync msk socket options to subflows
    https://git.kernel.org/netdev/net-next/c/7896248983ef
  - [net-next,05/13] mptcp: tag sequence_seq with socket state
    https://git.kernel.org/netdev/net-next/c/df00b087da24
  - [net-next,06/13] mptcp: setsockopt: handle SO_KEEPALIVE and SO_PRIORITY
    https://git.kernel.org/netdev/net-next/c/1b3e7ede1365
  - [net-next,07/13] mptcp: setsockopt: handle receive/send buffer and device bind
    https://git.kernel.org/netdev/net-next/c/5d0a6bc82d38
  - [net-next,08/13] mptcp: setsockopt: support SO_LINGER
    https://git.kernel.org/netdev/net-next/c/268b12387460
  - [net-next,09/13] mptcp: setsockopt: add SO_MARK support
    https://git.kernel.org/netdev/net-next/c/36704413db79
  - [net-next,10/13] mptcp: setsockopt: add SO_INCOMING_CPU
    https://git.kernel.org/netdev/net-next/c/6f0d7198084c
  - [net-next,11/13] mptcp: setsockopt: SO_DEBUG and no-op options
    https://git.kernel.org/netdev/net-next/c/a03c99b253c2
  - [net-next,12/13] mptcp: sockopt: add TCP_CONGESTION and TCP_INFO
    https://git.kernel.org/netdev/net-next/c/aa1fbd94e5c7
  - [net-next,13/13] selftests: mptcp: add packet mark test case
    https://git.kernel.org/netdev/net-next/c/dc65fe82fb07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


