Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA3C3247FB
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhBYAks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:40:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232139AbhBYAkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 56B0264F14;
        Thu, 25 Feb 2021 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614213607;
        bh=VL5do60VgknHejD4MstwyswG5x4hMe/Uh2VgjdJxHAA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c4sAB9i7h8laNFXNPJAbCPKo8xZqC0Zuu5YPSpwSAVk3KTGFuHwYseiCAlumehWv4
         uPKyCClaDYY8eWJA/uByacYgL2T2dEemrobVbHVxiV0JaDX9OQoa2NigG/FyZ5+Qb8
         EqNUe6atbAFteutqhun1yRz1sIgRl8yZuw+UngkLhQE6IYvNAcTTA/WtrpYQYyiJKO
         YWWOUWpFQf6Sw9gJgY6ZPkG8RjEJYHK4GSWIZJrXXvK8AB3f7IJKDtfM44NFC8lFoO
         w46HwMniOeIt8CQWifDxlns9u5njieubUCN5b8lVewEmef6jVBskVKgBtlc8iiAkHO
         g5YvJUyQ78Idg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 487A4609F5;
        Thu, 25 Feb 2021 00:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 1/1] ibmvnic: fix a race between open and reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161421360729.29181.499127452457145476.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Feb 2021 00:40:07 +0000
References: <20210224050229.1155468-1-sukadev@linux.ibm.com>
In-Reply-To: <20210224050229.1155468-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ljp@linux.ibm.com,
        ricklind@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 23 Feb 2021 21:02:29 -0800 you wrote:
> __ibmvnic_reset() currently reads the adapter->state before getting the
> rtnl and saves that state as the "target state" for the reset. If this
> read occurs when adapter is in PROBED state, the target state would be
> PROBED.
> 
> Just after the target state is saved, and before the actual reset process
> is started (i.e before rtnl is acquired) if we get an ibmvnic_open() call
> we would move the adapter to OPEN state.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/1] ibmvnic: fix a race between open and reset
    https://git.kernel.org/netdev/net/c/8f1c0fd2c84c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


