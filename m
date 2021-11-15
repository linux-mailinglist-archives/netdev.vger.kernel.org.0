Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0C94506FB
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbhKOOeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:34:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231594AbhKOOdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A686A610CA;
        Mon, 15 Nov 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986609;
        bh=Y1+rZvlcnCdUJQlJBL3yH9lBYZh+Y4z4ZRIuCh9ACKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cfj6glGrcflOeQLrJ2rdfPdb0VRYQsGSC8uQVWvXdaGTJFAZdS4rQAH+fgSIEZz+b
         F0rlL+chrib+fZsTHiOyXFgTNBhrTKmgPdxs9VPUFeM+ubxwG/Zhp1I3YoQQTkBRu3
         CuYu5WodLwzNTyRJZVkQzoxkGtvzAb5s6f9DXPnV9b1uvOjlsQvDdbZUQqo8vATqn3
         25K500W+mDFXoyqXUndDI3aU1OudgY0MzmyUtMcf4DOreMo27Y0nwLBR8XdjpBE2Sn
         RNNC7JBznuf+s9yvsIHmwgYV5qWXiFnIalrWuVozWZvs6zgS3MncBidluYQMoctYrd
         IpJC/6bNJpnEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 99E2560A49;
        Mon, 15 Nov 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: return correct error code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698660962.25242.15093947148534931226.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:30:09 +0000
References: <20211115081448.18564-1-liuguoqiang@uniontech.com>
In-Reply-To: <20211115081448.18564-1-liuguoqiang@uniontech.com>
To:     liuguoqiang <liuguoqiang@uniontech.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 16:14:48 +0800 you wrote:
> When kmemdup called failed and register_net_sysctl return NULL, should
> return ENOMEM instead of ENOBUFS
> 
> Signed-off-by: liuguoqiang <liuguoqiang@uniontech.com>
> ---
>  net/ipv4/devinet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: return correct error code
    https://git.kernel.org/netdev/net/c/6def480181f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


