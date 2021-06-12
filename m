Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F223A5085
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 22:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhFLUWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 16:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLUWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 16:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 75AC961156;
        Sat, 12 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623529204;
        bh=FgnpdG6AYPjS5jbqTlZT9ZgVhDC6xQonY2AStbspRNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o3+bXzYJsjEmF9Qxm08ayZz0KZvfFu0iDnzzY4+56l6r0XnvfT9tik22slnAalPvY
         YtUcp+8kGShCouUlonjz39iL6C3hxFa6/cQ0l8HqhOFZNsjFubjPasPLqniO7xC4BN
         s/JQjrvHPWUYCE5WSqldLBkgO+sBPfKlmQHDEUbd0sZyG20v9Vf7x9wvtI8B9zEulN
         zjXvCw1ZNduh/Y6gedMLiv1wHfKOzg7pbQNK9jEC9ZBiPl9ircUkq6AqPqsHjwqxFe
         cR/pzGgxOGFTDb0+CwLnHU8xvI+IWDMvgccUpicaDo8fnqVPdbXx2fpWK/nThbWO6S
         b64XllEZpyvrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69F2A60CE2;
        Sat, 12 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Add 25G BASE-R support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162352920442.6609.17972913437151607132.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Jun 2021 20:20:04 +0000
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
In-Reply-To: <20210611125453.313308-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 14:54:49 +0200 you wrote:
> This series add the 25G BASE-R mode to the set modes supported.
> This mode is used by the Sparx5 Switch for its 25G SerDes.
> 
> Steen Hegelund (4):
>   dt-bindings: net: Add 25G BASE-R phy interface
>   net: phy: Add 25G BASE-R interface mode
>   net: sfp: add support for 25G BASE-R SFPs
>   net: phylink: Add 25G BASE-R support
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] dt-bindings: net: Add 25G BASE-R phy interface
    https://git.kernel.org/netdev/net-next/c/858252c9c346
  - [net-next,2/4] net: phy: Add 25G BASE-R interface mode
    https://git.kernel.org/netdev/net-next/c/a56c28686569
  - [net-next,3/4] net: sfp: add support for 25G BASE-R SFPs
    https://git.kernel.org/netdev/net-next/c/452d2c6fbae2
  - [net-next,4/4] net: phylink: Add 25G BASE-R support
    https://git.kernel.org/netdev/net-next/c/21e0c59edc09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


