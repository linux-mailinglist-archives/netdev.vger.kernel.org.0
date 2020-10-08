Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF63287CB8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgJHUAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgJHUAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 16:00:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602187205;
        bh=kOuklXg3znUMVaYlMdiPMg1NKZtlSIv7FlcOGDsAuQ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JaKYlszmk6BB63E53s01jlvXFk7siZzuZ2ofqXpH5upOv/2N+QTd99z32ilq4qZQ5
         doPEtOLwaMThjLLGaBJjVroXDX49pLQ/mhb5yI5KSlTn1hBmvkeCiMP8dRlQ7ujDFs
         xUhXfowX/OXRYW4B0ORMjLelB2vrSjPlWhzdyLOY=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8169: consider that PHY reset may still be in progress
 after applying firmware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160218720498.8125.5350894369790668548.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Oct 2020 20:00:04 +0000
References: <a89cee3b-caa0-99aa-d7a2-de4257204db4@gmail.com>
In-Reply-To: <a89cee3b-caa0-99aa-d7a2-de4257204db4@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, nic_swsd@realtek.com, davem@davemloft.net,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 7 Oct 2020 13:34:51 +0200 you wrote:
> Some firmware files trigger a PHY soft reset and don't wait for it to
> be finished. PHY register writes directly after applying the firmware
> may fail or provide unexpected results therefore. Fix this by waiting
> for bit BMCR_RESET to be cleared after applying firmware.
> 
> There's nothing wrong with the referenced change, it's just that the
> fix will apply cleanly only after this change.
> 
> [...]

Here is the summary with links:
  - [net] r8169: consider that PHY reset may still be in progress after applying firmware
    https://git.kernel.org/netdev/net/c/47dda78671a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


