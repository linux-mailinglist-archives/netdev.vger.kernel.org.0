Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEFC3A1E9C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFIVMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhFIVL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8EB16613FE;
        Wed,  9 Jun 2021 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623273004;
        bh=HBrIVUrc5eHVxZm3CI+lIUKx8ut5RKIK3G8zI3fCkoM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mzif5mjnNy5dvGkhw4RidoQYYt0bi1xL6JqOb1cR5ToYq0mgQxbClbQRLVjzn7LP3
         NJLtz1S737bfLDmy2OoXN7UBVzvkezk3bY8PMhBi4FBbbsrm+yNYiJGD2TwcdSWCQv
         HMtpAzMn9ZZUunwYbVbcB7AZgnZfjixyU+BZEDQM7OlAWAzE3aj8Dk3JbbHOVioFaj
         yWtYp8iP8GF3kEQt3b0TPV0uqFkgCFYFWy1bgGJ5MX82FaROoC+aydzCGWJednHVXA
         UC5id/GmpbV6zi2od6effnQziJ0vWZHLOm4aJ/pJmGosN5nPertBUS4fXd/DNZzxFX
         N8xf+PNpwZ+FQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 837E860A0C;
        Wed,  9 Jun 2021 21:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] nfp: use list_move instead of list_del/list_add
 in nfp_cppcore.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327300453.16455.10765731568023013877.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:10:04 +0000
References: <20210609070921.1330407-1-libaokun1@huawei.com>
In-Reply-To: <20210609070921.1330407-1-libaokun1@huawei.com>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, simon.horman@corigine.com,
        davem@davemloft.net, kuba@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, yangjihong1@huawei.com, yukuai3@huawei.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 15:09:21 +0800 you wrote:
> Using list_move() instead of list_del() + list_add() in nfp_cppcore.c.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
> V1->V2:
> 	CC mailist
> 
> [...]

Here is the summary with links:
  - [net-next,v2] nfp: use list_move instead of list_del/list_add in nfp_cppcore.c
    https://git.kernel.org/netdev/net-next/c/39c3783ec062

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


