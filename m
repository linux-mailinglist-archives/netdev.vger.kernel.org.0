Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B71C3A07E7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbhFHXmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235534AbhFHXl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB9516135D;
        Tue,  8 Jun 2021 23:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195605;
        bh=asuigViU94Z+G8zC7OJBirg/0y+s7flxrq+e54fzWUc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f2UzZUc1pFkisyrZrxTLF7n7C2143ZI7PS/lbUxgjdQ7TTPqBf3QjfibeX55EDicU
         LvNOGadJFtE2Bs81VEzPAwLjIxA92IFdvg97z+opeJLUYBo8dGkWG6wUm1rKqx/zAm
         erQHy2QBeNeg8ABkJTNUHM0ywW/uFgtb9nGSGuPZocxn88AzSquOCuMmI/Qm2NIPeQ
         dubluOB0ofzAstXQ/2CYIqRIreAr+2KFi7r8if/OnBYguGqSw7lqSbS5HEwtJltYBs
         +hYBuhbpLkbsw9iqYuvaTG6WNyiQLg++1fsluJYqTXaNeGEGheKwRVP6KB0QAWu/Vm
         XnCczo90sLLlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D649D609D2;
        Tue,  8 Jun 2021 23:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: nixge: simplify code with devm platform
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560587.24693.1959913819853334374.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:05 +0000
References: <20210608135622.3009485-1-yangyingliang@huawei.com>
In-Reply-To: <20210608135622.3009485-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 21:56:22 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() and
> devm_platform_ioremap_resource_byname to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/ni/nixge.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] net: nixge: simplify code with devm platform functions
    https://git.kernel.org/netdev/net-next/c/5b38b97f40a7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


