Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DEE3412B6
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhCSCUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhCSCUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5872364F40;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=yngMYrtmPhFYLcotApUlQz2LmB2V2A2z2z3Ux+b0J+E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QTqETnH5do6TEdSK2LVY1kXIptzvIkAASAe4PzC77292tirXO0kqOmEuZEn1hlI28
         JCUPAfJc2eVOxXfnLLCSUE1CFLLgtPZVnbbgNV1QP43dzrE+k7SClWz7cUiFMi1t33
         L0e+HLajfjC77E3rwpVoU0ehxORGghxAmZ5m9IzlDhUr763hgRxoCmlc43wQ5j7WRx
         NWlZqHwv2+slrWrlNeAh5wX/16WThxVDISQS3hK5Q5Gfg0BMWon7Xi4KD8bkZ0s0Jy
         Oexg8jd2vqwZHuBTc8Set/Us1HNKyy26ZCPC8xllJ7rMSP6A648ZcPliU4qdiP4H+s
         gaQ770aWoUC9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4DBBE609B6;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-af: Remove redundant initialization of
 pointer pfvf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041231.22955.10964432117461424545.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210318161428.18851-1-colin.king@canonical.com>
In-Reply-To: <20210318161428.18851-1-colin.king@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        kuba@kernel.org, naveenm@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 16:14:28 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer pfvf is being initialized with a value that is
> never read and it is being updated later with a new value.  The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 56bcef528bd8 ("octeontx2-af: Use npc_install_flow API for promisc and broadcast entries")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] octeontx2-af: Remove redundant initialization of pointer pfvf
    https://git.kernel.org/netdev/net-next/c/0f9651bb3ade

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


