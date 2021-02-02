Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B249630C69A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhBBQxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236879AbhBBQut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6680C64F8C;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612284607;
        bh=1pyS1O/tfQWwIdEuctiuv1WSn/cICDq2gO6ZI5MLyZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qt+bYOoaif+OB/INxcPDne0PeMVbxxORuDpNI16pbNOCCU4a5tZO5vvLS03z5jveX
         G+Bafubjefm+jxrIXV/LLBvJJ1dlbTE/zFrmH+gWJFNTYiOvPr2acASlyDvPfizQdx
         ozHjlJ/igtTdoamKzZ7Zap5VGKntlfdpGdyx3jpH/uesYIftYG3HEx+LYDWtOkx+1E
         MRLqH2573UW9iEKCNpmiUdHQlggyORBwu29gY6WZNCpqMWmJ4Av/0ghsw2pSGkdq1y
         W3tkKlIEWlxIT5dxLb3T2AjEN8vvJ9Kr5EZ7dksAAzxzMZ70lGVHX311Lna1tmYlK8
         euCa+Je5VO2Uw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5ECD3609D9;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161228460738.23213.13014448307375459803.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 16:50:07 +0000
References: <20210201055706.415842-1-xie.he.0141@gmail.com>
In-Reply-To: <20210201055706.415842-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ms@dev.tdt.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 31 Jan 2021 21:57:06 -0800 you wrote:
> When sending a packet, we will prepend it with an LAPB header.
> This modifies the shared parts of a cloned skb, so we should copy the
> skb rather than just clone it, before we prepend the header.
> 
> In "Documentation/networking/driver.rst" (the 2nd point), it states
> that drivers shouldn't modify the shared parts of a cloned skb when
> transmitting.
> 
> [...]

Here is the summary with links:
  - [net] net: lapb: Copy the skb before sending a packet
    https://git.kernel.org/netdev/net/c/88c7a9fd9bdd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


