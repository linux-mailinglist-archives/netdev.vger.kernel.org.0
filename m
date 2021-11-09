Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC6244AF32
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhKIOMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234190AbhKIOMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:12:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 570EA610D2;
        Tue,  9 Nov 2021 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636467007;
        bh=pqfLwAAw8XqCpDqYXY0fdvrQp3gTrjPEuktAzYgurm8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tSzjWjgx03sgrj3WWkfA7QvaWaPjt4y1kTsJr1Xt/qZKtDmIQOBhUMzkIWjpN3drt
         XOdvw0fU7RLgUZ1868J+DNBm8se2fBCFcHLCnGpJudJ4sHge+bygIiM45+OhI0bYG3
         +mO16spgJe2cQh/HMaPat+F15eRCJlK5dVOzgPh/AOLL6DvXVvPqtnaiwgvozQj+rJ
         mevJ9rUuXWEaDxoeOFY3R3AKK0P7iH+TDAsiMQuAJiKW9tGLM5pF4sANiFxVi9rYvQ
         5EOgknQ+AV+JNesriQ2uPr78tIS12YMccvMDm0OUw23MOyTTe/xpSugJEQxjRWmFxL
         1pd5DCobSEjvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 486EA60A6B;
        Tue,  9 Nov 2021 14:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: Fix off by one in gve_tx_timeout()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163646700729.20937.7950629021188609855.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Nov 2021 14:10:07 +0000
References: <20211109114736.GA16587@kili>
In-Reply-To: <20211109114736.GA16587@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jeroendb@google.com, jfraker@google.com, csully@google.com,
        awogbemila@google.com, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, bcf@google.com, edumazet@google.com,
        yangchun@google.com, xliutaox@google.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 9 Nov 2021 14:47:36 +0300 you wrote:
> The priv->ntfy_blocks[] has "priv->num_ntfy_blks" elements so this >
> needs to be >= to prevent an off by one bug.  The priv->ntfy_blocks[]
> array is allocated in gve_alloc_notify_blocks().
> 
> Fixes: 87a7f321bb6a ("gve: Recover from queue stall due to missed IRQ")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] gve: Fix off by one in gve_tx_timeout()
    https://git.kernel.org/netdev/net/c/1c360cc1cc88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


