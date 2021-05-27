Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F8139390E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbhE0XVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234964AbhE0XVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A9DC9613D1;
        Thu, 27 May 2021 23:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622157603;
        bh=ry+JQMwBmkgtydIGEi9PPgFj+6BA75npvy1znXP09x8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iQGR+XRbHwUuFWjc7vCTxLBQE+8C4I84kcpIFfp/gBabzbo2CLm7OhSZapv8xP7zE
         SoQ6wSQYNz+laoLYoWwWiVef69vMuvJU2HZJ/AK6fYvk+Ri60kFZ/EAIbSd9Urh0g4
         7BHR0Z09lAXudxqHYcc3xeslWPH1v/sGBsSaO+KGeMzxoJoNRs5CIfZ0IuVzZx+Hh3
         aq53cCBLbiZr0vbvtBatusoa5QoLMmBxSoV9hY38zl/yDySJ6cQbWx+RbbJX6b3EYk
         /pRDmpBJLe8DACWaPtSDaKImNSZK4j4Ijqc735DZmDo5Dt7rv+Mszyl16BFoh2eqgr
         gggxPoF814xZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9DCBA60BE2;
        Thu, 27 May 2021 23:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] ixgbe: Fix out-bounds warning in
 ixgbe_host_interface_command()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215760364.28406.5788806806240071330.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 23:20:03 +0000
References: <20210527173424.362456-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210527173424.362456-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        netdev@vger.kernel.org, sassmann@redhat.com, keescook@chromium.org,
        david.switzer@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 27 May 2021 10:34:24 -0700 you wrote:
> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> 
> Replace union with a couple of pointers in order to fix the following
> out-of-bounds warning:
> 
>   CC [M]  drivers/net/ethernet/intel/ixgbe/ixgbe_common.o
> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c: In function ‘ixgbe_host_interface_command’:
> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3729:13: warning: array subscript 1 is above array bounds of ‘u32[1]’ {aka ‘unsigned int[1]’} [-Warray-bounds]
>  3729 |   bp->u32arr[bi] = IXGBE_READ_REG_ARRAY(hw, IXGBE_FLEX_MNG, bi);
>       |   ~~~~~~~~~~^~~~
> drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:3682:7: note: while referencing ‘u32arr’
>  3682 |   u32 u32arr[1];
>       |       ^~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] ixgbe: Fix out-bounds warning in ixgbe_host_interface_command()
    https://git.kernel.org/netdev/net-next/c/eefa5311c3f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


