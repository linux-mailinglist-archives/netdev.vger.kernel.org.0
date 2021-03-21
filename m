Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0AC3430A4
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 03:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhCUCVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 22:21:23 -0400
Received: from [198.145.29.99] ([198.145.29.99]:51974 "EHLO mail.kernel.org"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S230046AbhCUCVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Mar 2021 22:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 475256194D;
        Sun, 21 Mar 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616293208;
        bh=xr8nnTcrHlu3teI/MnHvgWMsArUUVI5FCbSP+8RIdWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KAjg7fpMw6FtQQr/tsScP7oB9X+elcAmvSL0KUwJKOqhusfdgnljlamPrDy73yi2Z
         W7v6L8OpktGmTwnpvhJU/jldMVuECmYpl2nDOGiatecuVKZA3q7H0XFZXnO/wAbMD4
         TOM1A8z0jfMMprEIBnSIjcBJL78idOVwHVcwMU1rK8Me5m/2h4te2kDLyrkjcrxc57
         hIpdeClJXaqJaADb+ehghs7ecYhOylCpD+innwsW2gcTTv1Efx+KglPqf65uRw7mKt
         Kf14pCSlGHm6bkh2SZitEfa0KzKaJQ5EClnpzuIBPPjYcsqJupVhnIM/P7RbCQP2dn
         +PflhGzx680Tg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3BA89626EC;
        Sun, 21 Mar 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: add support for ethtool get_ringparam
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161629320823.8612.6368412878476970727.git-patchwork-notify@kernel.org>
Date:   Sun, 21 Mar 2021 02:20:08 +0000
References: <f9734a16-ebca-8cab-a5f8-fa5642a1c8ee@gmail.com>
In-Reply-To: <f9734a16-ebca-8cab-a5f8-fa5642a1c8ee@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 20 Mar 2021 23:14:28 +0100 you wrote:
> Add support for the ethtool get_ringparam operation.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Here is the summary with links:
  - [net-next] r8169: add support for ethtool get_ringparam
    https://git.kernel.org/netdev/net-next/c/dc4aa50b13f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


