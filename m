Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08277476F02
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 11:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbhLPKkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 05:40:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45418 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhLPKkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 05:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CE34B82370
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 10:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CA08C36AE5;
        Thu, 16 Dec 2021 10:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639651211;
        bh=A1XLnNa5mC2wB+huqC2oiQaQCudy3maKPeIVmMrcAss=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A+3471yRZMASsPcIns9A/49nFi/A/O+h/RzRPjOKOWV/ZuS/5bHec7eHfDI+XZSPF
         r19E877lJiEKkT338RbLdDwZcp0SlvcTKT4WUX/9ZMzGw3aiKP8affYooLp9ZmK8q4
         ctXoQFfqbWx0IazduzM1kmzDllmF2fk1F8UF4rkMn6ZPj9rpVRRj9n3HzIFNxMqbsN
         Gla7y2dT0R1TcySZjR0ZjpV5gAnEhakjM77rbISUFvGQW8pDflQP/5oVWdCzWtPdFe
         CHcbJll6yQGnLqbedr2EAbEokUh+CmcTMOSzZCwpVDvIgGSZuiiraC9EjAZoPr2nVP
         PXhedKDKo72ZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2DE2060A39;
        Thu, 16 Dec 2021 10:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2021-12-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163965121118.25281.3094118012863012819.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 10:40:11 +0000
References: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 15 Dec 2021 11:34:29 -0800 you wrote:
> This series contains updates to igb, igbvf, igc and ixgbe drivers.
> 
> Karen moves checks for invalid VF MAC filters to occur earlier for
> igb.
> 
> Letu Ren fixes a double free issue in igbvf probe.
> 
> [...]

Here is the summary with links:
  - [net,1/5] igb: Fix removal of unicast MAC filters of VFs
    https://git.kernel.org/netdev/net/c/584af82154f5
  - [net,2/5] igbvf: fix double free in `igbvf_probe`
    https://git.kernel.org/netdev/net/c/b6d335a60dc6
  - [net,3/5] igc: Fix typo in i225 LTR functions
    https://git.kernel.org/netdev/net/c/0182d1f3fa64
  - [net,4/5] ixgbe: Document how to enable NBASE-T support
    https://git.kernel.org/netdev/net/c/271225fd57c2
  - [net,5/5] ixgbe: set X550 MDIO speed before talking to PHY
    https://git.kernel.org/netdev/net/c/bf0a375055bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


