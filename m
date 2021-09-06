Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D876F401DC6
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 17:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbhIFPvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 11:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242495AbhIFPvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 11:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 664B260F6B;
        Mon,  6 Sep 2021 15:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630943405;
        bh=5n9chybKPJY8t7bf1CYJ72Luqezv9IVyzsMRJuo3T1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lm3MxCfkLLTa5MvgtQDAiV0+Refycc6JsSDOs+HwoTaVOn2/Np2ZcSCTBKPxHmFvb
         LshRNfDQSofiF6zpZ0UCNs+09Utu6xYzfaTcEYeZ2T6nhpV+s7kJI619qOa0yTqNwv
         PAVnouqkI3MAALZ9iUsfkTCknclKRej1/H+3jFp2aQhDwCyrYweGEGCxABGrmgp3rv
         8RXOUyqu+tnRWjrsVQhvE1v84WWM2bAiK0LQ3Ol1cDEBn6NQ5rM8OGEgqJlS+bxucy
         ZcK4LgjniQYOszFtfnSN2qdyLgOAVpnPWX77Y8PqWNeszzCvk/kWXsd4Z0YpQcxyi5
         zhZJtLLjuOchQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55EE2609AB;
        Mon,  6 Sep 2021 15:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ip6_gre: Revert "ip6_gre: add validation for csum_start"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163094340534.32353.15497161933776855080.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Sep 2021 15:50:05 +0000
References: <20210906142738.1948625-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210906142738.1948625-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@idosch.org, chouhan.shreyansh630@gmail.com,
        alexander.duyck@gmail.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  6 Sep 2021 10:27:38 -0400 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> This reverts commit 9cf448c200ba9935baa94e7a0964598ce947db9d.
> 
> This commit was added for equivalence with a similar fix to ip_gre.
> That fix proved to have a bug. Upon closer inspection, ip6_gre is not
> susceptible to the original bug.
> 
> [...]

Here is the summary with links:
  - [net] ip6_gre: Revert "ip6_gre: add validation for csum_start"
    https://git.kernel.org/netdev/net/c/fe63339ef36b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


