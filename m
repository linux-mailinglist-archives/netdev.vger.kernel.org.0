Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF1D3B3782
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 22:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhFXUCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 16:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232653AbhFXUCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 16:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 27C8E6137D;
        Thu, 24 Jun 2021 20:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624564804;
        bh=Q6hq2eGybClEDYWVboqkq/50UGjqlAFAxmRHZNmVJRg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kd1swzfg/ZXVnFjAATxQJpBsCW82r+gbRcWydVdQ6Xx05fxIQCmTL8w68kmjrauLK
         Ls7KIPD1kQgV6suZfYBXUZlpOge5XsXrwCKbxf6TQASeFivhXu9zBi0LMmQQT8AMNW
         VZjH+g0PGSjeZfrWo8E4ZcauLklHf/R5SaosancigVpFui4/58SZHdk72ZcD2smMh5
         y3s0eXFg0r1sEF7GljaMMtERl8sg4nj2totR58TZp+qJAJOmbv0tWooSf9xVVMxypV
         isEo/qR1mB7nbaHFRZp5FcQTatCDkAFglpRqY/gRpI6hxSlq0zPAE0h5zj2EpUBGts
         wHlv/T4dzdCDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1BEEA60A2F;
        Thu, 24 Jun 2021 20:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2021-06-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162456480410.15446.3536150269171120338.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 20:00:04 +0000
References: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210624181434.751511-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 11:14:30 -0700 you wrote:
> This series contains updates to i40e driver only.
> 
> Dinghao Liu corrects error handling for failed i40e_vsi_request_irq()
> call.
> 
> Mateusz allows for disabling of autonegotiation for all BaseT media.
> 
> [...]

Here is the summary with links:
  - [net,1/4] i40e: Fix error handling in i40e_vsi_open
    https://git.kernel.org/netdev/net/c/9c04cfcd4aad
  - [net,2/4] i40e: Fix autoneg disabling for non-10GBaseT links
    https://git.kernel.org/netdev/net/c/9262793e59f0
  - [net,3/4] i40e: fix PTP on 5Gb links
    https://git.kernel.org/netdev/net/c/26b0ce8dd3dd
  - [net,4/4] i40e: Fix missing rtnl locking when setting up pf switch
    https://git.kernel.org/netdev/net/c/956e759d5f8e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


