Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CE035778F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhDGWUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhDGWUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 31B8361279;
        Wed,  7 Apr 2021 22:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617834030;
        bh=5PeSuQ/Ckp9G5rFbT2jvzp7TVqMTIY1v9RLsTQueWAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JtGED3iFhiQtUTBlgOAy2qKzRBwyWA5/0bgNchYcq6v5BeBYhpKmR+Fr1RipMR4Fi
         Emg28Q0IFruYje/Zh4XGSuPAFkF3wdJD4Or5Fy4lYM/+AfNq4U2/IzSAEXqG4pnu9+
         e0rjuXb6wP/P/lEoN91uWYZTHOmB+HZwpcoOA5cN5Vhse5keDRtx/Qq8KCvfsQicaY
         xVTOFDM7rQn28naKTgyiDWEeusL4nfQCwvwVFvll34OaTDtKqbkNAy6nN2FhdCE59K
         YvltxU3nbZIAV7r6QnPqLSazxsKLXGv2OanT22Ppk/aDnL+e7KY4DEqv8lEvIScnZx
         ISuRi89scKC7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2D0B660A71;
        Wed,  7 Apr 2021 22:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] enic: use module_pci_driver to simplify the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783403017.11274.1251510526858475586.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:20:30 +0000
References: <20210407150705.360840-1-weiyongjun1@huawei.com>
In-Reply-To: <20210407150705.360840-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     benve@cisco.com, _govind@gmx.com, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 7 Apr 2021 15:07:05 +0000 you wrote:
> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  .../net/ethernet/cisco/enic/enic_main.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Here is the summary with links:
  - [net-next] enic: use module_pci_driver to simplify the code
    https://git.kernel.org/netdev/net-next/c/1ffa6604431a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


