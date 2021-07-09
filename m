Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0FB3C2907
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhGIScx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGIScs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 14:32:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0AE03613E3;
        Fri,  9 Jul 2021 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625855405;
        bh=v4PM+0nSNMWhukMSqmCBNvZhZJPRYMIrodairK1fw7c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S1WHQc8CIpURcOzfdsmNqNW7QLsuer46BAI8+XcyFbE0EvA+C4YzBLOaGscDf2mqq
         MTbWusyHQTxeY6q+Hr61Ljessnzzp05cBlCNsbv9AJ4XrIIkEN+lUv28f5myy/pSZf
         YHhfQByUqJhG8BUkxijF0QHp6b7lDQ5zh1RviNPYh8Z/r87U4o95ATHkqJiPQ5tJon
         e1gC8t4vfYp11YfGgFQmpzJtvmi3IZdmxGKtaMYlizzfTVKoKxPYyf3AG4nDSPe8GA
         Hb0hKjtwBylQcoxSKGKsLJsPWgotNJxG/Q4Br2CRJZA9zVm/rIM+eQrEDHIKuiLG1H
         +CAYKKe9s/m4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 030D5609B4;
        Fri,  9 Jul 2021 18:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: send SYNACK packet with accepted fwmark
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162585540500.20680.14625874648080198997.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 18:30:05 +0000
References: <20210709152823.2220-1-ovov@yandex-team.ru>
In-Reply-To: <20210709152823.2220-1-ovov@yandex-team.ru>
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        jhs@mojatatu.com, zeil@yandex-team.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 18:28:23 +0300 you wrote:
> commit e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")
> fixed IPv4 only.
> 
> This part is for the IPv6 side.
> 
> Fixes: e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: send SYNACK packet with accepted fwmark
    https://git.kernel.org/netdev/net/c/43b90bfad34b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


