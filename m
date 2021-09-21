Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2704130AA
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 11:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhIUJVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 05:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhIUJVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 05:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E7FC861002;
        Tue, 21 Sep 2021 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632216007;
        bh=0a9/sBKXwcSvxZo/o+HOpnfFXtR7nz8zAJ+52Jf/ZIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lp3lavSkkoRgOXakfQWiTjlXELz3u2iAla8/42QN8C/VqyVzLChI8G0swg1RtF66O
         3Rim5hXhZdx+gKlWbdD+KegCT24Y9EEPvoZPRdvyAqqNTZNYVAoun/fI8m8sTYcfyK
         Z5CVkb6t0dY8rrA5vOB4+NPMt077mMRIlov2YOqRNIS08JIVzqV34I9/WoTWUuH2jX
         ymiXBjkDWsufImP+jQNbBSbfM8/75dtzRKRfVw/RqhZn3ital65Qas0p0fq2UdjVVA
         ZXsHgcLy6cAd4vIWGQWsUPaMqMB+VJmT9mFbrBCvyOmFj11uku0xTOir4UJIMgOWHH
         l7M4PVbVqi2CA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC08F60A5B;
        Tue, 21 Sep 2021 09:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/ipv4/udp_tunnel_core.c: remove superfluous header
 files from udp_tunnel_core.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163221600689.26608.11644575606463934734.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Sep 2021 09:20:06 +0000
References: <20210920122957.11264-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210920122957.11264-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 20 Sep 2021 20:29:57 +0800 you wrote:
> udp_tunnel_core.c hasn't use any macro or function declared in udp.h, types.h,
> and net_namespace.h. Thus, these files can be removed from udp_tunnel_core.c
> safely without affecting the compilation of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> 
> [...]

Here is the summary with links:
  - [-next] net/ipv4/udp_tunnel_core.c: remove superfluous header files from udp_tunnel_core.c
    https://git.kernel.org/netdev/net-next/c/bea714581a31

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


