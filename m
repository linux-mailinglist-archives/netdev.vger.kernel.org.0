Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A787346AF4C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378616AbhLGAno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351468AbhLGAnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:43:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F0DC061746;
        Mon,  6 Dec 2021 16:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D9FBBCE194D;
        Tue,  7 Dec 2021 00:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC7B3C341C8;
        Tue,  7 Dec 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638837609;
        bh=5Kibrj/iVf5MxB8dXMgqh50cWOAqN65/NhEfeJNjLic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hVmDJTyF5RML1GCzqrndnea8QXo5zzsjAPGax0OAX/oPf//I9I0HVrDiPdyKCCcBS
         dBYSAh5drEUdf0fOlXN4IX5itAEJlza+VeqEeDs+gToRmh8iFDaxox2qOzWlNaVq3H
         Q+m77o2pde53V4OU2klGNxDLCgxmK9krmm1kalKRhufRCdGVqqx/2sv8VeMT6K+BZW
         U6mqw1G7ESPt61aKBCPbDIdav/Li5R1/c+n5zcD4JHeM0SsyCrH01ws4wUvE2ZG/g8
         d51O6z2BQyf/6y6UeI5O83p/8BMSUAHT3GtgetsKbOAkVtyXOEhsoV4GeQvSVkIfL1
         dOsA7LQW44GJg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A4061609D8;
        Tue,  7 Dec 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: iosm: select CONFIG_RELAY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163883760966.11691.461957195890400420.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 00:40:09 +0000
References: <20211204174033.950528-1-arnd@kernel.org>
In-Reply-To: <20211204174033.950528-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        m.chetan.kumar@linux.intel.com, arnd@arndb.de,
        johannes@sipsolutions.net, stephan@gerhold.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  4 Dec 2021 18:40:25 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The iosm driver started using relayfs, but is missing the Kconfig
> logic to ensure it's built into the kernel:
> 
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_create_buf_file_handler':
> iosm_ipc_trace.c:(.text+0x16): undefined reference to `relay_file_operations'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_subbuf_start_handler':
> iosm_ipc_trace.c:(.text+0x31): undefined reference to `relay_buf_full'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_ctrl_file_write':
> iosm_ipc_trace.c:(.text+0xd5): undefined reference to `relay_flush'
> x86_64-linux-ld: drivers/net/wwan/iosm/iosm_ipc_trace.o: in function `ipc_trace_port_rx':
> 
> [...]

Here is the summary with links:
  - net: wwan: iosm: select CONFIG_RELAY
    https://git.kernel.org/netdev/net-next/c/5382911f5d67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


