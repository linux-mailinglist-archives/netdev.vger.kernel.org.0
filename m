Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6B5441B83
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhKANMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231847AbhKANMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E8A9E61058;
        Mon,  1 Nov 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635772210;
        bh=7+LXsa08jubTeimitX6UGUV0o2VhfE3e8rMZZnyUrqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fig25EkdDnsja8Y0ld6F9KudTKbx827c1edJhwLP/xuiMaFciogo52hLUYeq5eQuX
         WhE4AjHyHyOgDR5Ap23fAruswFcEvfbId2qMh8ZqDAZExb28vpi0gsGn4hymACoss7
         3gAPrrjtC1TEI5h8kf8MBipDSkPuZfEpxnR2lqh9g0FeB+1KYcmiZw4Tzs99xYLGMh
         X4+fHyihoL7HIg1Uj3e9ro5Nxem9OwjpRa3ZbKKvrN+b5DUsB6LTOVgrlMn3a7WDJJ
         jgTILBU2EwxGGWNRhH94s3XD0v+Mw46Q6qG6k3UwXUQLwVOI4mCM3T2EJKsBLC1zT7
         Wv3kx074ccUzg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC71C60BD0;
        Mon,  1 Nov 2021 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-10-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577220983.25752.16158526730602629379.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:10:09 +0000
References: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 29 Oct 2021 13:45:33 -0700 you wrote:
> This series contains updates to ice and iavf drivers and virtchnl header
> file.
> 
> Brett removes vlan_promisc argument from a function call for ice driver.
> In the virtchnl header file he removes an unused, reserved define and
> converts raw value defines to instead use the BIT macro.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] ice: Remove boolean vlan_promisc flag from function
    https://git.kernel.org/netdev/net-next/c/29e71f41e7d2
  - [net-next,2/7] ice: Clear synchronized addrs when adding VFs in switchdev mode
    https://git.kernel.org/netdev/net-next/c/c79bb28e19cc
  - [net-next,3/7] ice: Hide bus-info in ethtool for PRs in switchdev mode
    https://git.kernel.org/netdev/net-next/c/bfaaba99e680
  - [net-next,4/7] virtchnl: Remove unused VIRTCHNL_VF_OFFLOAD_RSVD define
    https://git.kernel.org/netdev/net-next/c/5bf84b299385
  - [net-next,5/7] virtchnl: Use the BIT() macro for capability/offload flags
    https://git.kernel.org/netdev/net-next/c/4a15022f82ee
  - [net-next,6/7] iavf: Add helper function to go from pci_dev to adapter
    https://git.kernel.org/netdev/net-next/c/247aa001b72b
  - [net-next,7/7] iavf: Fix kernel BUG in free_msi_irqs
    https://git.kernel.org/netdev/net-next/c/605ca7c5c670

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


