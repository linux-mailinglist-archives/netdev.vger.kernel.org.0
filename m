Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F0243E0B7
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhJ1MWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhJ1MWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D037B61107;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635423612;
        bh=Fnz99wqP5doTtIS32lW9F+vUJuYZtHWqNl96NGCM2Xs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f0lLWj8cGPq6gyFkMkryR81maJ2DWe05YVpuQpMwSQFqfCMxrwnE77SBg5k6JFTux
         hqFDbZyvB4cOAvE7uNslmfq1DJEzG3mWo/EbgxCDQnPwVu01SgEoiJ9HSqfcvsTtA8
         VvDTkoeezLlu89JH0a3YRQ3t/uafOfP9tQ5LnHmTqaKyK9bICO2+dSy69pG0tuOwst
         MSXHaA3hNBi6bxgtwSuePFDAXDCYMhmd7Li/URIdkz7FfTlnxU9jbqXrJ6Vgk3Qa9y
         2BmX2jOyZCZ7+BnudmoBewnfFn8QBziJGU50Sb31+Nq0PNV9Wcx97l+r8HBWSZnyv/
         WT6y5fkMaGrng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C379460A5A;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Convert mvpp2 to phylink supported_interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542361279.29870.7630012760671374717.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:20:12 +0000
References: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
In-Reply-To: <YXkgdrSCEhvY2jLK@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     mw@semihalf.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 10:48:38 +0100 you wrote:
> Hi,
> 
> This patch series converts mvpp2 to use phylinks supported_interfaces
> bitmap to simplify the validate() implementation. The patches:
> 
> 1) Add the supported interface modes the supported_interfaces bitmap.
> 2) Removes the checks for the interface type being supported from
>    the validate callback
> 3) Removes the now unnecessary checks and call to
>    phylink_helper_basex_speed() to support switching between
>    1000base-X and 2500base-X for SFPs
> 4) Cleans up the resulting validate() code.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: mvpp2: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/8498e17ed4c5
  - [net-next,2/4] net: mvpp2: remove interface checks in mvpp2_phylink_validate()
    https://git.kernel.org/netdev/net-next/c/6c0c4b7ac06f
  - [net-next,3/4] net: mvpp2: drop use of phylink_helper_basex_speed()
    https://git.kernel.org/netdev/net-next/c/76947a635874
  - [net-next,4/4] net: mvpp2: clean up mvpp2_phylink_validate()
    https://git.kernel.org/netdev/net-next/c/b63f1117aefc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


