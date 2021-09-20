Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED694112C9
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 12:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbhITKVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 06:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235703AbhITKVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 06:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 33D4160F9B;
        Mon, 20 Sep 2021 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632133207;
        bh=WYLbjZ99bbLDVMoTu46T5EKDC2PuyHOC7Ihz+GrCQLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VgpHB090SBIiprLFDSc+k1fyaGAmqMuLEdMNCPWOQq+bu0KFdryc2m8ZdgFW3p/sY
         yD8HlDF4DkgsrSzM08l4dJ98pl1yYzXmJ/NfFSEMMYmk1u6ghN5lZ2ZmRVgcBtCIhv
         pQPhwwHmue6I8EKtKuHXXtbokOHBZxzXAxE2n8/ynWPHaJRHrypk9mqFzR8aT86wL6
         ErSysbBLISMqrx1LnGguDx4XY4hfiVKFFstknPoV32d2zoRdLoluxX4kLO4lGA3FTk
         a7o2Z5LnYQR5u521WuJJDdciAzO6Ljz37bqFV97OyTMuJ4EVek29QRZARuQNWfenjI
         GD2E10be67ewA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 21B5A60A3A;
        Mon, 20 Sep 2021 10:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: ocp: add COMMON_CLK dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163213320713.12173.7292329912675651576.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 10:20:07 +0000
References: <20210920095807.1237902-1-arnd@kernel.org>
In-Reply-To: <20210920095807.1237902-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     richardcochran@gmail.com, jonathan.lemon@gmail.com,
        kuba@kernel.org, arnd@arndb.de, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 20 Sep 2021 11:57:49 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Without CONFIG_COMMON_CLK, this fails to link:
> 
> arm-linux-gnueabi-ld: drivers/ptp/ptp_ocp.o: in function `ptp_ocp_register_i2c':
> ptp_ocp.c:(.text+0xcc0): undefined reference to `__clk_hw_register_fixed_rate'
> arm-linux-gnueabi-ld: ptp_ocp.c:(.text+0xcf4): undefined reference to `devm_clk_hw_register_clkdev'
> arm-linux-gnueabi-ld: drivers/ptp/ptp_ocp.o: in function `ptp_ocp_detach':
> ptp_ocp.c:(.text+0x1c24): undefined reference to `clk_hw_unregister_fixed_rate'
> 
> [...]

Here is the summary with links:
  - ptp: ocp: add COMMON_CLK dependency
    https://git.kernel.org/netdev/net/c/42a99a0be307

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


