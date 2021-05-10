Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C863379970
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhEJVvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232257AbhEJVvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 379AD615FF;
        Mon, 10 May 2021 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620683410;
        bh=S/hN9gF0YjudILB4lVvuiu8qaAdvvp8cnod2RlyXY5M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S3tE6gMLMQ+C8FbrMyJ/XyuNmhuYFwPs5em0tuQwm2yeJCfBm5oGNPI6L4uI81vKj
         fr62QIS2WzEgnTnMEOVd2p/aCeU1khRLht8EsINifPvGN5c+R/J0GTSUDzmmwzC4SY
         MblzXXivoRApRhFa9jVYX2bJMZj17Lr7Nw9ADiJdcHgBiD9oSLnefKq29pBKz1Jh76
         jLLlq/1hl/Vlj3uW920jr8FzM0X2tJlNbcpptITVWp23ZP5/aUmQL5bVuvc4tCgnXq
         r1c09V2MeDvgyGgXKR1jyoIql5hUlkLb6jYC9BWCgv3/Ik3mQygII5tarwPgM4I/Qx
         xye8EiG9SGhVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E823609B6;
        Mon, 10 May 2021 21:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] tipc: make node link identity publish thread safe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068341018.4733.1458349566915651364.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:50:10 +0000
References: <20210510025738.4713-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210510025738.4713-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 10 May 2021 09:57:38 +0700 you wrote:
> The using of the node address and node link identity are not thread safe,
> meaning that two publications may be published the same values, as result
> one of them will get failure because of already existing in the name table.
> To avoid this we have to use the node address and node link identity values
> from inside the node item's write lock protection.
> 
> Fixes: 50a3499ab853 ("tipc: simplify signature of tipc_namtbl_publish()")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> 
> [...]

Here is the summary with links:
  - [net] tipc: make node link identity publish thread safe
    https://git.kernel.org/netdev/net/c/3058e01d31bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


