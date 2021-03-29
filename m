Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940D834C09D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 02:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhC2Ak1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 20:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhC2AkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 20:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D2FD261942;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616978409;
        bh=6LvZfYln2pejwIDJw8uOBscePlJXFGReer2WlRK47Zk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ETnl8s3VpizfqYaIH3q/u2ZDeCVflucweLdS/1S08DYftkDGWAaz2tYS6RFljeTDd
         73lPYb3W1R1Qf//H2ZtVC62sMuxbKeokMOgtjtt3TA96/KabNLSHqXgxB0xFPhwrUs
         +lxRR4frdj3Le9ApAVgu1SXDgnr9sK/vSRgfXUjy3myeFX1Ls5IMxSz/pEPs7AHiuI
         C/N1WWAK5otCIAb4fn+mpwbTciTuugD+D+W/pPHV+Vdiq5sZHwZz0tvG5BS5v4M3N5
         2F4qaHmSq19NlCdNacPLMLhkT7o8rtjUwStxu+B0W3Cd5xEN4EY+WUHXAkGdkesu0w
         GNLJUtxMwvfCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2EF260A56;
        Mon, 29 Mar 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mptcp: subflow.c: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697840979.22621.11271662230253438936.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 00:40:09 +0000
References: <20210326231608.24407-11-unixbhaskar@gmail.com>
In-Reply-To: <20210326231608.24407-11-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 04:42:46 +0530 you wrote:
> s/concerened/concerned/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  net/mptcp/subflow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - mptcp: subflow.c: Fix a typo
    https://git.kernel.org/netdev/net-next/c/55320b82d634

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


