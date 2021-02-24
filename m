Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3768B32428A
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhBXQvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:39462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235631AbhBXQuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 11:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E198564F09;
        Wed, 24 Feb 2021 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614185407;
        bh=HsHJM7K8fSiLeVj/nfKx5Y2qZT9DZ7EwVlOWanoKW58=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EUG7zQs8H4Rn2N/OSKJmui/ZhoOPa9FMbmG6viFc4s/qXzJs/IAxCkEnS803z7mTm
         upIaYzU+JiFRChyZOCRbgTTnl2JBTE2vFZIV3THjFuaNUL/i62Ul81qrUNaVvDPHbk
         OuWtHOKR65on0UyuUNu+scuJO+ztQnD09IYDUQ+HyJzllCTCRd4ovp/yoR0kJ09QPC
         xkVZB70JGR5i1gH70hCUQyYkrn3PY0w5F2Ofl2rWyHv/eedcVcCfsm83CNTOGsxhxf
         p7wwMrLC7CjrB5EZQ76OP+2TG0+gdBGOo4etEfzskNzxEKMaDcYjLt9O401w5g5e2Y
         3NqXJCVrih+5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD6CF60176;
        Wed, 24 Feb 2021 16:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2021-02-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161418540783.30992.10091755167748733506.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Feb 2021 16:50:07 +0000
References: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 22 Feb 2021 15:58:09 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Dave corrects reporting of max TCs to use the value from hardware
> capabilities and setting of DCBx capability bits when changing between
> SW and FW LLDP.
> 
> Brett fixes trusted VF multicast promiscuous not receiving expected
> packets and corrects VF max packet size when a port VLAN is configured.
> 
> [...]

Here is the summary with links:
  - [net,1/5] ice: report correct max number of TCs
    https://git.kernel.org/netdev/net/c/7dcf7aa01c7b
  - [net,2/5] ice: Set trusted VF as default VSI when setting allmulti on
    https://git.kernel.org/netdev/net/c/37b52be26002
  - [net,3/5] ice: Account for port VLAN in VF max packet size calculation
    https://git.kernel.org/netdev/net/c/a6aa7c8f998f
  - [net,4/5] ice: Fix state bits on LLDP mode switch
    https://git.kernel.org/netdev/net/c/0d4907f65dc8
  - [net,5/5] ice: update the number of available RSS queues
    https://git.kernel.org/netdev/net/c/0393e46ac48a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


