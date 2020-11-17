Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F232B7129
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgKQWAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgKQWAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 17:00:09 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605650408;
        bh=nJe27WpcM/U4Xti35M0uG8AHrm3YMUVm1KR0EuwZwAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JQAYJuuAP+aU/rEf7mF0DQx+DuBcWD0oiOq7Mk4gtpLpGU5ST+oME72MsfxXwS/Vy
         FZwC+pllSL5BviNliOBx/4zNlkFgq+TS7o9a0fzqCnFNmLbUh7mJvI8XhP5TGvgPd2
         332s/AsHrwQIFAPh+JsVn7hrOuUjFq0BcjJWIwyk=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 00/13] Add ethtool ntuple filters support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160565040832.10116.551528627224189010.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 22:00:08 +0000
References: <20201114195303.25967-1-naveenm@marvell.com>
In-Reply-To: <20201114195303.25967-1-naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, saeed@kernel.org,
        alexander.duyck@gmail.com, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 15 Nov 2020 01:22:50 +0530 you wrote:
> This patch series adds support for ethtool ntuple filters, unicast
> address filtering, VLAN offload and SR-IOV ndo handlers. All of the
> above features are based on the Admin Function(AF) driver support to
> install and delete the low level MCAM entries. Each MCAM entry is
> programmed with the packet fields to match and what actions to take
> if the match succeeds. The PF driver requests AF driver to allocate
> set of MCAM entries to be used to install the flows by that PF. The
> entries will be freed when the PF driver is unloaded.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,01/13] octeontx2-af: Modify default KEX profile to extract TX packet fields
    https://git.kernel.org/netdev/net-next/c/f1517f6f1d6f
  - [v4,net-next,02/13] octeontx2-af: Verify MCAM entry channel and PF_FUNC
    https://git.kernel.org/netdev/net-next/c/041a1c171581
  - [v4,net-next,03/13] octeontx2-af: Generate key field bit mask from KEX profile
    https://git.kernel.org/netdev/net-next/c/9b179a960a96
  - [v4,net-next,04/13] octeontx2-af: Add mbox messages to install and delete MCAM rules
    https://git.kernel.org/netdev/net-next/c/55307fcb9258
  - [v4,net-next,05/13] octeontx2-pf: Add support for ethtool ntuple filters
    https://git.kernel.org/netdev/net-next/c/f0a1913f8a6f
  - [v4,net-next,06/13] octeontx2-pf: Add support for unicast MAC address filtering
    https://git.kernel.org/netdev/net-next/c/63ee51575f6c
  - [v4,net-next,07/13] octeontx2-af: Add debugfs entry to dump the MCAM rules
    https://git.kernel.org/netdev/net-next/c/4d6beb9c8032
  - [v4,net-next,08/13] octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries
    https://git.kernel.org/netdev/net-next/c/9a946def264d
  - [v4,net-next,09/13] octeontx2-pf: Implement ingress/egress VLAN offload
    https://git.kernel.org/netdev/net-next/c/fd9d7859db6c
  - [v4,net-next,10/13] octeontx2-pf: Add support for SR-IOV management functions
    https://git.kernel.org/netdev/net-next/c/f0c2982aaf98
  - [v4,net-next,11/13] octeontx2-af: Handle PF-VF mac address changes
    https://git.kernel.org/netdev/net-next/c/4f88ed2cc5af
  - [v4,net-next,12/13] octeontx2-af: Add new mbox messages to retrieve MCAM entries
    https://git.kernel.org/netdev/net-next/c/dbab48cecc94
  - [v4,net-next,13/13] octeontx2-af: Delete NIX_RXVLAN_ALLOC mailbox message
    https://git.kernel.org/netdev/net-next/c/5a579667850a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


