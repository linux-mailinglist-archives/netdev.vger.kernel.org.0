Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB834C09F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 02:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhC2Ak2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 20:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230452AbhC2AkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 20:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D757961951;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616978409;
        bh=wGJTkQknV3U7d9AuyX8P2PGGzMz9QTPMS+r7aUBVWtU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jsSoreIeT/zHcTQf2JFxkY0wnAo4zC9H6WAeSyj7XyEIC8mVvVN16BbJu2v9R3Cuj
         0Edf5kEvcOjhnjCZ1MrB/7pDC6SjKwvgMaqxNkEjvS9HoDYRrYCaX2KMeL+19e0/Bw
         iqLDFSUQDr2wFPbv21uzlS3lFnq4RwVbiN+FsZs8HI34tZ/c9buQnmno1uA5mbjKqP
         Y7h1qZZ5lZ+U9sqyC3i1QEw3UzpWvZlbX2yRvxGYuB3j70Zse7dZBnYPRg+sqisAxO
         Da2vsD1Uu94fts4Jm4b3zeAgxK1ulv5VR21gmKDiGXSIwUX3tfNh1WADOv38RUsGbN
         aXxy3uQcN/5Eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD17160A5A;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv4: ip_output.c: Couple of typo fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697840983.22621.13483959153593113435.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 00:40:09 +0000
References: <20210326231608.24407-3-unixbhaskar@gmail.com>
In-Reply-To: <20210326231608.24407-3-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 04:42:38 +0530 you wrote:
> s/readibility/readability/
> s/insufficent/insufficient/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  net/ipv4/ip_output.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> [...]

Here is the summary with links:
  - ipv4: ip_output.c: Couple of typo fixes
    https://git.kernel.org/netdev/net-next/c/a66e04ce0e01

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


