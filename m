Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505FE35E8F5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347273AbhDMWUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231238AbhDMWU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ED4EC613A9;
        Tue, 13 Apr 2021 22:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618352409;
        bh=K03txjgFdBwT2uLSI3StVcQEtOgXfxyjDlXbQW+1V1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=myrVZFBtilpBtn2UputZ49pKNAukQelEU+Bsoj9BYJ3te3G8w7VKLn3REn+bzXybx
         M722wRGmrIhTvYY+rmFlQtiltrLU2f+3xASGliaB7Qgn50fi8/8Zn2yW3ZRMaauwR8
         nndJbeld6spbZcoFDHbVvzeU8eHwWlFq2WrYGdMyAwjBnwRzp2gOI2OGHA3/qqX2Dc
         sobTn/f4r5cUGukMSrGwWXjrwyc4EeqWZb/yxUvyc+IiTXa3d+hGxXtqD22M2kmFt5
         W1JePE6bZWnBBkY9yVzgjYt/lyiWfcLG7VwI7gefkphfdoqFvQ5xX8mA7cACGhJZ4q
         fy4FJG6UpTlww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DBC1E60CCF;
        Tue, 13 Apr 2021 22:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gro: ensure frag0 meets IP header alignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835240889.4484.5968793394957880352.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:20:08 +0000
References: <20210413124136.2750358-1-eric.dumazet@gmail.com>
In-Reply-To: <20210413124136.2750358-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, linux@roeck-us.net,
        xuanzhuo@linux.alibaba.com, mst@redhat.com, jasowang@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Apr 2021 05:41:35 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
> Guenter Roeck reported one failure in his tests using sh architecture.
> 
> After much debugging, we have been able to spot silent unaligned accesses
> in inet_gro_receive()
> 
> [...]

Here is the summary with links:
  - [net] gro: ensure frag0 meets IP header alignment
    https://git.kernel.org/netdev/net/c/38ec4944b593

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


