Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7BA35FC5E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbhDNUK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234184AbhDNUKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D4C1961220;
        Wed, 14 Apr 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431010;
        bh=JnstIAXgcJK/GICfrsweR9RYMvT7gFhTxL37OIwqMVk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lxjJMC103mrU2gTk4H670J7e8hi2lU+M7z/KtK9pH7RFOopHf2Xz7OEBzm3E1iyQF
         h11m/VoNhc4P/uPOe//JmyPBdfuMLDgZy+fB/srzHSVudsL3KOheI0lTAdldU+FX4R
         CgjIy814WGwN6B83tjyqCDPAX8mHs3pu1jaQ5lxqWOnWRByQEWsSLLOi6MUJIZdnrv
         iiFzPGRAKoEtk/GzPqV0tfPF/lP9NitHoKr5WAigUninJufBXE9cWA2cs1lkXI1U5p
         EJOolfxwhX36g4XPzIrHQiqWORxAB6fi1VfNZ3F/PErdL36nBzJNZm1nmOhcDu21x2
         kZiRhEfcVLKeA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CEA0A60CD1;
        Wed, 14 Apr 2021 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3][pull request] 10GbE Intel Wired LAN Driver
 Updates 2021-04-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843101084.9720.913317006160677710.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:10:10 +0000
References: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 19:17:20 -0700 you wrote:
> This series contains updates to ixgbe and ixgbevf driver.
> 
> Jostar Yang adds support for BCM54616s PHY for ixgbe.
> 
> Chen Lin removes an unused function pointer for ixgbe and ixgbevf.
> 
> Bhaskar Chowdhury fixes a typo in ixgbe.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] ixgbe: Support external GBE SerDes PHY BCM54616s
    https://git.kernel.org/netdev/net-next/c/47222864c14b
  - [net-next,v2,2/3] net: intel: Remove unused function pointer typedef ixgbe_mc_addr_itr
    https://git.kernel.org/netdev/net-next/c/7eceea90c542
  - [net-next,v2,3/3] net: ethernet: intel: Fix a typo in the file ixgbe_dcb_nl.c
    https://git.kernel.org/netdev/net-next/c/ce2cb12dccab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


