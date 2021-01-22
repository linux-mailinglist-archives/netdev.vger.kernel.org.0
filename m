Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450A22FFB74
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 05:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbhAVEAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 23:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbhAVEAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 23:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C2406221E5;
        Fri, 22 Jan 2021 04:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611288008;
        bh=nAgVyCChPnFhCqc2LfIoKo5qwOgpK45KUUDqhhgxs/M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eg2EZu9n7sB9UQSTsjHk6Sd0E7eejxcuUv6XTU9mrsV8YblMEVDJtUoYL4bAhyx+J
         yPAzCZOBJYI9i16w03PjRTr1P84W4nRrHiBqWNms4Kw36YtpY6NZf6qu7ZyX1AdtO9
         nBbKtc/G3tw/Oc8MZZbVQorwZPL20/lypeq1+47KKSoj75gQAXgRUZeGQorHPclGFJ
         sKCmR8j6i3mOT8fwWTs14EB7N3RjHkfDrrmyA0m+wf1Z9J4OJUtXk11gFntZVNk1kL
         nWRaJVIuR09zdo6ysolzTLjN/0K23TggG3g5dNnxzUx+B0GBLgnByLbXfiY6B77WSn
         GWB9zTsRIMiUg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B652460660;
        Fri, 22 Jan 2021 04:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: ignore tx_clk if MII is used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161128800874.10992.18301041286554115211.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jan 2021 04:00:08 +0000
References: <20210120194303.28268-1-michael@walle.cc>
In-Reply-To: <20210120194303.28268-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 20:43:03 +0100 you wrote:
> If the MII interface is used, the PHY is the clock master, thus don't
> set the clock rate. On Zynq-7000, this will prevent the following
> warning:
>   macb e000b000.ethernet eth0: unable to generate target frequency: 25000000 Hz
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> [...]

Here is the summary with links:
  - net: macb: ignore tx_clk if MII is used
    https://git.kernel.org/netdev/net-next/c/43e5763152e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


