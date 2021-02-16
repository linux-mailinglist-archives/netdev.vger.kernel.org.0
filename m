Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD6F31D2EA
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 00:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhBPXAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 18:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230448AbhBPXAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 18:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 941B164E7D;
        Tue, 16 Feb 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613516409;
        bh=hJmzisIQOvQ/f8mrgVlwLRvBrMnC6QdoIo56MzIz4Vw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RL1x204DD+pJhKHqAWrd5QQkCjQSb3D78vuavzgBMuHPCRuf1uesTQpRnTvy9If6A
         6GnoYu2aD/ubMduAVkEsCQ8XHIKn6dej98M/xqumuUUkmQZbhqj6wcl8Yc/xxmSxPJ
         fTdBDikcHvYF3yaumr2NwIyubX40Qmgzd7lMX1gUbojGhRtnXxXNm4EuPCoxq9bn84
         Hr3bbMXVpUsbc3a39oFqNVU9+N2gxgfIe0BhbSCPocBWN3ZVsPrQT2JFtrjf63dZWJ
         Cat73m4D96nTAa79zyPstZpCuCaOABzZC0GkRxim5ooMQ694lEXjPWk4sJzXWQz07t
         fZC/nxVRn9rIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 84DB460A17;
        Tue, 16 Feb 2021 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: xilinx_emaclite: remove arch limitation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351640954.9841.7347699745745992934.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 23:00:09 +0000
References: <20210216223346.4198-1-gary@garyguo.net>
In-Reply-To: <20210216223346.4198-1-gary@garyguo.net>
To:     Gary Guo <gary@garyguo.net>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, andre.przywara@arm.com,
        andrew@lunn.ch, masahiroy@kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 22:33:42 +0000 you wrote:
> The changes made in eccd540 is enough for xilinx_emaclite to run
> without problem on 64-bit systems. I have tested it on a Xilinx
> FPGA with RV64 softcore. The architecture limitation in Kconfig
> seems no longer necessary.
> 
> A small change is included to print address with %lx instead of
> casting to int and print with %x.
> 
> [...]

Here is the summary with links:
  - drivers: net: xilinx_emaclite: remove arch limitation
    https://git.kernel.org/netdev/net-next/c/18af77c50fed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


