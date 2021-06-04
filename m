Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D623A39C23F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFDVVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFDVVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5FD8C613EC;
        Fri,  4 Jun 2021 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622841604;
        bh=KmDemZaKFYrvRbHIeLHMvQPkjNH8dTvNeqN5E8VxjPU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C6jMGp4ZkZtfV2US7dS4xL3gCu+gIWQgIlSSof/mZZ9luBrqU0SV28vUvkaHlzssC
         HKUV8IrDISRECQ5Fvz4Mqr2h9d1S/8FUSI7UBexWgRF12mH6V3o2DznopmzeblNNyP
         bTY2LneXp2vGvAz8sh2kDbbmmKKewlgkitb9l/0DqcnihPeuWQSmXqZyvSWhZ03IyV
         Faem4fS3nUYvhN8Gcto9Ul3vV1GAdOKVH29w2IWUNG8QHMb30/RQhe26Dap6dvFUUZ
         T4CQGcbf2B4PbhvzPeuiBGml4nhO9UBpdiRvWVT2yFV+wd4ep9OHIcJ1/Uf2WSbZxv
         0m54ClAVmLPMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 50B6060A13;
        Fri,  4 Jun 2021 21:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] mptcp: Add timestamp support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284160432.23356.2648510889334376322.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:20:04 +0000
References: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, fw@strlen.de, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  3 Jun 2021 16:24:26 -0700 you wrote:
> Enable the SO_TIMESTAMP and SO_TIMESTAMPING socket options for MPTCP
> sockets and add receive path cmsg support for timestamps.
> 
> Patches 1, 2, and 5 expose existing sock and tcp helpers for timestamps
> (no new EXPORT_SYMBOLS()s).
> 
> Patch 3 propagates timestamp options to subflows.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] sock: expose so_timestamp options for mptcp
    https://git.kernel.org/netdev/net-next/c/371087aa476a
  - [net-next,2/7] sock: expose so_timestamping options for mptcp
    https://git.kernel.org/netdev/net-next/c/ced122d90f52
  - [net-next,3/7] mptcp: sockopt: propagate timestamp request to subflows
    https://git.kernel.org/netdev/net-next/c/9061f24bf82e
  - [net-next,4/7] mptcp: setsockopt: handle SOL_SOCKET in one place only
    https://git.kernel.org/netdev/net-next/c/7a009a70ff8a
  - [net-next,5/7] tcp: export timestamp helpers for mptcp
    https://git.kernel.org/netdev/net-next/c/892bfd3ded0e
  - [net-next,6/7] mptcp: receive path cmsg support
    https://git.kernel.org/netdev/net-next/c/b7f653b297a4
  - [net-next,7/7] selftests: mptcp_connect: add SO_TIMESTAMPNS cmsg support
    https://git.kernel.org/netdev/net-next/c/5e6af0a729b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


