Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E133D3104AF
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBEFku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 00:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:50534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhBEFkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 00:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 260B364FBC;
        Fri,  5 Feb 2021 05:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612503609;
        bh=iuPnD2YbI0OC/RCIozhTKUFxnSDG/FUtqBcFnIJrsZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YcGxHDB1GQFFodInqamaC/q2ZNLGStSzji50GamoYWBM3PzD0zSlVwzjYS63s0tke
         BMDI2L/ITJUVaVYtXzsIREFjcXFYGUqVJTxiLiFqmSVi7mNrI7rb4NNlZqHOhZLsNQ
         L9RXFe4UtVliJMNZNbo9er6ZnUAiS02VzdlKKx6q6TmYjHIVsBHR7kQJB3wz+yhBUz
         Rr9F/ur6pbpeH3tvtzYzY5OmJjyDZO7cIXBBH8iM8abUgWVdju1LuzKGZVYzCPjIBu
         aiS7YhitWf41Y3MU9bM5D1hXeS43q/msSWTSy2SBAGIc99b5YORVcl/tlAzhT+q/G2
         00n0Dp7Safd9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 13B1E609E5;
        Fri,  5 Feb 2021 05:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-02-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161250360907.20637.1889223742316962481.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 05:40:09 +0000
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  3 Feb 2021 16:42:44 -0800 you wrote:
> This series contains updates to igc, igb, e1000e, and e1000 drivers.
> 
> Sasha adds counting of good transmit packets and reporting of NVM version
> and gPHY version in ethtool firmware version. Replaces the use of strlcpy
> to the preferred strscpy. Fixes a typo that caused the wrong register to be
> output. He also removes an unused function pointer, some unneeded defines,
> and a non-applicable comment. All changes for igc.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] igc: Clean up nvm_operations structure
    https://git.kernel.org/netdev/net-next/c/63532ced0777
  - [net-next,02/15] igc: Remove igc_set_fw_version comment
    https://git.kernel.org/netdev/net-next/c/4d59f52ba770
  - [net-next,03/15] igc: Remove MULR mask define
    https://git.kernel.org/netdev/net-next/c/e96c5b46bdf1
  - [net-next,04/15] igc: Add Host Good Packets Transmitted Count
    https://git.kernel.org/netdev/net-next/c/e65299444e3c
  - [net-next,05/15] igc: Expose the NVM version
    https://git.kernel.org/netdev/net-next/c/01bb6129c641
  - [net-next,06/15] igc: Expose the gPHY firmware version
    https://git.kernel.org/netdev/net-next/c/94f794d15a5e
  - [net-next,07/15] igc: Prefer strscpy over strlcpy
    https://git.kernel.org/netdev/net-next/c/ed443cdf67b5
  - [net-next,08/15] igc: Remove unused local receiver mask
    https://git.kernel.org/netdev/net-next/c/9c99482e45b0
  - [net-next,09/15] igc: Remove unused FUNC_1 mask
    https://git.kernel.org/netdev/net-next/c/4917fc8eb640
  - [net-next,10/15] igc: Fix TDBAL register show incorrect value
    https://git.kernel.org/netdev/net-next/c/9660ef25e958
  - [net-next,11/15] igb: fix TDBAL register show incorrect value
    https://git.kernel.org/netdev/net-next/c/abb9efc70988
  - [net-next,12/15] igb: Enable RSS for Intel I211 Ethernet Controller
    https://git.kernel.org/netdev/net-next/c/6e6026f2dd20
  - [net-next,13/15] igb: remove h from printk format specifier
    https://git.kernel.org/netdev/net-next/c/2f7c1fd23d9f
  - [net-next,14/15] e1000e: remove the redundant value assignment in e1000_update_nvm_checksum_spt
    https://git.kernel.org/netdev/net-next/c/99eb3943ab9b
  - [net-next,15/15] e1000: drop unneeded assignment in e1000_set_itr()
    https://git.kernel.org/netdev/net-next/c/5a04b958ad39

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


