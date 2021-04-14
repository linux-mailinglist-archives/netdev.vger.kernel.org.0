Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22E935FC60
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237657AbhDNULA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234058AbhDNUKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CC9E861242;
        Wed, 14 Apr 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431010;
        bh=iFoK/rYxt6qoZO9atR1NxuLWRDDHw9Bkq7mbQEEtPk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WFlikQe76XIROf4Q8gf2Fid0viI4UpacUrJp2O0j1ZPDYh7yuLUwlOA/DP0WwsEY/
         yevsYNiTMPZg1ReANhb8eoPQa6p18v8FwnpSD/YwN8UXBy3pLXr2sz42jUknXJtEFA
         hnshhqYoBkZLcz71MYOJUiGOreG9sYw59pCoPBWQNS1JHppbyRaTj/Q1K6TA8KOtIB
         OpyCTyDMjhTCrLO/qrW2apOJ7qB1ec8VXYBfm70jTZuyW8s3rbVDXMaX9XdhYQxeCc
         ued09RVUjWlnLmAGGzgQJEXeRu/e+E4rYhn26Dwf+hHjukV3dxkoobXn85xa/LBD3p
         mPrA6ui9Sn1/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C669E60CD2;
        Wed, 14 Apr 2021 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: add support for pause ethtool ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843101080.9720.9948138611064248223.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:10:10 +0000
References: <0e0f42d5-d67e-52bb-20d2-d35c0866338a@gmail.com>
In-Reply-To: <0e0f42d5-d67e-52bb-20d2-d35c0866338a@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 08:23:15 +0200 you wrote:
> This adds support for the [g|s]et_pauseparam ethtool ops. It considers
> that the chip doesn't support pause frame use in jumbo mode.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 28 +++++++++++++++++++++++
>  1 file changed, 28 insertions(+)

Here is the summary with links:
  - [net-next] r8169: add support for pause ethtool ops
    https://git.kernel.org/netdev/net-next/c/216f78ea8cf6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


