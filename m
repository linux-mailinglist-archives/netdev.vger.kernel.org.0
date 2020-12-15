Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA8D2DA5EC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgLOCBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgLOCAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607997608;
        bh=whyvOZa/FvuTZBvs1uWXg/cw/gD48NQTuy46h6DTxXw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NCDMxWeXChalOpVpEPMaZjId6SAtoWEab33fp+o4nMbv1DRk2eAorcnQDFS6IQ6LQ
         q7Wk43qaDk0rgsuvq9hp6wRTnvqkuNXmZ1AUTgAEM/G6ucwoed1cVFcS8GC7JtN6Ze
         LovOoWySPgwhQCD9A2+XZdrZUBfeyt8nsmDcNleM7E9JGxVKSCU2Bkb93L2GFiGuGE
         X+njbuyO9bqaQynzSzOjBGvnjiJyrCLtOKWOU9Z2Tpxfp+LqSyej4gt6D8uoNobAys
         tyL1Kt3QIk+sCfpb9om8c1xEXPeWwtcUEAXuIozBvKS2sh7p3PMhkCiLXgPCrBjlbM
         hK6qFFtzm8LYg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv6 net-next 0/3] Add devlink and devlink health reporters to 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160799760815.15807.11950025011847625319.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 02:00:08 +0000
References: <20201211062526.2302643-1-george.cherian@marvell.com>
In-Reply-To: <20201211062526.2302643-1-george.cherian@marvell.com>
To:     George Cherian <george.cherian@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com,
        willemdebruijn.kernel@gmail.com, saeed@kernel.org, jiri@resnulli.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Dec 2020 11:55:23 +0530 you wrote:
> Add basic devlink and devlink health reporters.
> Devlink health reporters are added for NPA block.
> 
> Address Jakub's comment to add devlink support for error reporting.
> https://www.spinics.net/lists/netdev/msg670712.html
> 
> For now, I have dropped the NIX block health reporters.
> This series attempts to add health reporters only for the NPA block.
> As per Jakub's suggestion separate reporters per event is used and also
> got rid of the counters.
> 
> [...]

Here is the summary with links:
  - [PATCHv6,net-next,1/3] octeontx2-af: Add devlink suppoort to af driver
    https://git.kernel.org/netdev/net-next/c/fae06da4f261
  - [2/3] octeontx2-af: Add devlink health reporters for NPA
    https://git.kernel.org/netdev/net-next/c/f1168d1e207c
  - [3/3] docs: octeontx2: Add Documentation for NPA health reporters
    https://git.kernel.org/netdev/net-next/c/80b9414832a1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


