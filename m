Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A1635A9A0
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 02:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhDJAka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 20:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235320AbhDJAkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 20:40:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1412B611F1;
        Sat, 10 Apr 2021 00:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618015210;
        bh=lMPzcAxI2x4/xaCot7Nvo24kZ3A94NmIzJuIafeOAKU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CzmHFd8EtfJrJ5XqFs/JjX6rWiO32J8/tEITD+AxRjMfmkfSc5cskSj+LCjEW62fI
         +ajH6jsh7wWZaGQ+gVqLjzZ/TCIn+6IF0vle7xWNGuju2RzAd+xFXBD7mTQXu46sdD
         rzAyPtysuDHgAkyA3uAyGpl/V7+TZQVYJF2v74b7o8uw+8sQxtBl9GLbB/MRPCDtKX
         8VvZjN4AxcgEvAwfwsqN2Rb5GRloRNq0hzg9N/Frw57grN3FBFEJAGtj1JI1HhBozn
         Km9jfeMmVgTpLQC81Vh9tSvV8VduTTcfFN3aut8yygP28prc/SBrxjIjJQyJ+CP9e+
         AyZ/NwCf22zgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0C90F60C09;
        Sat, 10 Apr 2021 00:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dccp: use net_generic storage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161801521004.30931.10984607891259608732.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Apr 2021 00:40:10 +0000
References: <20210408174502.1625-1-fw@strlen.de>
In-Reply-To: <20210408174502.1625-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  8 Apr 2021 19:45:02 +0200 you wrote:
> DCCP is virtually never used, so no need to use space in struct net for it.
> 
> Put the pernet ipv4/v6 socket in the dccp ipv4/ipv6 modules instead.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/net_namespace.h |  4 ----
>  include/net/netns/dccp.h    | 12 ------------
>  net/dccp/ipv4.c             | 24 ++++++++++++++++++++----
>  net/dccp/ipv6.c             | 24 ++++++++++++++++++++----
>  4 files changed, 40 insertions(+), 24 deletions(-)
>  delete mode 100644 include/net/netns/dccp.h

Here is the summary with links:
  - [net-next] net: dccp: use net_generic storage
    https://git.kernel.org/netdev/net-next/c/b98b33043c95

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


