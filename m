Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AEF361444
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbhDOVke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236138AbhDOVkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 17:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6FD56610CD;
        Thu, 15 Apr 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618522809;
        bh=MD97mHpCELMRNdY1Tj+obi66BvPAhuNkCjhooouJqto=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EIP94x6uISavsXA99A7EK4WrUyoqK6ZMQ32rMgj51lAe831LD3e1kipiPrfdCfBon
         3fOoq2MnlCt9dekCg45mU/9075j/YCQ/R1emjLv7swqZSKQrJl1iJCCPxLKg4XiJ53
         jGKrBwlpdc56BIw7G2MLotklEY+0HpTj5ftfZn/nuuNXqJ9nYgdSfjA6v5lVSuhZi2
         rCdhwjLqpy1D6Qi8k1J9xOkGJos7Ua75ffF47y8t45fFNZsxNcYXP5SVxUgyYWhq2R
         iRgHyfXVJrE3ZIGIsa8VTNJr+SorMVDbtXhAD45nvB/JRLM439S1Igq7AeMg0uvYWs
         xWXsiP0vEanYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6511C60CD1;
        Thu, 15 Apr 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2021-04-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161852280940.6246.10024726306502706869.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Apr 2021 21:40:09 +0000
References: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 09:20:29 -0700 you wrote:
> This series contains updates to ixgbe and ice drivers.
> 
> Alex Duyck fixes a NULL pointer dereference for ixgbe.
> 
> Yongxin Liu fixes an unbalanced enable/disable which was causing a call
> trace with suspend for ixgbe.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ixgbe: Fix NULL pointer dereference in ethtool loopback test
    https://git.kernel.org/netdev/net/c/31166efb1cee
  - [net,2/3] ixgbe: fix unbalanced device enable/disable in suspend/resume
    https://git.kernel.org/netdev/net/c/debb9df31158
  - [net,3/3] ice: Fix potential infinite loop when using u8 loop counter
    https://git.kernel.org/netdev/net/c/ef963ae427aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


