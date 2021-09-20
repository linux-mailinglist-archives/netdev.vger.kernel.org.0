Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A441143C
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbhITMVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237741AbhITMVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 730B66109E;
        Mon, 20 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632140407;
        bh=/9Ys0WipdohzajzCBX6QMT2XxKHtdjKOKRlCaqPs2Us=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mqVeFzTD7jOwUtQHVFD8tJbjteU1Z9MeYbkox0TxedV+z2NuaERgDpYVuQARf7G4O
         AUHSwmCQk3KAB14479iLu/TK6xaYjAOZPl8fY1qSeqICD0Jm0G1n18WbkX7SRfLulJ
         zPAnE6EUaO0lKRUd7M/RdBWH9mlpWyyPo11o98RJzPa2rSFxe6NrleJ9Q8NMdEOfTq
         67H1aowGPgjDPwnVj6MeL2m0XqwKWgWk3CV7dS1UT4gdO7VgyP/znfcVBJbi1I74v9
         /YU4ng35y0yHCnl0aQhCwVSqUJ73j79Ms+KwnCkSS8CXhwXUmvbfCh6WhkRpfK9MD4
         Zfqc6UNjjj/Sw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5DA6D60A3A;
        Mon, 20 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/ipv4/tcp_fastopen.c: remove superfluous header
 files from tcp_fastopen.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163214040737.3439.14491914886555041180.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 12:20:07 +0000
References: <20210920113416.26545-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210920113416.26545-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 20 Sep 2021 19:34:16 +0800 you wrote:
> tcp_fastopen.c hasn't use any macro or function declared in crypto.h, err.h,
> init.h, list.h, rculist.h and inetpeer.h. Thus, these files can be removed
> from tcp_fastopen.c safely without affecting the compilation of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> 
> [...]

Here is the summary with links:
  - [-next] net/ipv4/tcp_fastopen.c: remove superfluous header files from tcp_fastopen.c
    https://git.kernel.org/netdev/net-next/c/222a31408ab0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


