Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C579339B08
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhCMCKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhCMCKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 21:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0897064F60;
        Sat, 13 Mar 2021 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615601409;
        bh=GwshTpfd/kgT+9AODlccLuvbWs5HFinxtRMe9BsXSo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b121potx/NQK+WtZHt4aOEHRbYMPC54DI4er6+OL6jBphqqSmNkGyKRrSTJyzEPNC
         tKtIdFDQrutG6byB7+w2Hm5Pp/KF0vf2cX/2gZUZXRr9i1LbQBCKEXQAuvoc04jL6Y
         C4bgUMxQurn31gjrpQqdhEtflowkTokLz9QJRysqO0p2K7uMJDHJMq2H8bcpueBAQR
         KgI/hz+olNDAMK6brxyt17jaA6sj94GFTJPbZe56wbwwezPURCr6eHUAPhTjoYL+Tk
         9703kAzJKREqKef6aokYE1WBlyDEc+In8xtYgEpDoiqfOjJhaq5U8P1ebg33Rx/drX
         77xGZYCzpMAog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F313C60A57;
        Sat, 13 Mar 2021 02:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2021-03-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161560140899.29961.10699958887835723799.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 02:10:08 +0000
References: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Mar 2021 09:47:50 -0800 you wrote:
> This series contains updates to ice, i40e, ixgbe and igb drivers.
> 
> Magnus adjusts the return value for xsk allocation for ice. This fixes
> reporting of napi work done and matches the behavior of other Intel NIC
> drivers for xsk allocations.
> 
> Maciej moves storing of the rx_offset value to after the build_skb flag
> is set as this flag affects the offset value for ice, i40e, and ixgbe.
> 
> [...]

Here is the summary with links:
  - [net,1/5] ice: fix napi work done reporting in xsk path
    https://git.kernel.org/netdev/net/c/ed0907e3bdcf
  - [net,2/5] i40e: move headroom initialization to i40e_configure_rx_ring
    https://git.kernel.org/netdev/net/c/a86606268ec0
  - [net,3/5] ice: move headroom initialization to ice_setup_rx_ctx
    https://git.kernel.org/netdev/net/c/89861c485c6a
  - [net,4/5] ixgbe: move headroom initialization to ixgbe_configure_rx_ring
    https://git.kernel.org/netdev/net/c/76064573b121
  - [net,5/5] igb: avoid premature Rx buffer reuse
    https://git.kernel.org/netdev/net/c/98dfb02aa222

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


