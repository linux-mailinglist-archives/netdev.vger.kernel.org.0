Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169E343993C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhJYOwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233693AbhJYOwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 10:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5421060F92;
        Mon, 25 Oct 2021 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635173407;
        bh=FdyrY7pVKpVjk3FXw2nS1yqeL3NM5VJTSdtkSXFOuPs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mt3IgobRoSipR+94uKBkRRzNG4Uyguh1HvKiDMpIM2fD2U0AdLSe9GPCwt7b6QW7l
         01sOJCEvsy/B7947mmRB0emy8+vHxGpwWwvAWvu0BseD0hZZIumHBWZFryesTvzSc0
         6RNCa7SyVHHpkmcahIYeSARA4wo0lvjh40JhZ4b+vAQ/AW78ttr2v+nQmc0yvraP7f
         9m9y5He7baCxZBYzohFaEffmjlUYENheWbh8foEaOS8GYNjuK94UUHrgREaYoO2SeW
         /P0EroruPS7XBSfLgdEDoJZNT66BdPalFUgb7z3VxMqBt+yacXIDXRKETLudsg8m3q
         96jjEkoaKz9uw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D00C60A21;
        Mon, 25 Oct 2021 14:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: nxp: lpc_eth.c: avoid hang when bringing interface down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163517340724.13749.9806279748005326952.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 14:50:07 +0000
References: <20211024175003.7879-1-twoerner@gmail.com>
In-Reply-To: <20211024175003.7879-1-twoerner@gmail.com>
To:     Trevor Woerner <twoerner@gmail.com>
Cc:     linux-kernel@vger.kernel.org, vz@mleia.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 13:50:02 -0400 you wrote:
> A hard hang is observed whenever the ethernet interface is brought
> down. If the PHY is stopped before the LPC core block is reset,
> the SoC will hang. Comparing lpc_eth_close() and lpc_eth_open() I
> re-arranged the ordering of the functions calls in lpc_eth_close() to
> reset the hardware before stopping the PHY.
> 
> Signed-off-by: Trevor Woerner <twoerner@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: nxp: lpc_eth.c: avoid hang when bringing interface down
    https://git.kernel.org/netdev/net/c/ace19b992436

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


