Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C8A2DA6B0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgLODRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727968AbgLODMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:30 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608001848;
        bh=8EuA5IT8VVLssd3bGwieJ7ONi5uhgpuQnX7jkxmCD5s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lqvj1JCbcZ0GGY2AW/GutvTX+z2t9PM6VgDJWHOKIunsVMqKUvilugx2cDDqgbBVI
         +l3E675ngg7QxemvSmyjJMEW1R127VOiV7/wDoILZ9bWC91a5X3BYQFrdHY0fovPbz
         zjYtX3kj7wNgNC78fQkbLF93NiaO/u5xkJVNhlo38YZYMzoOYsxtI4ZqgJkValL68Y
         VHMZmK0yyYAucdI5gg7tLkmsBUKRf/v2wq+JkksW2MFAsYuQZTeGssnBPVQ+J8fvrZ
         CTz6MLjUtR+KYi3kpTE4dCNCXk4a/3qmHZ/yD+IhNFsWS4gr+VpMyzVjaSTucCabw7
         zlUrVY14JttRA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] bnxt_en: Improve firmware flashing.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800184819.22481.13976317914156133212.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:10:48 +0000
References: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1607860306-17244-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 13 Dec 2020 06:51:41 -0500 you wrote:
> This patchset improves firmware flashing in 2 ways:
> 
> - If firmware returns NO_SPACE error during flashing, the driver will
> create the UPDATE directory with more staging area and retry.
> - Instead of allocating a big DMA buffer for the entire contents of
> the firmware package size, fallback to a smaller buffer to DMA the
> contents in multiple DMA operations.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] bnxt_en: Refactor bnxt_flash_nvram.
    https://git.kernel.org/netdev/net-next/c/93ff343528ce
  - [net-next,2/5] bnxt_en: Rearrange the logic in bnxt_flash_package_from_fw_obj().
    https://git.kernel.org/netdev/net-next/c/a9094ba6072b
  - [net-next,3/5] bnxt_en: Restructure bnxt_flash_package_from_fw_obj() to execute in a loop.
    https://git.kernel.org/netdev/net-next/c/2e5fb428a61c
  - [net-next,4/5] bnxt_en: Retry installing FW package under NO_SPACE error condition.
    https://git.kernel.org/netdev/net-next/c/1432c3f6a6ca
  - [net-next,5/5] bnxt_en: Enable batch mode when using HWRM_NVM_MODIFY to flash packages.
    https://git.kernel.org/netdev/net-next/c/a86b313e1817

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


