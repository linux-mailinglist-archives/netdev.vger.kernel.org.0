Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DEE426EFE
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhJHQcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 12:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhJHQcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 12:32:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 572EB6112D;
        Fri,  8 Oct 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633710609;
        bh=FTxRlTntu5K5YNVIbQ3cAkXegy71z12iSwE95SNoEQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l+eRfJFlfHw47ATA2n1fNdzV8GAb9M3Xy3HS5wywoaMHmS1TtptPL7HFwMigFasrI
         kS7SPgiP+1/x/ge3a02quwmv00BNRRKb96w+vPJ9UhgzmBvYFE+K10A52lMuMsO0hQ
         bKGFlYqVIxOi3Zhzcv+tBCTgZlBk6d0BHSbwUVJCmTDh2UDiDzaiA29sy4KeNIvkkN
         CKVrNT4Lt5i1tnjHNk+qIKAnb0DxXCjnKIW633G2BaTdBpTDqWKgOu6PYzqDAUee6z
         pAwTWC2Sbe+lMdCFHtYa9evjWR7j9dLFXXZGw7twDJH5949ojXZTIGH3BMIsst/52w
         XH8brTA6AFUmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4CCEA60985;
        Fri,  8 Oct 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: micrel: ksz9131 led errata workaround
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163371060930.30754.174261751564488049.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 16:30:09 +0000
References: <20211007164535.657245-1-francesco.dolcini@toradex.com>
In-Reply-To: <20211007164535.657245-1-francesco.dolcini@toradex.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        philippe.schenker@toradex.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 18:45:35 +0200 you wrote:
> Micrel KSZ9131 PHY LED behavior is not correct when configured in
> Individual Mode, LED1 (Activity LED) is in the ON state when there is
> no-link.
> 
> Workaround this by setting bit 9 of register 0x1e after verifying that
> the LED configuration is Individual Mode.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: micrel: ksz9131 led errata workaround
    https://git.kernel.org/netdev/net-next/c/0316c7e66bbd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


