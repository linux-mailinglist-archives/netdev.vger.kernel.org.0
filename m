Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F05537037F
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 00:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhD3WbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 18:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231790AbhD3WbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 18:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3176861482;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619821811;
        bh=hfd720EHKL3KrtuPg+v2ZLEJkDymGK5uGg1H/mVznaw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ABCySdkzpnXsvnxC51zqrE7a6JMjoMGPIK48fit/ultd46ng+zJA4NV240MequfMt
         e+b7W+o56d6YCXBg7lZCxKlZUaNtK8ZcbG8Wp2tbhbzShUk+03AFzt+hiFmd1br3iP
         kOAMs4nq88hV4fGgRtB8IXDNAXL6YNYbmiKw8espMIvrBoaZigTH32OWDVwcr8iBKX
         bcpd162baBqxvcKMtJj0fZOfitE6rNxwJ3AHI2uoZ4R1Ey3u8x5wZMtuzRTflILZ15
         IZRGAovNCLfFRGAkkOVNzkjwd1b77OZfjpnzq6aoiEszh13ok9IXHmKvppnzhhojsg
         1NQvcblrJl/rQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 27F6760A3A;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] net: phy: marvell: enable downshift by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161982181115.1234.13266423683015766676.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Apr 2021 22:30:11 +0000
References: <20210430045733.6410-1-fido_max@inbox.ru>
In-Reply-To: <20210430045733.6410-1-fido_max@inbox.ru>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Apr 2021 07:57:33 +0300 you wrote:
> A number of PHYs support the PHY tunable to set and get
> downshift. However, only 88E1116R enables downshift by default. Extend
> this default enabled to all the PHYs that support the downshift
> tunable.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> 
> [...]

Here is the summary with links:
  - [v2,1/1] net: phy: marvell: enable downshift by default
    https://git.kernel.org/netdev/net/c/8385b1f0ad0d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


