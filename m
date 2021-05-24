Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E2538DE5D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 02:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhEXAbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 20:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhEXAbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 20:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55E9861261;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621816211;
        bh=E7tnaemu0GzBxIfKbRL9F0Yny0DeG2d4Q2JCnRY0nKg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BQu1wm62RiFoBBf4VJT0MY1fblIJ048zTESo+P/J0wc6bYuCG2E5Q3yqgtsYeD36Y
         1N5tihl5obTPkQFyn3W2qk1/zyUneyqI486ZMc8ZJeB2zu6wKwojrEA+kmmG20KM83
         ipMmE8f1a0peEAicfYKlExY8wyCwdFsz8PEYm9Dmd5G/cGjNkzwBr/8h5MqZ6Y20nI
         o0yV7VQf7tE/j+cwtumHx84o72whUbgn4GRpPotkYSP/T10nU3nYz8FZ6IJjrBq4BF
         YbyAwP0SKlur17BRCSzREOPVslNrjQhUiv+ZdAF30HYID6RC2pPYzv4XMUinbtEHYv
         6GpWG6ZbMjCZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4A32E60CE2;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: use DEVICE_ATTR_*() macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181621130.30453.15592805092018753382.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 00:30:11 +0000
References: <20210523032030.42052-1-yuehaibing@huawei.com>
In-Reply-To: <20210523032030.42052-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 23 May 2021 11:20:30 +0800 you wrote:
> Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/sfc/ef10.c       | 17 ++++++++---------
>  drivers/net/ethernet/sfc/efx.c        |  6 +++---
>  drivers/net/ethernet/sfc/efx_common.c | 12 +++++++-----
>  3 files changed, 18 insertions(+), 17 deletions(-)

Here is the summary with links:
  - [net-next] sfc: use DEVICE_ATTR_*() macro
    https://git.kernel.org/netdev/net-next/c/3880fc37beba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


