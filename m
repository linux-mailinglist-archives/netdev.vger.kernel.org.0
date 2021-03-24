Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CEA346E3C
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhCXAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhCXAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EEB62619C9;
        Wed, 24 Mar 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616545210;
        bh=Gb+JgYQmxr/odE63Htj48NHFKkE4rNhMXguYQlQLE+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ipgbjVg3f5VmjiWHPeyopCEmbnSzzqyq41l5hJyKdCU3mz93uzRQI+t60PC/diHg4
         kq92tQIPSIyXzvYc0XqfO4N3c7z7gFDdOAfM+ZsfHwCKF2zChcqWbJfxWS8/va84ur
         lZQZzOknTrqGiHfBuUipN1M2LSaZlmP4q+hoOI+kCzXSFTste7Ej7KTjU8ufensKmD
         BBvGmsGB/xFXj6e40RXkltJ8sf1dzZkAeGEPteQchSYZ8uS/4/39UsMEu01+Xnuhrr
         TZj/ylKVDqNmNBIuOO/VVU316SeTZJVkb77PFjbQ79fO7Isaj3gCHr2aA1LZod0k6g
         h58tdfTg3pybw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E223D60A0E;
        Wed, 24 Mar 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-03-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161654520992.13502.16093262378436187844.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 00:20:09 +0000
References: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 12:01:39 -0700 you wrote:
> This series contains updates to ice, fm10k, i40e, iavf, ixgbe, ixgbevf,
> igb, e1000e, and e1000 drivers.
> 
> Tony fixes prototype warnings for mismatched header for ice driver.
> 
> Sasha fixes prototype warnings for mismatched header for igc and e1000e
> driver.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] ice: Fix prototype warnings
    https://git.kernel.org/netdev/net-next/c/ef860480ea18
  - [net-next,02/10] igc: Fix prototype warning
    https://git.kernel.org/netdev/net-next/c/c4cdb4efa20c
  - [net-next,03/10] e1000e: Fix prototype warning
    https://git.kernel.org/netdev/net-next/c/39da2cac42d4
  - [net-next,04/10] intel: clean up mismatched header comments
    https://git.kernel.org/netdev/net-next/c/262de08f64e3
  - [net-next,05/10] ice: Fix fall-through warnings for Clang
    https://git.kernel.org/netdev/net-next/c/9ded647a5141
  - [net-next,06/10] fm10k: Fix fall-through warnings for Clang
    https://git.kernel.org/netdev/net-next/c/f83a0d0adac6
  - [net-next,07/10] ixgbe: Fix fall-through warnings for Clang
    https://git.kernel.org/netdev/net-next/c/27e40255e5ac
  - [net-next,08/10] igb: Fix fall-through warnings for Clang
    https://git.kernel.org/netdev/net-next/c/52c406989a51
  - [net-next,09/10] ixgbevf: Fix fall-through warnings for Clang
    https://git.kernel.org/netdev/net-next/c/d8f0c306985e
  - [net-next,10/10] e1000: Fix fall-through warnings for Clang
    https://git.kernel.org/netdev/net-next/c/67831a08a778

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


