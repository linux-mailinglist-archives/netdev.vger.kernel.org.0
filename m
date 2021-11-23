Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B2745A272
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhKWMXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236950AbhKWMXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 319CE61059;
        Tue, 23 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670010;
        bh=FByJjHBHP4GP4unvEkFsQTrtBWUAfXpkJ5xHO0fOVo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qcPHoFlU49k2oGAOIN1UMAqHQDigOU4AOiJxAVvJBMFx3Nm2Ww1uJpc+OYqQ/JWrJ
         rsla5DlDgcsH+zZ5efk9jJcM6e3cxxZqLgaHaVe219OW9IYdvHbhA964DCXCuoBozS
         OFFvoxwh4qx+cLtemWn+Z4+xiE7w19MGNNOMViK1Eub5Hj6K1TH/KzCDS0ajNNr4HK
         4xXIAum6kszxdS0NlB47es9dBksOhO2530K+9uRcJPTJMEwpT5KhfsP65XuFIaFXUQ
         btRo1HVOvrsZB12Gl+CESOUAEzDYVBF6n0g0s4hdE/w8rhgNkA9ha6SfEfmU/74lM9
         HyC6ivq+LNM0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 25BB8609BB;
        Tue, 23 Nov 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2021-11-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001014.10565.1715922992675329504.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:10 +0000
References: <20211122184522.147331-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211122184522.147331-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 22 Nov 2021 10:45:20 -0800 you wrote:
> Maciej Fijalkowski says:
> 
> Here are the two fixes for issues around ethtool's set_channels()
> callback for ice driver. Both are related to XDP resources. First one
> corrects the size of vsi->txq_map that is used to track the usage of Tx
> resources and the second one prevents the wrong refcounting of bpf_prog.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: fix vsi->txq_map sizing
    https://git.kernel.org/netdev/net/c/792b2086584f
  - [net,2/2] ice: avoid bpf_prog refcount underflow
    https://git.kernel.org/netdev/net/c/f65ee535df77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


