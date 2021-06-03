Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FAC39ADD0
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhFCWVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhFCWVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 208EF61404;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622758806;
        bh=q6rIz6UQTmJ2oSXWp7jonXhGwpYQ3CSj8OSkwXqisNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hGVNFhWlL3Z3tBzwtxg2P8S3Y5RgJCFteq9LBCopVpSTl83JL28TJxVjULm/zgQtn
         czKMnzBPlLM416m1oY6XkRJQxqJCZ4Ft99TruLvuEiYNa4zP3ZNql8LTxZOzl4EV2f
         LZsDw6glZtrLkC8vofNvbUjlTDNCkRBM7/kLfgALYSnwzTuV5FlG3Jz4m37jv1gb2D
         JAhY/h6WZ4xwwLUK3Ec7BlPHQ1IBjGtrDo7fqMOXY7OEnMjn/PrdRrea/u9kG9xznf
         DreWLPlvdqg/m7sE+LyqCGZTzXc49jcZ4QAlLzDr5A3bZVUPbUOWccNiMFdTgyXXcv
         TGWBZh55hNsSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 101C160A6C;
        Thu,  3 Jun 2021 22:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/8][pull request] Intel Wired LAN Driver Updates
 2021-06-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275880606.4249.10508150698994646337.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:20:06 +0000
References: <20210603165923.1918030-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210603165923.1918030-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  3 Jun 2021 09:59:15 -0700 you wrote:
> This series contains updates to igb, igc, ixgbe, ixgbevf, i40e and ice
> drivers.
> 
> Kurt Kanzenbach fixes XDP for igb when PTP is enabled by pulling the
> timestamp and adjusting appropriate values prior to XDP operations.
> 
> Magnus adds missing exception tracing for XDP on igb, igc, ixgbe,
> ixgbevf, i40e and ice drivers.
> 
> [...]

Here is the summary with links:
  - [net,1/8] igb: Fix XDP with PTP enabled
    https://git.kernel.org/netdev/net/c/5379260852b0
  - [net,2/8] i40e: add correct exception tracing for XDP
    https://git.kernel.org/netdev/net/c/f6c10b48f8c8
  - [net,3/8] ice: add correct exception tracing for XDP
    https://git.kernel.org/netdev/net/c/89d65df024c5
  - [net,4/8] ixgbe: add correct exception tracing for XDP
    https://git.kernel.org/netdev/net/c/8281356b1cab
  - [net,5/8] igb: add correct exception tracing for XDP
    https://git.kernel.org/netdev/net/c/74431c40b9c5
  - [net,6/8] ixgbevf: add correct exception tracing for XDP
    https://git.kernel.org/netdev/net/c/faae81420d16
  - [net,7/8] igc: add correct exception tracing for XDP
    https://git.kernel.org/netdev/net/c/45ce08594ec3
  - [net,8/8] ice: track AF_XDP ZC enabled queues in bitmap
    https://git.kernel.org/netdev/net/c/e102db780e1c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


