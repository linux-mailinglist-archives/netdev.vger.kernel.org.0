Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E3246DFF3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhLIBDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:03:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45286 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbhLIBDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:03:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7834B82269
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3DE5C341C6;
        Thu,  9 Dec 2021 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639011610;
        bh=xuUgdui0BmIA+2o8pnH/1KPNJSqyGxL7cVmEgNN/NnY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yiyl18PwBSDvCMrZAZI9UWqkd+DYp14cE83bJ8tBIlRX4p+/hiUSmEPZ+qgkdlchw
         rq/uifBK5X177DSVlH19CnTXQ9314Z3pE9GRk3QKcCwjzU0gpHtHwWl5tzklZNNls7
         0UmlQH80/NIZ3lf0NCt+yeYE4ZU7pO7I8dUVp1Fi7DFHb0yzV42a/vhFHKjBZpiAcP
         lphgrhpNL+Kh0Fx4HSkNm80y0szrrLJ6pYQiEPqdaIudy7dzOKfFeXZicTe79YKdvs
         7lHk/2ME1KL3Rc9G76vIZqBA+8lCL4V5QIl2rpcMZhs4q6noKzEqexkTjnTt1K0SSm
         Ap6LNBkk5K7Wg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D9AB609D7;
        Thu,  9 Dec 2021 01:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/7][pull request] Intel Wired LAN Driver Updates
 2021-12-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163901161057.25580.18235231892141104375.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 01:00:10 +0000
References: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed,  8 Dec 2021 13:11:37 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Yahui adds re-initialization of Flow Director for VF reset.
> 
> Paul restores interrupts when enabling VFs.
> 
> Dave re-adds bandwidth check for DCBNL and moves DSCP mode check
> earlier in the function.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/7] ice: fix FDIR init missing when reset VF
    https://git.kernel.org/netdev/net/c/f23ab04dd6f7
  - [net,v2,2/7] ice: rearm other interrupt cause register after enabling VFs
    https://git.kernel.org/netdev/net/c/2657e16d8c52
  - [net,v2,3/7] ice: Fix problems with DSCP QoS implementation
    https://git.kernel.org/netdev/net/c/6d39ea19b0fb
  - [net,v2,4/7] ice: ignore dropped packets during init
    https://git.kernel.org/netdev/net/c/28dc1b86f8ea
  - [net,v2,5/7] ice: fix choosing UDP header type
    https://git.kernel.org/netdev/net/c/0e32ff024035
  - [net,v2,6/7] ice: fix adding different tunnels
    https://git.kernel.org/netdev/net/c/de6acd1cdd4d
  - [net,v2,7/7] ice: safer stats processing
    https://git.kernel.org/netdev/net/c/1a0f25a52e08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


