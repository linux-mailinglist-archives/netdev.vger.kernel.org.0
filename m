Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE0F4464F3
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 15:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhKEOcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhKEOcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 10:32:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E65026125F;
        Fri,  5 Nov 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636122607;
        bh=i+FCshLLa0khIoCWn28uPj+QlUmJRcx7mINt1sfZ5r4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BJvEZkmQG4apA0jyLW8jg3aTKCPb67/Qp/PEKRSdg6bYhwB4AvkcVuWGdrdUJeqa1
         CeSbn0TnUm3j4WP2sq1sFd4p7QCC1gqjmYsTGRfR2Vgi+R5g2JCzAj+Z5zyU19B8zD
         ecNTaBlyvhbGb5or4h3CGSCTiwvQEyTC7UT0zx5ccSdrC3Mx2H9DNTjpE67VH7Ai+m
         LVgoqSRMxnelldupxkEAw8ZE9VrC+TmGJKPB9gkQkqYgH0JOdXjGY5836QksHcz7lY
         ULd5gmtK7CyFQCaQF+hepSzt+k+FoamrETt7nCyVZgPUW6JHJDu8uvQQjPDdgWcfnM
         YZHRN0t9CMfIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5A65609E6;
        Fri,  5 Nov 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] amt: remove duplicate include in amt.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163612260787.32748.7504323566984865749.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 14:30:07 +0000
References: <20211105012717.74249-1-zhang.mingyu@zte.com.cn>
In-Reply-To: <20211105012717.74249-1-zhang.mingyu@zte.com.cn>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhang.mingyu@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 01:27:17 +0000 you wrote:
> From: Zhang Mingyu <zhang.mingyu@zte.com.cn>
> 
> 'net/protocol.h' included in 'drivers/net/amt.c' is duplicated.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - amt: remove duplicate include in amt.c
    https://git.kernel.org/netdev/net/c/dce981c42151

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


