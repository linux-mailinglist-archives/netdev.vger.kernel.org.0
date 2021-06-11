Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B783A49B4
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhFKUCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhFKUCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D730613DE;
        Fri, 11 Jun 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623441607;
        bh=Cb3RkXkR/T6ArSUDKeC2NGt2QCXJojI/TLQAx4BIZZs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U1sYiDnl3+1jCpbpKuT04WW4VZ3nwuAXcIXGC2O490BrRd3aJim6q8wGBCKrhVTpZ
         CrZFIedHIh1mLx8raE+jG18I74JOKpngYNZyynm0aoyqVQADyN2M9PnmSld2hHHrDR
         oqAFDOkqTj5Uf9JX2XnEYjSmbZ0hvHWvLtc/LKaAncJiQx+Z02BAXLMqJxQr2zXZTK
         9Tvr2pzmHSLSvwuKHPsnS17W5InwAG0ysDAwgr2NWm+Zw7YuPO8Qnk4fqa5zYpO5TI
         cuTQnBoPmNYDZlp2JHQf2MFWlEIc4JCF5ziAjw9GwvEQuUSig9fpVxhbjx2fpRLYV6
         V+5RvxCJn4pmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0209460BE1;
        Fri, 11 Jun 2021 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: avoid link-up interrupt issue on RTL8106e if
 user enables ASPM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344160700.3583.4958732992345331673.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:00:07 +0000
References: <7060a8ba-720f-904f-a6c6-c873559d8dbe@gmail.com>
In-Reply-To: <7060a8ba-720f-904f-a6c6-c873559d8dbe@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        koba.ko@canonical.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 22:56:59 +0200 you wrote:
> It has been reported that on RTL8106e the link-up interrupt may be
> significantly delayed if the user enables ASPM L1. Per default ASPM
> is disabled. The change leaves L1 enabled on the PCIe link (thus still
> allowing to reach higher package power saving states), but the
> NIC won't actively trigger it.
> 
> Reported-by: Koba Ko <koba.ko@canonical.com>
> Tested-by: Koba Ko <koba.ko@canonical.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM
    https://git.kernel.org/netdev/net-next/c/1ee8856de82f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


