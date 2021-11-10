Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1F44C357
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhKJOw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhKJOw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:52:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0320361251;
        Wed, 10 Nov 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555809;
        bh=jgVWxpLPKIYJmJ3vPvUZkulg2RcCkkKEC3mS40Omupk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nlMUXsQuu9MJ66l/lB9HrDr+ZUUo/0a093cM1Xylx+7j4UG3p2hGvCeqt9epNVIYf
         AtqbeHzHBLCunaI7trATKfyChfFfSJijduvKuAa3BcdGqOoxyYGoWILtYsqjEUSNVK
         ej3zLInnEJqLNihGpjWNYBRLIsjI60iLHVgkuh33FJmXDm1T0wSVToPCoox8btZI58
         7sV6Vd/6bDolplluaD6Lxpc68hRhXmgCpIqxoewUA0d8v/tVGJkRwQu0UVO2cMl3Yf
         tz9GVmIioff+1RI7ZlC0VnZnSvrWs/tSuPh8e+khNVB4QHJs14krxQ0ORxqh7+9tAk
         wxMqaQJDJ0byA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE77560A5A;
        Wed, 10 Nov 2021 14:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: lantiq_etop: Fix compilation error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655580897.25401.11694416464813339336.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:50:08 +0000
References: <20211109222354.3688-1-olek2@wp.pl>
In-Reply-To: <20211109222354.3688-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de, jgg@ziepe.ca,
        rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 Nov 2021 23:23:54 +0100 you wrote:
> This fixes the error detected when compiling the driver.
> 
> Fixes: 14d4e308e0aa ("net: lantiq: configure the burst length in ethernet drivers")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/net/ethernet/lantiq_etop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: ethernet: lantiq_etop: Fix compilation error
    https://git.kernel.org/netdev/net/c/68eabc348148

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


