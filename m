Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0996380084
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 00:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhEMWvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 18:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230395AbhEMWvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 18:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 155BC613F5;
        Thu, 13 May 2021 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620946210;
        bh=Kqpb1imWQ/L4iLhNSrovMt1uzUHkYthUt0su9xst6Kk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Owq80Tc4CBss+wxfXuXwxdAk9s2ZQxHK8/ymBtF7VmbleCQB2le98WC8XtQDlBA9R
         vfPfWyCBxI64g9CsVhk2D4bNLWpHReKq3PT5Jcsx/ayl4r3cJ7EH1XlyjGH/sEFqw0
         MuWzhAATmFAtUt+GowHX46MqhyIa4Xx6U4iHNuHGW1Yaq8tUOCa6W5SkqtMp3VqVRG
         cFkRDYcZipbGrdh9zNRql7IcT0usHqxo1/zbxhSKhpkGPQyYL2u5bo4bR7Su34HaQV
         M9gwo1aQRuejP6nCWND1s5HmxNLa/x/DkeThOSehUc1xB5o4YP0It2+Z52gAs0MYX4
         oeDt/TLBy1iAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07F7260A2C;
        Thu, 13 May 2021 22:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdio: octeon: Fix some double free issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162094621002.964.6124473198143369676.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 22:50:10 +0000
References: <7adc1815237605a0b774efb31a2ab22df51462d3.1620890610.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <7adc1815237605a0b774efb31a2ab22df51462d3.1620890610.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 13 May 2021 09:24:55 +0200 you wrote:
> 'bus->mii_bus' has been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.
> 
> Remove the incorrect 'mdiobus_free' in the error handling path of the
> probe function and in remove function.
> 
> [...]

Here is the summary with links:
  - net: mdio: octeon: Fix some double free issues
    https://git.kernel.org/netdev/net/c/e1d027dd97e1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


