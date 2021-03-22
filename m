Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10860345325
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhCVXkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhCVXkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 19:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A6F0D619A4;
        Mon, 22 Mar 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616456411;
        bh=dJKj8nPl3zrdIA+jMRqT92my/PHfJDgmMKyf+Wj3A9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aF7wjxKOF8aN8oLprA48jPomJwm4v6pEQ/HsSEptPA9zVp+X8Q2XrnD5JoFb3azQv
         AyECEDwn00lSwRUIAh7z9KqiUp5CzCnvXy1cBZxfvr1V01+ZLuGiOpNXt8OSaLE2W2
         qQFZkI2yBpBcixHen2w87VzhKn2QSCHfOrpFPj/AUBMkRKBARk25oSJdLAVgJfIg07
         cmUkdPg0kZ1br6HlI3+5excRkJD5Bfbt0lNB7nNj61ba9cDE7XFEvmSBI61B25XA1Z
         k83v1WYGpm7jMe+6ygurU0sdKOIjjgK9cQ299MIf+teyDSxASonrt4nDK3eXxIITt3
         GgZdzz2AHEtsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 990CD609E8;
        Mon, 22 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/3] net: dsa: lantiq: add support for xRX300 and xRX330
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645641162.10796.16297619759185688700.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 23:40:11 +0000
References: <20210322203717.20616-1-olek2@wp.pl>
In-Reply-To: <20210322203717.20616-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 21:37:14 +0100 you wrote:
> Changed since v3:
> 	* fixed last compilation warning
> 
> Changed since v2:
> 	* fixed compilation warnings
> 	* removed example bindings for xrx330
> 	* patches has been refactored due to upstream changes
> 
> [...]

Here is the summary with links:
  - [v4,1/3] net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330
    https://git.kernel.org/netdev/net-next/c/a09d042b0862
  - [v4,2/3] net: dsa: lantiq: verify compatible strings against hardware
    https://git.kernel.org/netdev/net-next/c/204c7614738e
  - [v4,3/3] dt-bindings: net: dsa: lantiq: add xRx300 and xRX330 switch bindings
    https://git.kernel.org/netdev/net-next/c/ee83d82407e4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


