Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C9A3E3424
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 10:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhHGIkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 04:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhHGIkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 04:40:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC05961042;
        Sat,  7 Aug 2021 08:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628325605;
        bh=KhYjj4G7racNurgeNVQblNF5X8sxYzIMiLUxvQ8IQ/M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HrKXruQ1YhmD5+cvC+YEvfNgo17Ee1T5WaQ5i7w6bjiyjvWYaCZWuXpC8wVPDgAAh
         lTihyUP71PO8t+KRdUaLC/sa1x9ltprG1quFIp0p5ROOC/nSZ5MJtWUP8kGSEJ5v+y
         JznIU4N/U4MTwhho6zFPtQCEMpit28AzQBgWDyeIcbUXPnwdY+kQS4ePa2muHQe5cP
         HRqiwCtyap+8mkrcVCncWjRyBA4MSewTPvo+PlD8nfBAgS5CIaml7GnuwTL0DIQuiN
         b0b2js/Yl1REdrfEOmm2PNEdmqljC8qDt02Yut4DfNoIPdnC8HjGPqCECOVo2qif6+
         hU97gA8g47S8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC80B60A9C;
        Sat,  7 Aug 2021 08:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] r8169: adjust the setting for RTL8106e
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162832560583.30769.1619629490600315704.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Aug 2021 08:40:05 +0000
References: <20210806091556.1297186-374-nic_swsd@realtek.com>
In-Reply-To: <20210806091556.1297186-374-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        koba.ko@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 6 Aug 2021 17:15:54 +0800 you wrote:
> These patches are uesed to avoid the delay of link-up interrupt, when
> enabling ASPM for RTL8106e. The patch #1 is used to enable ASPM if
> it is possible. And the patch #2 is used to modify the entrance latencies
> of L0 and L1.
> 
> Hayes Wang (2):
>   Revert "r8169: avoid link-up interrupt issue on RTL8106e if user
>     enables ASPM"
>   r8169: change the L0/L1 entrance latencies for RTL8106e
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"
    https://git.kernel.org/netdev/net/c/2115d3d48265
  - [net-next,2/2] r8169: change the L0/L1 entrance latencies for RTL8106e
    https://git.kernel.org/netdev/net/c/9c4018648814

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


