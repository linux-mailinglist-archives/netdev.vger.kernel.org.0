Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD1D3D05FC
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 02:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhGTXTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 19:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232514AbhGTXT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 19:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B8B1610F7;
        Wed, 21 Jul 2021 00:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626825606;
        bh=gDM1sez5I4M6Wfpcgaj7USOuPAk+ZcHLxI+gD9dZafs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mMm3hyANAr83M6TYjezri1dfl4Req+ICbWcwaifz8j2SFHgWBhqLe3240aHhdqQsU
         wg1LRcm7Dh6gbzGKU61wWhj6qLyZFojiEcVXq+17owUolq8zD/tLpFAdETayKFosTX
         kQzxAnXx/HPgswZy6Ed50M2Ig/SsMU6NK5T32DRgEJU2mdxLtJWur0ng81vP6RtWiH
         8agFfNEpJLslwMpCNrH8c4eIobvEjNSJC0zqhBYEd/JGgZysVku/2KwCodPE9IF7yW
         k5ymiiXWh6hHPIGrwJLZ8352UPxwkLhZzZY4FYVN83TaDGRdjI0Lh1hNLgZhZJAnZo
         gei1KUqmPfkew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8507460C2A;
        Wed, 21 Jul 2021 00:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-07-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162682560654.6038.456724820415942144.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 00:00:06 +0000
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 16:20:49 -0700 you wrote:
> This series contains updates to e1000e and igc drivers.
> 
> Sasha adds initial S0ix support for devices with CSME and adds polling
> for exiting of DPG. He sets the PHY to low power idle when in S0ix. He
> also adds support for new device IDs for and adds a space to debug
> messaging to help with readability for e1000e.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] e1000e: Add handshake with the CSME to support S0ix
    https://git.kernel.org/netdev/net-next/c/3e55d231716e
  - [net-next,02/12] e1000e: Add polling mechanism to indicate CSME DPG exit
    https://git.kernel.org/netdev/net-next/c/ef407b86d3cc
  - [net-next,03/12] e1000e: Additional PHY power saving in S0ix
    https://git.kernel.org/netdev/net-next/c/3ad3e28cb203
  - [net-next,04/12] e1000e: Add support for Lunar Lake
    https://git.kernel.org/netdev/net-next/c/820b8ff653a1
  - [net-next,05/12] e1000e: Add support for the next LOM generation
    https://git.kernel.org/netdev/net-next/c/8e25c0a212de
  - [net-next,06/12] e1000e: Add space to the debug print
    https://git.kernel.org/netdev/net-next/c/ade4162e80f1
  - [net-next,07/12] net/e1000e: Fix spelling mistake "The" -> "This"
    https://git.kernel.org/netdev/net-next/c/e0bc64d31c98
  - [net-next,08/12] igc: Check if num of q_vectors is smaller than max before array access
    https://git.kernel.org/netdev/net-next/c/373e2829e7c2
  - [net-next,09/12] igc: Remove _I_PHY_ID checking
    https://git.kernel.org/netdev/net-next/c/7c496de538ee
  - [net-next,10/12] igc: Remove phy->type checking
    https://git.kernel.org/netdev/net-next/c/47bca7de6a4f
  - [net-next,11/12] igc: Set QBVCYCLET_S to 0 for TSN Basic Scheduling
    https://git.kernel.org/netdev/net-next/c/62f5bbfb2afd
  - [net-next,12/12] igc: Increase timeout value for Speed 100/1000/2500
    https://git.kernel.org/netdev/net-next/c/b27b8dc77b5e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


