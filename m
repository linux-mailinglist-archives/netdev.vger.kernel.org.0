Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796E234863A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhCYBKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhCYBKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 600FA61A14;
        Thu, 25 Mar 2021 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634608;
        bh=+n1RB8wAeIzn113N2MCArRuNFLeQ8HAgavokcEVrZ5c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KFyJGhYhfSJzJwKGEK/OBgfnMqEUKvCYxyICreMGkwv9zGU0s9pc/E0OmoeAhw547
         QyffRfkuDEkigyiAkfBr0hvExXWKMdzJhGgF64EIB1APSyDj6tMh+/owvJCUy/mSBm
         bwa+BhYfuEgl05WjeF5zwPGoCxZ+4FE5LcHo6jvrYs/McBirDP//Tyomy8uoBUoYjv
         h7L3EFlin1ZUB2nmgchbkv2WEs4VyEVMB6KrjI0yjMEUv2Qt90nLwjMQmQQ5308XBJ
         WFixEOnoUVbxpXqyyTxRtImCXKr+zG6HAULPiAZnWKqZaJgcKtMPIcC3yzFErU5VqW
         fduBk0ZZyD3eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 509F66096E;
        Thu, 25 Mar 2021 01:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] hinic: avoid gcc -Wrestrict warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663460832.25289.5484476322844888981.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 01:10:08 +0000
References: <20210324130731.1513798-1-arnd@kernel.org>
In-Reply-To: <20210324130731.1513798-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     luobin9@huawei.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, linux@rasmusvillemoes.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 14:07:22 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> With extra warnings enabled, gcc complains that snprintf should not
> take the same buffer as source and destination:
> 
> drivers/net/ethernet/huawei/hinic/hinic_ethtool.c: In function 'hinic_set_settings_to_hw':
> drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:480:9: error: 'snprintf' argument 4 overlaps destination object 'set_link_str' [-Werror=restrict]
>   480 |   err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   481 |           "%sspeed %d ", set_link_str, speed);
>       |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/huawei/hinic/hinic_ethtool.c:464:7: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
>   464 |  char set_link_str[SET_LINK_STR_MAX_LEN] = {0};
> 
> [...]

Here is the summary with links:
  - [v2] hinic: avoid gcc -Wrestrict warning
    https://git.kernel.org/netdev/net-next/c/84c7f6c33f42

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


