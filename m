Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A63462B99
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbhK3EXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:23:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33904 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhK3EXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:23:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1838B80DCF
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 04:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E0A3C53FD3;
        Tue, 30 Nov 2021 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638246011;
        bh=TuywCdrdnLmZ8WLxQZEQ+79PmVqrQ/S/bwdWNLfJhlU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HQ6N1L3rFBYVLAB/T2HdGs0VvX0oMGi/c4o4Ak1LDvYnjxNGBX54LnioLYJIlL4kL
         hzJzQavwEXHH1qLHABUwlYDg1ArDsn43xTri/jJ4sG5Lq33WAM6mjcxRmtjJPA6dam
         7kxgG9V4vAb973J/2Cf6eOWUO5nX1Nq2mnk+qw7ps7Pa2HxYYIEEjDsLfDvjVkd9s1
         ckwCCWUwX7p1M/Ah4ms5CYgBFge+spotSLUktEQ9p61B6mOMgpuDDsWQZXI42Nlkdk
         VZmPG6ya7GsxL4JsXTx47yOQz1t+tZimkFjCc6+k+CjYFhyNiewAdRSQxsayM3vfR0
         /fzfHvCRrWJuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D52E60A89;
        Tue, 30 Nov 2021 04:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v3] net: ifb: support ethtools stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163824601150.29763.11591646342973955126.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 04:20:11 +0000
References: <20211128014631.43627-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211128014631.43627-1-xiangxia.m.yue@gmail.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 28 Nov 2021 09:46:31 +0800 you wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> With this feature, we can use the ethtools to get tx/rx
> queues stats. This patch, introduce the ifb_update_q_stats
> helper to update the queues stats, and ifb_q_stats to simplify
> the codes.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: ifb: support ethtools stats
    https://git.kernel.org/netdev/net-next/c/a21ee5b2fcb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


