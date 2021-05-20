Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84ED638B97C
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhETWbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhETWbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 18:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 58965613CA;
        Thu, 20 May 2021 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621549812;
        bh=pV4vAMNxQroAW9rAvYR9gF09CXepmWcb2ljTwLDq9yI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EVSpD0On5vkaOIHb5jVKif5Lg5zhX3g3JyCkZMiHRMs4jnSqE6KrLY0Tz70kka2zd
         iu25Xrd3Q2wlGSI68gFHWvkRsYUfgsPbKo1ARNrIe9iWLgZNfor1IdOH3W3vl6eKuY
         dEvEILG3bA0Q3Ef0L63bd2eAxOl+57MZJ/lUPd6QMpS/9UmfwgiHof406jpyPtKMjS
         qfvl9GHPtH1OgyzzLKmJTloiS2oYMD28E4LWhI18i5ELTv9YHfWBJiwFhkHqItiftO
         MJBMS31Dy6SjxWw7UiXZXcUQ8rvDhXb24X0U0gxOMT94WmeIdZXhM8nADx7TAGSmT1
         p+IkwuA1n2Rfg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 528CC609F6;
        Thu, 20 May 2021 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/9][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-05-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162154981233.17678.10022461632863937292.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 22:30:12 +0000
References: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, jithu.joseph@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 11:17:35 -0700 you wrote:
> This series contains updates to igc driver only.
> 
> Andre Guedes says:
> 
> This series adds AF_XDP zero-copy feature to igc driver.
> 
> The initial patches do some code refactoring, preparing the code base to
> land the AF_XDP zero-copy feature, avoiding code duplications. The last
> patches of the series are the ones implementing the feature.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/9] igc: Move igc_xdp_is_enabled()
    https://git.kernel.org/netdev/net-next/c/0c20f2d29fff
  - [net-next,v2,2/9] igc: Refactor __igc_xdp_run_prog()
    https://git.kernel.org/netdev/net-next/c/73a6e3721261
  - [net-next,v2,3/9] igc: Refactor igc_clean_rx_ring()
    https://git.kernel.org/netdev/net-next/c/f485164867d3
  - [net-next,v2,4/9] igc: Refactor XDP rxq info registration
    https://git.kernel.org/netdev/net-next/c/4609ffb9f615
  - [net-next,v2,5/9] igc: Introduce TX/RX stats helpers
    https://git.kernel.org/netdev/net-next/c/a27e6e73e550
  - [net-next,v2,6/9] igc: Introduce igc_unmap_tx_buffer() helper
    https://git.kernel.org/netdev/net-next/c/6123429516c7
  - [net-next,v2,7/9] igc: Replace IGC_TX_FLAGS_XDP flag by an enum
    https://git.kernel.org/netdev/net-next/c/859b4dfa4115
  - [net-next,v2,8/9] igc: Enable RX via AF_XDP zero-copy
    https://git.kernel.org/netdev/net-next/c/fc9df2a0b520
  - [net-next,v2,9/9] igc: Enable TX via AF_XDP zero-copy
    https://git.kernel.org/netdev/net-next/c/9acf59a752d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


