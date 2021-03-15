Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45D333C713
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhCOTuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232689AbhCOTuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE36D64E4D;
        Mon, 15 Mar 2021 19:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615837808;
        bh=sdwCcxCi7RSihchZk/FZK1ipami+WomWm5CcBAlvWNE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oxQRm0/iwuVtIHcKB9n2hnnMsmXWW/RmNtqirp10hBtq29DEP6E41TrzhI6QYRUM3
         hPVFLL4AIrFoM3M7BGqpTRQYxkKefEwHJP48934Z2MTtRw5eHpOmPssdWJHl97xyJ5
         bgoJxKJABB2GGK4cHRogrxKMSgKXdxEsbbuw9PoYP2MSnN9FNUFXzB9s/SgLGRFVY+
         I9e+EsBHV2Iyii6dYflIksEV+SQdY3+0rwvk+3daG3e4NJ+P12DMS8BZd09LkqOzUC
         xurq0eny+fwy9+2F4cAQXbdwchYOyI5Z3TEjP0ti0ujpEyw5rIa5TRA7qlIvSjPsmH
         63i7oEMRoXfrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DD2DB60A3D;
        Mon, 15 Mar 2021 19:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] atm: delete include/linux/atm_suni.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161583780790.26940.17504982478793684276.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 19:50:07 +0000
References: <YE4qksYA1qvYnsap@localhost.localdomain>
In-Reply-To: <YE4qksYA1qvYnsap@localhost.localdomain>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Mar 2021 18:24:02 +0300 you wrote:
> This file has been effectively empty since 2.3.99-pre3 !
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  drivers/atm/fore200e.c   |    1 -
>  drivers/atm/suni.c       |    1 -
>  include/linux/atm_suni.h |   12 ------------
>  3 files changed, 14 deletions(-)

Here is the summary with links:
  - [net-next] atm: delete include/linux/atm_suni.h
    https://git.kernel.org/netdev/net-next/c/9cb24ea05185

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


