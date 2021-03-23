Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705C8346B3B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhCWVk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 17:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233699AbhCWVkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 17:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 024EF619D3;
        Tue, 23 Mar 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616535609;
        bh=9n2e0jghC7l084yEgiBF+p9muFU3AC6wTYPZwpM1wlo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s/MHSN0KWFAipiEc2hRLoeV4ldnpZAtoJE2QXmFcmYwnRpbZ8Hpl8xDGB8dQBSZS6
         ibXoAsrLfM192HepcjGjQKP8SLoLkQLuibe7VtNx0m2qje7F9jPIqXrTInmlVmwWBx
         c4otGSs9lBNQo7MpqgnMvOJmYK44j8QItvBVxyukozp0w4WxLB5mK75mqZLIp5s2i+
         NxodHLGgX1Uc0GnHqRG/4fO+OKgnGW5quEQw1ZN82NV3JOXb6ZMhBFSdgZ1v/1zEsg
         LFi0HxoeMi3m/y0nyAkjD2pvp1HY88D90hxVO+t96b/KTpWp1x0fuRObjfV0OCUwrL
         BuSP7OWAE3oRA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F11D260A3E;
        Tue, 23 Mar 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lapb: Make "lapb_t1timer_running" able to
 detect an already running timer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161653560898.14856.3545507831167597854.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 21:40:08 +0000
References: <20210321093935.93438-1-xie.he.0141@gmail.com>
In-Reply-To: <20210321093935.93438-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 21 Mar 2021 02:39:35 -0700 you wrote:
> Problem:
> 
> The "lapb_t1timer_running" function in "lapb_timer.c" is used in only
> one place: in the "lapb_kick" function in "lapb_out.c". "lapb_kick" calls
> "lapb_t1timer_running" to check if the timer is already pending, and if
> it is not, schedule it to run.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: lapb: Make "lapb_t1timer_running" able to detect an already running timer
    https://git.kernel.org/netdev/net-next/c/65d2dbb30019

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


