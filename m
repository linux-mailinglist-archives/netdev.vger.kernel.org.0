Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6653A07EB
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhFHXmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhFHXl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E679A61352;
        Tue,  8 Jun 2021 23:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195605;
        bh=7smAwj36Y0do9tPeG4lDnw5wjf9WaWS6wNo+jMx9fAk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W9V82pPbs9BA1Iy+PCM9pT3hvKTvpxJxl7nbsLM/bQ20su1N3E6Ihr3Dz1MH1uncU
         foJGJph/uLvPqbp+gMR1oifyyUvSx9PTrIy0Rx7u5yoNGXnmecixlfncK3i+jaB/Yh
         k8mn66u75RE15po94zrha8aVGm4m4t1MLkFqFvBapSZVVGUHyYeO0SIkqDOG/F1nfS
         3emxvnhH172bRCmpNAVfNzlxWk/GenGTEFQ9LFXCUKtm4yMdxK/sG9+kqhU1isu7Ne
         /5Td7wsf5h7P+F5vZjfW2U2CaUcTHMjJwuiMb11OR9y3JwfG+IjZk4qTgcDc17CGG6
         5PVxkME+oIKqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E07CC60CD1;
        Tue,  8 Jun 2021 23:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethernet/qlogic: Use list_for_each_entry() to
 simplify code in qlcnic_hw.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560591.24693.16780473741484256213.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:05 +0000
References: <20210608132908.68891-1-wanghai38@huawei.com>
In-Reply-To: <20210608132908.68891-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 13:29:08 +0000 you wrote:
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] ethernet/qlogic: Use list_for_each_entry() to simplify code in qlcnic_hw.c
    https://git.kernel.org/netdev/net-next/c/78595dfcb29b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


