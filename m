Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BDB44077A
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 06:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhJ3Emj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 00:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhJ3Emh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 00:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0EEF360FC3;
        Sat, 30 Oct 2021 04:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635568808;
        bh=5HkOSW6rV2rfP532gcX9f3XngSUfFX4caP7tMejWG9s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=udJ8Brnqbuy6R1Z2RJCXZ/bVOLxWDNIUrQj8M7OkzdGLY7o9t6T160rHD7wnhOP16
         dvZ2lGsCOoK5x+JHLEMY2mvZo1BuKlmFfgCuB19YqLwcU1ANU3qKjkAJK/fMawMSt8
         QPIFWkYGDMGHu76E4bzOY5nJ+EKA+hAhvoZ4A7dZG5sKHgUhZFC1abRiZkhdQ7eQw6
         fepumGUxUmXa6DogSHJnnoCXeTYHSrSlCHGR9hYzmJsiFyvcNIm5cY+fO3VSqnmvX6
         Ci4Imtt4sMJx+Lu3bpzaPgErCY58R6q2gDhQ7kumwU4N0KOaGq8x8X/TQ2Zxjb3Yae
         EBBxUI7RrrkYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E961460A5A;
        Sat, 30 Oct 2021 04:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-10-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163556880795.10957.14745592686010390047.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Oct 2021 04:40:07 +0000
References: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 29 Oct 2021 10:40:58 -0700 you wrote:
> This series contains updates to igc driver only.
> 
> Sasha removes an unnecessary media type check, adds a new device ID, and
> changes a device reset to a port reset command.
> 
> The following are changes since commit 28131d896d6d316bc1f6f305d1a9ed6d96c3f2a1:
>   Merge tag 'wireless-drivers-next-2021-10-29' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] igc: Remove media type checking on the PHY initialization
    https://git.kernel.org/netdev/net-next/c/8643d0b6b367
  - [net-next,2/3] igc: Add new device ID
    https://git.kernel.org/netdev/net-next/c/8f20571db527
  - [net-next,3/3] igc: Change Device Reset to Port Reset
    https://git.kernel.org/netdev/net-next/c/e377a063e2c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


