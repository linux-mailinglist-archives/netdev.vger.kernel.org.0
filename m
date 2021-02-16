Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2133B31D2F7
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 00:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhBPXKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 18:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhBPXKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 18:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 87A3A64EAD;
        Tue, 16 Feb 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613517007;
        bh=Eq41VV0K63rChAVSba6vpdNm1alP2l4zHv8InnFdIGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pw1K045DLqLgdS9PkYU68z/Xi43FseZMUthI0xY0xI3sKTBz9n9TaQF3y/01NWLOy
         9RzLx8WfmTC8fvMnvL007Qze0Fcv+BqStFDyMWPlrh/49iwlMQ8P7kh9yWPnIXM0Q5
         Rybjli6dwRAovJD5Cv6Zl1UqCBuLy7C8bysetDhwraday7Ung5VndJICS2P27NDLBe
         FSmgYb80+5eulENg5pVqJPVltE2xXXWATNedvZy50/fI/4zeWW2oQoEAC1fywA5Qvf
         yxcXeSPQdl4NrzKlAAT8F55Bwq4KmxkxsImHxfYpHcYL00C1D0foGpEHcOdtG1YWVu
         uLpPFquHNJaeA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 78CD1609EA;
        Tue, 16 Feb 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net,v2, 0/4] Bug fixes to amd-xgbe driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351700749.13890.12362976596726053509.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 23:10:07 +0000
References: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
In-Reply-To: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Sudheesh.Mavila@amd.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 17 Feb 2021 00:37:06 +0530 you wrote:
> General fixes on amd-xgbe driver are addressed in this series, mostly
> on the mailbox communication failures and improving the link stability
> of the amd-xgbe device.
> 
> Shyam Sundar S K (4):
>   net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout
>   net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
>   net: amd-xgbe: Reset link when the link never comes back
>   net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP
> 
> [...]

Here is the summary with links:
  - [net,v2,1/4] net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout
    https://git.kernel.org/netdev/net/c/30b7edc82ec8
  - [net,v2,2/4] net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
    https://git.kernel.org/netdev/net/c/186edbb510bd
  - [net,v2,3/4] net: amd-xgbe: Reset link when the link never comes back
    https://git.kernel.org/netdev/net/c/84fe68eb67f9
  - [net,v2,4/4] net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP
    https://git.kernel.org/netdev/net/c/9eab3fdb4199

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


