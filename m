Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8283FFEC1
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349237AbhICLLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348681AbhICLLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 07:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CC027610F9;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630667406;
        bh=R3mYbmYwvutHKCWiTEYlWeRVp6G9alwpselZIco4tMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xwsn4Saptv0xFLhnO/Kli9qOIByxYPWPd2reQsxzxAbzudePfNqDjxEd7WMqXpKBt
         aLmx1UzP6Ztl1ahguD5kA1qIZPeId6To8IGJxiVSIOVkSvU/1EjguXIAgRT2VqsX0N
         cbvp2LNFZwMUzAta92nDGIMjZ8PwSpQlny0gMyS7rzAD7NTQJ4ga/sa7Fn10QAA9cz
         SkhGeCEj6OirNZI4v9ZfU8BOd2v5X5rQjYmSVMDqHHwtXhpVsG1r5CTGAPcjBdzD6u
         KBEXsJk8/pjRpOiBgcf0hULwaHr6g5IavKxLL9wQEP+nomjIAd42dGLjoxJ1UmHH/I
         G/l9Xym34p77A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C62F460A2F;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] pktgen: remove unused variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163066740680.18620.7723586307989303650.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 11:10:06 +0000
References: <20210902171709.1965320-1-eric.dumazet@gmail.com>
In-Reply-To: <20210902171709.1965320-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, stephen@networkplumber.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 10:17:09 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> pktgen_thread_worker() no longer needs wait variable, delete it.
> 
> Fixes: ef87979c273a ("pktgen: better scheduler friendliness")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> 
> [...]

Here is the summary with links:
  - [net] pktgen: remove unused variable
    https://git.kernel.org/netdev/net/c/20e7b9f82b6e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


