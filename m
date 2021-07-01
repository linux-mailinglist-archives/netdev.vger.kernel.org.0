Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC4B3B9853
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 23:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhGAVwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 17:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhGAVwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 17:52:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5CBC161410;
        Thu,  1 Jul 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625176205;
        bh=cGOMZByQqCqoeZqutFl15vu2klspjkouf3L+jbu4U9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t6NKyIdTxQrb3tKfCcG7GH8NGKvF3urg0Opgxv+MZ7Fnerq/Jtx+mfhbdwvE6jlnA
         L6oxESbre4PqKJc22nSmVVAoIaZnS1ZG4+MN8LI6KGEJi96tCv19JTNznt8ve/AZRY
         hM2miH6xtCJizql8F9zQqSW7c5lWEk/+7OIP7k1gMP4xcEVAKdAWne+yTR6zHkP2Xp
         0lop6/oyJijYkvZiTzZKRIb/DsctHTs/DGs6sT2i1g91KtQww9z6/oHYSn2q726whj
         uV0RENSbOEgc6NYhWfcP5UYikGPPtF4ot8Fpu2xAY/gkN9onVpziPFsbyQby767rLb
         tGWFtB61hAvIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 49EA660A38;
        Thu,  1 Jul 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 00/11][pull request] Intel Wired LAN Driver Updates
 2021-07-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517620529.8715.10997019866052168999.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 21:50:05 +0000
References: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Jul 2021 11:04:09 -0700 you wrote:
> This series contains updates to igb, igc, ixgbe, e1000e, fm10k, and iavf
> drivers.
> 
> Vinicius fixes a use-after-free issue present in igc and igb.
> 
> Tom Rix fixes the return value for igc_read_phy_reg() when the
> operation is not supported for igc.
> 
> [...]

Here is the summary with links:
  - [net,01/11] igc: Fix use-after-free error during reset
    https://git.kernel.org/netdev/net/c/56ea7ed103b4
  - [net,02/11] igb: Fix use-after-free error during reset
    https://git.kernel.org/netdev/net/c/7b292608db23
  - [net,03/11] igc: change default return of igc_read_phy_reg()
    https://git.kernel.org/netdev/net/c/05682a0a61b6
  - [net,04/11] ixgbe: Fix an error handling path in 'ixgbe_probe()'
    https://git.kernel.org/netdev/net/c/dd2aefcd5e37
  - [net,05/11] igc: Fix an error handling path in 'igc_probe()'
    https://git.kernel.org/netdev/net/c/c6bc9e5ce5d3
  - [net,06/11] igb: Fix an error handling path in 'igb_probe()'
    https://git.kernel.org/netdev/net/c/fea03b1cebd6
  - [net,07/11] fm10k: Fix an error handling path in 'fm10k_probe()'
    https://git.kernel.org/netdev/net/c/e85e14d68f51
  - [net,08/11] e1000e: Fix an error handling path in 'e1000_probe()'
    https://git.kernel.org/netdev/net/c/458907560842
  - [net,09/11] iavf: Fix an error handling path in 'iavf_probe()'
    https://git.kernel.org/netdev/net/c/af30cbd2f4d6
  - [net,10/11] igb: Check if num of q_vectors is smaller than max before array access
    https://git.kernel.org/netdev/net/c/6c19d772618f
  - [net,11/11] igb: Fix position of assignment to *ring
    https://git.kernel.org/netdev/net/c/382a7c20d925

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


