Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFD8436015
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhJULWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230105AbhJULWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 07:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 658A26109F;
        Thu, 21 Oct 2021 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634815208;
        bh=UocIQzlYElliBe1HFK6S/O5Z3HyOEHBHhW9/yrT0otM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J5vzHWQbegqCJizCpMUV5va1Nbahu2qdS4qWv540ARx7ajlNEVPlADxoeFGK6adF9
         n3mk4SP3Z7r6EVJersiyqaGymLFhAdWXQHPMkaZ5caeagt6V0dP8EEDSjiUzVoDHzm
         ehIor0YGbHHS5FuJscaUYyuV3F1M55PMwG+BXUSXV3WcGbTPariHoQ4GhSb0NSJHNk
         wGi763ocH9z8ZnN7sDDybjvrkV26pDR2iS/9TkdXl173gO3GfA/gFaCNW0zosYpayd
         w/WhiS+Z2bOIcMhgeA1qNqAYcW+DT3IXJTY8Ag/keAXrJyEtl+RA+EifrvzGxEvE5Y
         8FSsiciciKQ9g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57A3860A24;
        Thu, 21 Oct 2021 11:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2021-10-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163481520835.3134.9488542088302661465.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 11:20:08 +0000
References: <20211020164957.3371484-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211020164957.3371484-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 20 Oct 2021 09:49:53 -0700 you wrote:
> This series contains updates to e1000e, igc, and ice drivers.
> 
> Sasha fixes an issue with dropped packets on Tiger Lake platforms for
> e1000e and corrects a device ID for igc.
> 
> Tony adds missing E810 device IDs for ice.
> 
> [...]

Here is the summary with links:
  - [net,1/4] e1000e: Separate TGP board type from SPT
    https://git.kernel.org/netdev/net/c/280db5d42009
  - [net,2/4] e1000e: Fix packet loss on Tiger Lake and later
    https://git.kernel.org/netdev/net/c/639e298f432f
  - [net,3/4] igc: Update I226_K device ID
    https://git.kernel.org/netdev/net/c/79cc8322b6d8
  - [net,4/4] ice: Add missing E810 device ids
    https://git.kernel.org/netdev/net/c/7dcf78b870be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


