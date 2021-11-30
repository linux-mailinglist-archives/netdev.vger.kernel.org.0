Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FBF4634C8
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhK3Mxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:53:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43624 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhK3Mxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:53:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C836B8199D;
        Tue, 30 Nov 2021 12:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BA3AC53FC1;
        Tue, 30 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638276609;
        bh=wTnpliE16cUbCWHyHtW0dOXWX662bN4oGy1G+1KlN0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bVVYc6hlkdHBuvvlHdyZC/YnHOmhdUw083heW8EPGKOhOw18MeG/u1UX8p6bD5pmf
         Iie+yDyTtCRnd3w4OEelvQ5ME8LHFJUidlm7gmWDY36AiW1zWzpAaUeh0pkaFQ42tu
         yTChnzdMiNv0kADRoExrAmGxeHIcz9jkkw0YsA/IBBefENUa4yHIdKV8qcyNfZYxwC
         4DG/u+F8EEd6LAaGSMfRBqthSQGFnmEgYcRY3Ipr1bq7ZNjMTbYRTDZbyfvgGAqjsH
         3ueakcEjp9D7ps1+yETNOnfM47rDUCmQ6nyabtRoeww34hmKdG84uZLKvJaMFUfiZY
         lD3aJDVSyitLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 163B760A7E;
        Tue, 30 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ixp4xx_hss: drop kfree for memory allocated
 with devm_kzalloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827660908.10870.11448889104468467688.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:50:09 +0000
References: <20211130104840.1767981-1-weiyongjun1@huawei.com>
In-Reply-To: <20211130104840.1767981-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     linus.walleij@linaro.org, khalasa@piap.pl, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 10:48:40 +0000 you wrote:
> It's not necessary to free memory allocated with devm_kzalloc
> and using kfree leads to a double free.
> 
> Fixes: 35aefaad326b ("net: ixp4xx_hss: Convert to use DT probing")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc
    https://git.kernel.org/netdev/net-next/c/196073f9c44b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


