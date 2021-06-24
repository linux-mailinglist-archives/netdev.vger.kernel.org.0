Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF543B3988
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhFXWwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232923AbhFXWwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 18:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2FC5C613CE;
        Thu, 24 Jun 2021 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624575004;
        bh=J2pAtlpBzXkWi7zpwUyT+kxnSXS5yF7XfJ2aCKxawns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mdsPCRCH6tk1qzylQ1BPExpAK5wz6u3WO4tUb67zd2sPnxTlABCWCrVNa99NXYsse
         mvp9/Vq+551kyFVxJO8Mken2ZjyX6Nv3ETjWJ9hoh18ncGrSz7wDUbB/Qip0B/28MW
         9Axz9iaDwXLfZ4OWHEA3w3oe2VC2w3hhzu/+X8uiZdLt0ildxfQLxs7xx+a6eK5bOm
         vUCAWcKnr+ZO1v5woZQcciikwmTXyJE1NG86Os5RJ6sy3nwbY/m78PEEwDK2G7BjxY
         S3g8cb04YjacaPuIiVKtxLokt2cwmuXyI2qPsfWTjtqgMPjtyx3VYThV1GiqqW1LRx
         IdjTIBp0Gum+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2859960A3C;
        Thu, 24 Jun 2021 22:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: delete useless dst check in ip6_dst_lookup_tail
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162457500416.3017.13482991292646181061.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 22:50:04 +0000
References: <20210624030914.15808-1-zhangkaiheb@126.com>
In-Reply-To: <20210624030914.15808-1-zhangkaiheb@126.com>
To:     zhang kai <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 11:09:14 +0800 you wrote:
> parameter dst always points to null.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/ipv6/ip6_output.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Here is the summary with links:
  - ipv6: delete useless dst check in ip6_dst_lookup_tail
    https://git.kernel.org/netdev/net-next/c/c305b9e6d553

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


