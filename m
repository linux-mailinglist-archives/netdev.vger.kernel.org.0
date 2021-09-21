Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A66413150
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhIUKL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231582AbhIUKLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 06:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F36861211;
        Tue, 21 Sep 2021 10:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632219009;
        bh=/BgXw0KCObeSD5sbMtCxH+FGLUzYf/qLCOTZiZ59IPk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kyz2PyI/M9iUSiTJUabUAnNL52P4WZ9Y3Kra+vTItDz2VUeA0IX/fxqW0OqDfyy9f
         V9g9BFGaktLzwU7DMjOewUOAQXk33XKGgy3f+t1otvvE5NNbDorPtjALPxNHDPqVe0
         GGr/QKRh3gOb/nqHzqSgbPuq8JH/S6QH5HIiORLGctNwcya7rdHqH8VIoYYZqNcga+
         wXsGoS6KulHqzU9KP1WrO8dkME4h256bpzoXM3y8sN4UXKw07PUYcSjwF8RUAQMEIR
         TJ/e7Od4l8Y1ioqmh/S/YA+OG03o5N+oXm3d3Hxw7EsNAQ5Thqhjgz9QCjj5wD+imn
         DPFsMqn7bSJPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1515960A6B;
        Tue, 21 Sep 2021 10:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/ipv4/syncookies.c: remove superfluous header files
 from syncookies.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163221900908.14288.338705490079379500.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Sep 2021 10:10:09 +0000
References: <20210920141549.29643-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210920141549.29643-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 20 Sep 2021 22:15:49 +0800 you wrote:
> syncookies.c hasn't use any macro or function declared in slab.h and random.h,
> Thus, these files can be removed from syncookies.c safely without
> affecting the compilation of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> 
> [...]

Here is the summary with links:
  - [-next] net/ipv4/syncookies.c: remove superfluous header files from syncookies.c
    https://git.kernel.org/netdev/net-next/c/c595b120ebab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


