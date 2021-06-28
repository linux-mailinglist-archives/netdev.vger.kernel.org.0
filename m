Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC933B6B35
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbhF1XMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236597AbhF1XMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 19:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 09B5F61D01;
        Mon, 28 Jun 2021 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624921812;
        bh=2rdjFfPpzs1iyv+8aH8+ZkI0e3g7gL0TCE4bFWVURBc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cDfkRSxLezh8RqK1YvqIHHvmsOg9e9Tt/Rx+UE9vKFH84zVjSfs6Cp18upf/0Fczj
         Ny6ipBz8Bc585VqFhtzPSTJUXgNXfp1WN9WcLuPS9xro4eftMiagUBEJHUSxiu3eo0
         5iL46KsmPwa+z8k9QJ7v/AdWDKBlmC62dklO2St8KmjhenfLZCO7elJv+e8Itwp+1o
         Qx1gq91p29zvl6AJrcBOXfePqG4MPmPa2527uTYtIcfEY27PTKnugYxXJ1JXtSGvox
         51Gq6Eih80ejm2uekolMWHyTwQnqMaSqogPkOpWeo1z2HbrHeC8Pr420Qu97E9hje6
         ig+xYkrAhF/sA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F2CB560D32;
        Mon, 28 Jun 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sparx5: Do not use mac_addr uninitialized in
 mchp_sparx5_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162492181199.29625.1718309002563451532.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 23:10:11 +0000
References: <20210627184543.4122478-1-nathan@kernel.org>
In-Reply-To: <20210627184543.4122478-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 27 Jun 2021 11:45:43 -0700 you wrote:
> Clang warns:
> 
> drivers/net/ethernet/microchip/sparx5/sparx5_main.c:760:29: warning:
> variable 'mac_addr' is uninitialized when used here [-Wuninitialized]
>         if (of_get_mac_address(np, mac_addr)) {
>                                    ^~~~~~~~
> drivers/net/ethernet/microchip/sparx5/sparx5_main.c:669:14: note:
> initialize the variable 'mac_addr' to silence this warning
>         u8 *mac_addr;
>                     ^
>                      = NULL
> 1 warning generated.
> 
> [...]

Here is the summary with links:
  - [net-next] net: sparx5: Do not use mac_addr uninitialized in mchp_sparx5_probe()
    https://git.kernel.org/netdev/net-next/c/b74ef9f9cb91

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


