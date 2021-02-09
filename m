Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415A0315766
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhBIUDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhBITv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:51:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 63A7564ECE;
        Tue,  9 Feb 2021 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612898407;
        bh=Ag6ngtBLNcr5W3W2ZhyaxIFxZRehHu2yFQtC+iFqfnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bSCwYu/Tczljjhmy+VOUIWUORer/SonFoC0tisxzsOoi2A0AP4ST6MD0yGwC6FA5b
         ADu/WLU9BKYir2NY7Dip4e5xFgzyMYL7qszOkMJegfO+gTWNyHbVbzA27Sjjz2ZcB0
         NoGJyNdk7fU/7RNw2fJnz1u/Awm1RVGw/cngL+sr/iM9zAe1OgHS4ZTdlK9RsZ54Zo
         wjwyaxR+v65nDk/AYiolPjQwr0lKUuG9N4kvGp3XkaGPSdXL6OMndBwC8g26r+4NHO
         dT+d3OuDtBEn6oqa2Y0/WTxGXhb5kZL1B6Pgi1OEnj1rPn6wWLvG5i9hj1RhAKrbfk
         VASnZQ+jdwsKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 56504609E9;
        Tue,  9 Feb 2021 19:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: drop explicit genphy_read_status() op
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161289840734.9558.17277530994129501760.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 19:20:07 +0000
References: <20210209010018.1134-1-michael@walle.cc>
In-Reply-To: <20210209010018.1134-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  9 Feb 2021 02:00:18 +0100 you wrote:
> genphy_read_status() is already the default for the .read_status() op.
> Drop the unnecessary references.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/marvell.c | 1 -
>  drivers/net/phy/micrel.c  | 1 -
>  2 files changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: drop explicit genphy_read_status() op
    https://git.kernel.org/netdev/net-next/c/f15008fbaa33

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


