Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719E93A1E98
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFIVME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhFIVL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7412A613F2;
        Wed,  9 Jun 2021 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623273004;
        bh=1sMtcFGBqiygNuQlJow5wPDwFt1q3xy044Hg4Df3oO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QxWi9Tceiu5MFg6CJccZoFJuiOA9YIComdbU35iT7ovj4sdsyWbsZGkKa/erqd/h/
         pDwJqOg41Qer+kTR8NgR0RO4zweksz69j8zltPBoVLtXSf0y9HPPVPMmKKmKbrLN3S
         zXAe+1N6Z9kNuJcuT2SFPC+vEz9TbB5zX7kwU49WzpRIKn9zzLPvAsZQzuL37B2aZ+
         /queDO58iQXvU/EIGMv/GAJf1i8nuFZUrpDn2F0hPk6JNBLrP/jZ0yt/0Px2a0+aSl
         udzcistsmfyWXoAXaAMNRn/tmIWDn+8wqbOQDVqxa6M7mzcG0nVIdwT6c596nrwmkk
         y8yVxXyyIm2LA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C12E609E3;
        Wed,  9 Jun 2021 21:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: hns3: use list_move_tail instead of
 list_del/list_add_tail in hclge_main.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327300443.16455.14671235606790351646.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:10:04 +0000
References: <20210609072056.1351940-1-libaokun1@huawei.com>
In-Reply-To: <20210609072056.1351940-1-libaokun1@huawei.com>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net, kuba@kernel.org,
        tanhuazhong@huawei.com, shenjian15@huawei.com,
        huangguangbin2@huawei.com, moyufeng@huawei.com,
        liaoguojia@huawei.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, yangjihong1@huawei.com, yukuai3@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 15:20:56 +0800 you wrote:
> Using list_move_tail() instead of list_del() + list_add_tail() in hclge_main.c.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
> V1->V2:
> 	CC mailist
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: hns3: use list_move_tail instead of list_del/list_add_tail in hclge_main.c
    https://git.kernel.org/netdev/net-next/c/4724acc47c94

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


