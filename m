Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBC53D41FC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhGWU3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231724AbhGWU3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 16:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 01DE560F26;
        Fri, 23 Jul 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627074607;
        bh=DYQat6CIhwXtPhT7aIjZ/Kl51eq3B6eTOvb4gxd4Mhs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TzwMkoDdXFq/0j5aoZ45o09r43coIpsiosE5mRqU+6bPaw1w8/5BiYrSTeyunKlOU
         E2f6tjSxZTpXTB0ZKMfaTS9XeobJcTUi/UoIFNeHxp6Ed22oScOPeAVKrvzNcI2/aM
         Xwd4GkU2pOm2gS17MeQCZicHOxXfRckh1GDDTQbvEk362NnR9qevSpgt5FhdJo6nPr
         c9sEPbrPHHsSrvL/Kb+Twm/azpkGl4VyccSlLBIoqialSp4zwzxnURyzf8v53Y1YzD
         0rhUIOTidzMbnj19/mbtQ/LvtAbyVXUZPb4z5cghmQhYL/NUOA29gZJOal6FLpHLLx
         dr1emyT+X5jrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBA90608AF;
        Fri, 23 Jul 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2021-07-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162707460696.15525.6128105341530676475.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 21:10:06 +0000
References: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210723171023.296927-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 10:10:18 -0700 you wrote:
> This series contains updates to i40e driver only.
> 
> Arkadiusz corrects the order of calls for disabling queues to resolve
> a false error message and adds a better message to the user when
> transitioning FW LLDP back on while the firmware is still processing
> the off request.
> 
> [...]

Here is the summary with links:
  - [net,1/5] i40e: Fix logic of disabling queues
    https://git.kernel.org/netdev/net/c/65662a8dcdd0
  - [net,2/5] i40e: Fix firmware LLDP agent related warning
    https://git.kernel.org/netdev/net/c/71d6fdba4b2d
  - [net,3/5] i40e: Add additional info to PHY type error
    https://git.kernel.org/netdev/net/c/dc614c46178b
  - [net,4/5] i40e: Fix queue-to-TC mapping on Tx
    https://git.kernel.org/netdev/net/c/89ec1f0886c1
  - [net,5/5] i40e: Fix log TC creation failure when max num of queues is exceeded
    https://git.kernel.org/netdev/net/c/ea52faae1d17

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


