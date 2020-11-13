Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAE72B28F8
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgKMXKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 18:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgKMXKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 18:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605309005;
        bh=BYzpMdRWsVpBWuO9JC1nb34UObtoZKc+FDs9BF/DrQk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gbZi0IDv0YhTVsp+I6jtu+JcAll+4wuB61UxnF3uaTiQqiZl2smF45sjqZclQzB7O
         EMy5IKX92oln4rJAw2I39vAyycEBmTc98SQS1owbtxdrxf8oqEeuA8EDCvXOwjh3kO
         LGUrMND5RAI7xVI8HBe1ePZIxRMmBbjPIJtRwsqk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V4] Exempt multicast addresses from five-second neighbor
 lifetime
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160530900536.28518.14914186365001805023.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 23:10:05 +0000
References: <20201113015815.31397-1-jdike@akamai.com>
In-Reply-To: <20201113015815.31397-1-jdike@akamai.com>
To:     Jeff Dike <jdike@akamai.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 12 Nov 2020 20:58:15 -0500 you wrote:
> Commit 58956317c8de ("neighbor: Improve garbage collection")
> guarantees neighbour table entries a five-second lifetime.  Processes
> which make heavy use of multicast can fill the neighour table with
> multicast addresses in five seconds.  At that point, neighbour entries
> can't be GC-ed because they aren't five seconds old yet, the kernel
> log starts to fill up with "neighbor table overflow!" messages, and
> sends start to fail.
> 
> [...]

Here is the summary with links:
  - [net,V4] Exempt multicast addresses from five-second neighbor lifetime
    https://git.kernel.org/netdev/net/c/8cf8821e15cd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


