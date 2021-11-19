Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E09456E9B
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 13:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhKSMDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 07:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234587AbhKSMDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 07:03:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8540461AA7;
        Fri, 19 Nov 2021 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637323211;
        bh=Z7x8s5exMtoDdNvkBU90U5VejQ/Tirwb8NffZY2VRhQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nXS92AC/ZjkWmU07wHofvCD9jqSaVIiIpodybcOJih+HDXhN2Bvy/+wiTl+aHhejj
         3PjVfZooIlJ+akUNvrVrU2SHp/tWJ8YfCZfZCv1Jsnzlw+5yzmupoZsrDxnXurBxGj
         6vMYtpRLkwVGs9FA3RvvrSW1PbThZ+eCFQKkNahDtSieBMgP0GQBjFjSXgPDC6yCma
         pIxSb+1NNr2JKKTvD5lTzlxRLjZOIOhqJG3Szb1Hx3yzmV4uO2BaCvFsuOpLV3xxL3
         jklxyGOmwWDFYYEYQxICuq2eyGgpXGXtSF0O4CskeBOrfHzTSLUdOzPl1Wd1WGHVfD
         QRXDXLEovxS2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 72A98600E8;
        Fri, 19 Nov 2021 12:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: marvell: prestera: fix brige port operation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732321146.14736.13401179872116438988.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 12:00:11 +0000
References: <1637264883-24561-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1637264883-24561-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        ioana.ciornei@nxp.com, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, taras.chornyi@plvision.eu,
        vmytnyk@marvell.com, tchornyi@marvell.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 21:48:03 +0200 you wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Return NOTIFY_DONE (dont't care) for switchdev notifications
> that prestera driver don't know how to handle them.
> 
> With introduction of SWITCHDEV_BRPORT_[UN]OFFLOADED switchdev
> events, the driver rejects adding swport to bridge operation
> which is handled by prestera_bridge_port_join() func. The root
> cause of this is that prestera driver returns error (EOPNOTSUPP)
> in prestera_switchdev_blk_event() handler for unknown swdev
> events. This causes switchdev_bridge_port_offload() to fail
> when adding port to bridge in prestera_bridge_port_join().
> 
> [...]

Here is the summary with links:
  - [net,v2] net: marvell: prestera: fix brige port operation
    https://git.kernel.org/netdev/net/c/253e9b4d11e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


