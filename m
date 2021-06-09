Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBE63A1E9A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFIVMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhFIVL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 83017613F4;
        Wed,  9 Jun 2021 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623273004;
        bh=ZzqwOtmiG8JP3865O1oy2tLA2TrEMwVvUy3+P12OZr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G6docnKX+PwA/LyHOKcz8CY/HyYnzAVlrZbErDnN/r+MxpjJhSuTd15r9yh5ly+N6
         Dv4uTgLm6H/hWrNJk53U/5ISqjpLnCcYpzNep6Ce/p4tW9WBuHYJNiKTNBoMPFZbzH
         zH5CesE4taam9oQoies6vXoPj6UhVqm9tJdTamLzjOm0SUVlO3BDbio3s3way9igR4
         YOU1I1oiVt4ks2rSH3y+nNQS7HEhqKF0/hsutAlpAtrFC60IvrNf9mvRGS/M6OscEt
         NmDArUB1UmPGSLWp03vSRmw+1NPiNF82RSXOrpOcios5fZs6KT0j+yo+a6++BcVD6b
         9Mc4lhpCaY5Yg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7788A60BE2;
        Wed,  9 Jun 2021 21:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: hns3: use list_move_tail instead of
 list_del/list_add_tail in hclgevf_main.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327300448.16455.2233743264153091413.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:10:04 +0000
References: <20210609071720.1346684-1-libaokun1@huawei.com>
In-Reply-To: <20210609071720.1346684-1-libaokun1@huawei.com>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net, kuba@kernel.org,
        tanhuazhong@huawei.com, huangguangbin2@huawei.com,
        shenjian15@huawei.com, moyufeng@huawei.com, liaoguojia@huawei.com,
        zhangjiaran@huawei.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, yangjihong1@huawei.com, yukuai3@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 15:17:20 +0800 you wrote:
> Using list_move_tail() instead of list_del() + list_add_tail() in hclgevf_main.c.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
> V1->V2:
> 	CC mailist
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: hns3: use list_move_tail instead of list_del/list_add_tail in hclgevf_main.c
    https://git.kernel.org/netdev/net-next/c/49768ce98c2c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


