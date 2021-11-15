Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E119F450581
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhKONdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:33:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231758AbhKONdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:33:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 18CAE63218;
        Mon, 15 Nov 2021 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636983009;
        bh=yOxrQIR+impa5GKvJp2ihhDyv3hgoTZwiBqA+EEZrpU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iGr67JfJe4LwJ/u44UlRSh+l0XCf3h+40CT603Dn9/8MRcq/09Z5sjeQ8QqgvTJRj
         D8jXoCVU/24ys8joHB+pvUgIYeq1Kx+No2U3ypKZrURue8w0gtDkik7RYrvYFrkE9P
         VaFhte+vI3GrNijM2dZBGCEj/s4p6Gxl18CqCW3i9QGkP21ElA4CiSo9ae4Rp2jTVT
         ae8dAPyhcu3ZLIj+oKPP5GErjomCOJZ6H9bgwq/2ByMlAGEMF0dyQEyRkSEzijhAxB
         kx1VLZAmDAFPigpIeZLSLiEkuO5lkZTc+ANMUq8CGsyhmGm2MCeN1On3ohbshTPxKB
         Q2JAEw92uzwKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E07D609E2;
        Mon, 15 Nov 2021 13:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bnx2x: fix variable dereferenced before check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698300905.26335.11739381869364470632.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:30:09 +0000
References: <20211113223636.11446-1-paskripkin@gmail.com>
In-Reply-To: <20211113223636.11446-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 14 Nov 2021 01:36:36 +0300 you wrote:
> Smatch says:
> 	bnx2x_init_ops.h:640 bnx2x_ilt_client_mem_op()
> 	warn: variable dereferenced before check 'ilt' (see line 638)
> 
> Move ilt_cli variable initialization _after_ ilt validation, because
> it's unsafe to deref the pointer before validation check.
> 
> [...]

Here is the summary with links:
  - net: bnx2x: fix variable dereferenced before check
    https://git.kernel.org/netdev/net/c/f8885ac89ce3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


