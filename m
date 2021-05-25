Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991DD390C95
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 01:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhEYXB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhEYXBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 433696140E;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983611;
        bh=t8mI7nd3/c+LUAn/kNBwCn2TZ1j6oqv0FLryb5/BiiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MtKaU5tn+1QF+sbd9NQJtQgdKesz/+HBYxUoJRppHXzGyQY2vQqIqDWcyHw+U/SXM
         FzRPKZ9OR+a8RgrleKbETUSV1OzF6qVfDT5U1Umkch6inmPta8uVbXQmAIXhCuQQrM
         nzyP0ATP0QvnRzqfuZCz8CV1K25rY0/8oGyjInegO0I/U0GKBHaFCe4loyY7SCfDxQ
         clwmxNj+Ic9vXiC6dhPA6smuuM088Ds5dT5zQR48E/T5qkUnX/1JTjlKDrwZ1TUIe2
         P46K/QKaYQAl098tq4uuMTm27z7w2ZIYA+HZ1+1gpLJ9tG5nz+Ehjp4zpSaG0zC3Wo
         lLendjCqtXZuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 32D5560A56;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: Fix missing error code in bnx2x_iov_init_one()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198361120.32227.5676133295102110757.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 23:00:11 +0000
References: <1621940412-73333-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1621940412-73333-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, davem@davemloft.ne,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 25 May 2021 19:00:12 +0800 you wrote:
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1227
> bnx2x_iov_init_one() warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - bnx2x: Fix missing error code in bnx2x_iov_init_one()
    https://git.kernel.org/netdev/net/c/65161c35554f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


