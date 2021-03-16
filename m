Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC11233E18D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhCPWkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231409AbhCPWkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA16F64F3E;
        Tue, 16 Mar 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615934410;
        bh=IsiVmvmkRPnddpzJqY8/u8Y0CdZ2EthwwnP4P3mjFdo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n81kJ98szaSvf0qAiu6a/dMqW05+WKcIegS/4zu7weClcJdnioOmH8upDCBigT+pd
         mJuDBbokRkdSen5zs8QEPbbdilGNZBsHgLNTOGrGZGVIpJraC6lc2yQPy+FaS7C16t
         kUgaPs2KWv0wPKHC6TefR/ncZSWZLPvjAZmYIlB9Zst3Ezn7P8th3dkw3hw1FzbqLM
         BnzjS9oaXRO7i6/7CNe41jNYaCylS8CroTcSGx7e7/c7d5kUIEeB1AC4ky0Fay4CwA
         jp4pWT9/qBMWfEFDt3Iw7OilwCGWZflFYZcMoWV9uy/Pvl4fkKBchaHFsnESVuGXAw
         PzSTarevLGavQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5A6860A3D;
        Tue, 16 Mar 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-03-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593441080.11342.2793990576361780579.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:40:10 +0000
References: <20210316164254.3744059-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210316164254.3744059-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 09:42:51 -0700 you wrote:
> This series contains updates to i40e, ixgbe, and ice drivers.
> 
> Magnus Karlsson says:
> 
> Optimize run_xdp_zc() for the XDP program verdict being XDP_REDIRECT
> in the xsk zero-copy path. This path is only used when having AF_XDP
> zero-copy on and in that case most packets will be directed to user
> space. This provides around 100k extra packets in throughput on my
> server when running l2fwd in xdpsock.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] i40e: optimize for XDP_REDIRECT in xsk path
    https://git.kernel.org/netdev/net-next/c/346497c78d15
  - [net-next,2/3] ixgbe: optimize for XDP_REDIRECT in xsk path
    https://git.kernel.org/netdev/net-next/c/7d52fe2eaddf
  - [net-next,3/3] ice: optimize for XDP_REDIRECT in xsk path
    https://git.kernel.org/netdev/net-next/c/bb52073645a6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


