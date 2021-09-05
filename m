Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1A401118
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 20:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhIESBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 14:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhIESBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 14:01:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C3E060F12;
        Sun,  5 Sep 2021 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630864805;
        bh=KGRbfLpOeUoWtSBrJA9cOLrYGIImRuHj7Gfgos7XZwA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IxSKRxJwlmohaCrz228gJFgF4Ck1a4/pr6vMXcRGNmndweqfSW/jfenVOkGDvJCZO
         MzNgd16w7bPaJxrMZoiq9xgqyCV3Zj78D8VJe8LsCjVV7uwf6QNTYM3o963cJk4Rna
         FeinaWL/Go8ckr7RAMDG5MeIACdStAQCP1OtmwWMVEsCQwCWl0ZirRkephLVysheel
         ML3DrYIRwYbqKw41Uf/e0bj3H+HSefHNfDOQw9wzPDX7igERMb2hVIJyYh69yt1NHE
         lLzL6MxhBsRogH3weK08Ln0am4r0+FqZ65Exdy59T94MzFLLUTHdzKXJrpXQ6IQSZ9
         AK7wR197HaQEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7BBDE609D9;
        Sun,  5 Sep 2021 18:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ip_gre: validate csum_start only on pull
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163086480550.8097.6046777069094364476.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Sep 2021 18:00:05 +0000
References: <20210905152109.1805619-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210905152109.1805619-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@idosch.org, chouhan.shreyansh630@gmail.com,
        willemb@google.com, alexander.duyck@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  5 Sep 2021 11:21:09 -0400 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The GRE tunnel device can pull existing outer headers in ipge_xmit.
> This is a rare path, apparently unique to this device. The below
> commit ensured that pulling does not move skb->data beyond csum_start.
> 
> But it has a false positive if ip_summed is not CHECKSUM_PARTIAL and
> thus csum_start is irrelevant.
> 
> [...]

Here is the summary with links:
  - [net] ip_gre: validate csum_start only on pull
    https://git.kernel.org/netdev/net/c/8a0ed250f911

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


