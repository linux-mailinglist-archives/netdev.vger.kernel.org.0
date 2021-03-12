Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA9433824D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCLAaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230159AbhCLAaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 19:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CEB464F8E;
        Fri, 12 Mar 2021 00:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615509008;
        bh=vCCVtCGWu7DXYjzzXma/pY/7DvIQAFzR+Zc+7C/NWiE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bk1wCXMUNQ422ESR8Nod9O/L2u5tSK1CAod9jW6kNkyWRIJTiRw4A8e9n+mOm90iV
         mfjYHymrQhYFmk0Shg6X3kt/3g5q4Co3QSGf1z1zO7R6tr9hORYIqKWYwMYfirgr0r
         DUKHYLlzy3nODu9/edNVtM1Bc/+Ac669g7XY/cEZd9B5wWj55sltvmAc+f/jfPxjdY
         vsapctBIjIMNukv6IXeya1LIuaEaRHdGhiuL6tljxGfD/pvAVvgJ7hU0RakHA139J2
         xCuCqDiSCWsnvxbrjMXAr594HJfHjL/54UjvQcsnK2+/06QfRjrBF45qTsiXDSA7Cp
         gsoak5LN9kDnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7DDBF609E7;
        Fri, 12 Mar 2021 00:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates
 2021-03-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161550900851.18262.6428558056496850630.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 00:30:08 +0000
References: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Mar 2021 10:09:09 -0800 you wrote:
> This series contains updates to igc and e1000e drivers.
> 
> Sasha adds locking to reset task to prevent race condition for igc.
> 
> Muhammad fixes reporting of supported pause frame as well as advertised
> pause frame for Tx/Rx off for igc.
> 
> [...]

Here is the summary with links:
  - [net,1/6] igc: reinit_locked() should be called with rtnl_lock
    https://git.kernel.org/netdev/net/c/6da262378c99
  - [net,2/6] igc: Fix Pause Frame Advertising
    https://git.kernel.org/netdev/net/c/8876529465c3
  - [net,3/6] igc: Fix Supported Pause Frame Link Setting
    https://git.kernel.org/netdev/net/c/9a4a1cdc5ab5
  - [net,4/6] igc: Fix igc_ptp_rx_pktstamp()
    https://git.kernel.org/netdev/net/c/fc9e5020971d
  - [net,5/6] e1000e: add rtnl_lock() to e1000_reset_task
    https://git.kernel.org/netdev/net/c/21f857f0321d
  - [net,6/6] e1000e: Fix error handling in e1000_set_d0_lplu_state_82571
    https://git.kernel.org/netdev/net/c/b52912b8293f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


