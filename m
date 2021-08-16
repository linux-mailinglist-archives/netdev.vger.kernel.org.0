Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CE83ED1FD
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhHPKb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235793AbhHPKai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:30:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A30561BE2;
        Mon, 16 Aug 2021 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109807;
        bh=nGqUBwNHRlc3BAm8rDWG/+qutmQnMHqkH8r2AJbn2Gw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I73CGtHkE/C3vxKLahjepUzVzYObrBP+OxiAu9JAOD8cQHu0agGBHXNhMVzC/Bt8u
         GP9bultmQqDDOqPwJAR2NHRolSqPf3mv7RhDzld34MsEdNKZl472y8elmPUcFUUy7+
         Qb71xMHf7qE49N+MPcAXzZUE8YJmofitqgw366smLLfR5aHjqcI80BOo3bPLf3ovS/
         7VnL+mVsv/oWaBWeNAeUlsEqPNJ1JcsPi0e2ANhJ2S9lP9BNehCnCwMNh6Z5lQ83cK
         PAGQRRc+7UrOF0yRjooUVl/wqVscM9y6rJuTslnvznBu1by6LfAvbShEiQVRWp/tHg
         qgskThi7ykfBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 14CFE600AB;
        Mon, 16 Aug 2021 10:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH resend net-next] r8169: rename rtl_csi_access_enable to
 rtl_set_aspm_entry_latency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910980708.576.16766527459617817080.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:30:07 +0000
References: <1b34d82a-534f-f736-e54f-6814b0ff7112@gmail.com>
In-Reply-To: <1b34d82a-534f-f736-e54f-6814b0ff7112@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 15 Aug 2021 10:26:18 +0200 you wrote:
> Rename the function to reflect what it's doing. Also add a description
> of the register values as kindly provided by Realtek.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [resend,net-next] r8169: rename rtl_csi_access_enable to rtl_set_aspm_entry_latency
    https://git.kernel.org/netdev/net-next/c/c07c8ffc70d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


