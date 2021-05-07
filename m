Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D381375E38
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 03:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhEGBLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 21:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhEGBLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 21:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 60FEC60C41;
        Fri,  7 May 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620349809;
        bh=oVnOCHKCeMQs2R4TxB3C0GMOo+abNENpVP2gNeEJS74=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a2TF49I3+iz5Fh/h96sM4CpQ3CxZKkDXnMcFq1qESrIf1jEG/SuKvi3AnFXoXMtjO
         29KkKEn115jycUsmCAjY4fb4KvMjIwO79VhIIJ0hrrmKErUduhDoyfhNIf2SgEsIi7
         UjlDCVjH48RCJrXfY+dFAWx8vpfJPTk8jVLsHvWrMVkjNHARA0xStGa7N20R83mDA8
         G/p7urOjXPrz2ukh67tyWq+cBKOayU9Qa+sU3ML6XZYyunP9zxbgiBMbgKB4NWcp3c
         SFLpRpgKMQ4SNaK0vcjGAtHIb8i+pshU1SaFmujI/Jp8lHQQFcEnTLvreAtDaDxVeZ
         w6JG4vsD82GKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5601A60A0D;
        Fri,  7 May 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v3] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162034980934.23850.4657728582811464794.git-patchwork-notify@kernel.org>
Date:   Fri, 07 May 2021 01:10:09 +0000
References: <20210506223530.2266456-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20210506223530.2266456-1-arjunroy.kdev@gmail.com>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  6 May 2021 15:35:30 -0700 you wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> A prior change (1f466e1f15cf) introduces separate handling for
> ->msg_control depending on whether the pointer is a kernel or user
> pointer. However, while tcp receive zerocopy is using this field, it
> is not properly annotating that the buffer in this case is a user
> pointer. This can cause faults when the improper mechanism is used
> within put_cmsg().
> 
> [...]

Here is the summary with links:
  - [net,v3] tcp: Specify cmsgbuf is user pointer for receive zerocopy.
    https://git.kernel.org/netdev/net/c/a6f8ee58a8e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


