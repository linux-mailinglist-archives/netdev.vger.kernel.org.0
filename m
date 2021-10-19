Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6651443357E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbhJSMMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230267AbhJSMMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB2746137B;
        Tue, 19 Oct 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634645408;
        bh=Js/yusGdN6RiTykwvXjKwPc4CDRRHNwYyzV2j8Zhjzs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e30H5OhRuERmERcjOtwBzUCkC1srieQm66bkhcU8bJVtnsMP9NEzRqO8aCSOa0ylg
         VCNFMC6+LATYyM8rudPhxsKxJ5/Hmpf6yKfeyYDmFwRxbRKJD0uWD/0MPULouP+Bte
         vdPxjFrzB3c+ZXhQcEHW30WiJr2TlbCpVPxlkxKPb74Y0pP/JSKryihCjIq8dnku9t
         twuwvOE8Hf0yj/Iy2vT0y6aAzAVzyysTW4/iXQqUdg8448so7VL3LcFUG0AIWi66R3
         91xpXZnshUVnjJ5huvECoytnAATrzgzKpnvjGe706J/8LTt4Fy/S1AlZfHE1wvC8eK
         T5VL8VK8po20g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9576960A2E;
        Tue, 19 Oct 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: rejig SFP interface selection in
 ksettings_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464540860.1998.9051211885557366177.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 12:10:08 +0000
References: <E1mclue-005LYy-Fd@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mclue-005LYy-Fd@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, nathan.rossi@digi.com,
        sean.anderson@seco.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 11:00:04 +0100 you wrote:
> Commit ea269a6f7207 ("net: phylink: Update SFP selected interface on
> advertising changes") added a better solution to selecting the
> interface mode for SFPs using the advertisement mask. This method will
> work for mvneta and mvpp2 when selecting between 2500base-X and
> 1000base-X without needing to use the basex helper, or indicate that
> we support both 1000base-X and 2500base-X when in either of these two
> interface modes.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: rejig SFP interface selection in ksettings_set()
    https://git.kernel.org/netdev/net-next/c/dc90604b5836

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


