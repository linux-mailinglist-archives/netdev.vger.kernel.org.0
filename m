Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD783B69CD
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbhF1UnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236688AbhF1UnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 560FF61CDE;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624912854;
        bh=3b1wAVjXuiUAqJ7ctwqRjCPaIwd/QO2Ur5Pr6Ir+m9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oCEFhBZ/HPbm59A9S06y96/Zcgpb9F1h4zid96/mwbRa0y1fvXi+BCVJkGrNrZ9/t
         cKDmOHJRsZo+f0HER8V2lTNGJ9AciMelJRJ/AH4KQZ732xPpWa0wK9U/tzX9hY+737
         h3Wpjd0QfYQBABSj6HUTe78gmaBAAZW0b+kHlj2vEQDTKFrkD6VzsAhUFVxundAFCP
         amghjZOjHvLkSvNISN3Tnjj0/QsgNWjt8EIE0h0szKmXqt1gPaZB5Nfuix0iAyBVUM
         pqizVAMx6tuYHgVcZ0I4CS9iUyKwXkKDXhGwV/bhqKoTCe64uxAJcafXWWKnU96QRk
         0RbkZCpiyJn9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4A54960A71;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 0/2] net: tipc: fix FB_MTU eat two pages and do
 some code cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491285429.18293.3948556814404654592.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:40:54 +0000
References: <20210628063745.3935-1-dong.menglong@zte.com.cn>
In-Reply-To: <20210628063745.3935-1-dong.menglong@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, lxin@redhat.com,
        hoang.h.le@dektech.com.au, dong.menglong@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 27 Jun 2021 23:37:43 -0700 you wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> In the first patch, FB_MTU is redefined to make sure data size will not
> exceed PAGE_SIZE. Besides, I removed the alignment for buf_size in
> tipc_buf_acquire, because skb_alloc_fclone will do the alignment job.
> 
> In the second patch, I removed align() in msg.c and replace it with
> ALIGN().
> 
> [...]

Here is the summary with links:
  - [v6,net-next,1/2] net: tipc: fix FB_MTU eat two pages
    https://git.kernel.org/netdev/net-next/c/0c6de0c943db
  - [v6,net-next,2/2] net: tipc: replace align() with ALIGN in msg.c
    https://git.kernel.org/netdev/net-next/c/d4cfb7fe5713

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


