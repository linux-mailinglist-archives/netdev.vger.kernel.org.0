Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B507455ACB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344256AbhKRLo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:44:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344267AbhKRLnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:43:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E5DCB61B95;
        Thu, 18 Nov 2021 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637235612;
        bh=gP2CBx1g4dh9Wx3oPVcjOfdOoIzcp9r7olf4LRu1V/c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hfv7AuuvCpKIz7ogMe3w7Fsqo85wOk8JBGFcPSRPpC0q6fNWcnTMFONLYsVoDRWAc
         0eSajxHvBijguaPVp9EGVVoMvxO2v3bPh46U/iHpFdInKvKSORnLPUkNT43yAk18iz
         gUYqyh0uf7qX5HMKWe/9BWAMwNNjgGB/MSfyjA0ZsG1pZjXmYE6fs7tWclU5qzeGXH
         BHdYtsgCaW1lBKd+lKCAW20keybhbMrbIkDRGrsx/ziNDHREEuljWVg8Yiq/bUD0/2
         I4JO+HRDdlKCC7196qEaVemYn1jjCpxr1cHN7eagPjCT6nbHbZs2rFHGvnVVrbyEzk
         1Uui0ZvPGLu9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DFF6760BE1;
        Thu, 18 Nov 2021 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/3] net: dpaa2-mac: populate supported_interfaces
 member
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723561191.11739.16574030660424088761.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:40:11 +0000
References: <E1mnOfC-0085Ij-MK@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mnOfC-0085Ij-MK@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 17:24:02 +0000 you wrote:
> Populate the phy interface mode bitmap for the Freescale DPAA2 driver
> with interfaces modes supported by the MAC.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 21 +++++++++++++++++++
>  1 file changed, 21 insertions(+)

Here is the summary with links:
  - [net-next,1/3] net: dpaa2-mac: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/15d0b14cec1c
  - [net-next,2/3] net: dpaa2-mac: remove interface checks in dpaa2_mac_validate()
    https://git.kernel.org/netdev/net-next/c/22de481d23c9
  - [net-next,3/3] net: dpaa2-mac: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/6d386f661326

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


