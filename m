Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0B1410B5F
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhISMBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230393AbhISMBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:01:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 89ADB61242;
        Sun, 19 Sep 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632052806;
        bh=idhBYtsa+/HLclRp1EqonjDmiBufo6Xb4ip9Lg/NJPM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nugNTXe984kCnRC0RVMN8iT+3uZizXue3OO+tHCfWpfHTg7CcIs/CVRq3Dec9aiV/
         BsCSCHan8OD45WVJErng2UCAADqyZXwQhu8ElPPfKzgUOBRBLKWMUarhYZLdOIIUQY
         KAhBKnSv3W6hNS7RA6Uf++967G1HUvqR/ga7zFlu7yweRCQ4X3btflALaad+DjtPj5
         h2w681k/K5W8xd+qb75JWO+isrM7lA/gv1S2RkDJd8T3SnrAZMMTuZwqom5oq+k3f9
         G6ucOgko+3GPe0TshDhbKY9inbQOhJ3o1pLtfNDqLqSuf+8mrjppgJ7Z5WmzWcZNXO
         iZD5oF7+1yLag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 809CE60A37;
        Sun, 19 Sep 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: rtnetlink: convert rcu_assign_pointer to
 RCU_INIT_POINTER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205280652.31254.5182228878527831931.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:00:06 +0000
References: <20210918063607.23681-1-yajun.deng@linux.dev>
In-Reply-To: <20210918063607.23681-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 18 Sep 2021 14:36:07 +0800 you wrote:
> It no need barrier when assigning a NULL value to an RCU protected
> pointer. So use RCU_INIT_POINTER() instead for more fast.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/rtnetlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: rtnetlink: convert rcu_assign_pointer to RCU_INIT_POINTER
    https://git.kernel.org/netdev/net-next/c/4fc29989835a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


