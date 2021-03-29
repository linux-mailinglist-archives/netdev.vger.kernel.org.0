Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E43534D94B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhC2UuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231158AbhC2UuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D57C61987;
        Mon, 29 Mar 2021 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051009;
        bh=CRvnZ4SBTVigQxkQ8MXJb8tNdKdsznOVhG0mp1xUJBA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TrjkOV25fz/bMPqfF9bVZz6oiZSMx8fOeucrKqZBDBy4w46VqnOUDdXgxBOyyG/D6
         kl/UdIhFPiOon4csHETMTcozoS3CwltP/NLDdrPEn9/mAuuRiOoLX6K/DqgRN3+Udd
         Fn2Bl9k0zbMh6N16F/lyiGbHj9da005UFpmvyTkc+FBnCH3XHY3HaVl08csJwfIGnE
         LyPOUjZRw7V/zaFpPgmlLDUiNCEM5LnBzMiu3VEepmS9TlCG+li+eOEJWo6LMraduh
         BU/3mkXDKbdq0noGDRPfAU53xws0GkB9Ini5DhcjNJ7cf+KPRGchTtdz+ndb8o6sS9
         lg2ex8d1P0+Tg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2D4AF60A48;
        Mon, 29 Mar 2021 20:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: myri10ge: Fix a use after free in myri10ge_sw_tso
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705100918.19110.5559989308020507704.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:50:09 +0000
References: <20210329123648.9474-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210329123648.9474-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 05:36:48 -0700 you wrote:
> In myri10ge_sw_tso, the skb_list_walk_safe macro will set
> (curr) = (segs) and (next) = (curr)->next. If status!=0 is true,
> the memory pointed by curr and segs will be free by dev_kfree_skb_any(curr).
> But later, the segs is used by segs = segs->next and causes a uaf.
> 
> As (next) = (curr)->next, my patch replaces seg->next to next.
> 
> [...]

Here is the summary with links:
  - ethernet: myri10ge: Fix a use after free in myri10ge_sw_tso
    https://git.kernel.org/netdev/net/c/63415767a244

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


