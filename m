Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA453EBEFF
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 02:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbhHNAaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 20:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235776AbhHNAad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 20:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 70B9D610FF;
        Sat, 14 Aug 2021 00:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628901006;
        bh=FRDgaUPmWkcZ+kT7qqTy5+zn7xCaZH9oBYVJGnyqFnY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ic66SUHo/R6aGDKp0kgmfaHc7Ry8oDliJWyDGbdquuN2byHHTl3PTPpKuuAGiVmC0
         39Vaj+v79TQ+wXNhd8UGqaNJkJkTnG8GpoPNhR/kHMElDeVbgTARowJ+osmRbfaxG/
         zHSKeSeeyt1h00e0l51X8O9FL+b25lZ6MCK5uOWoHjXqEGUHSZGKEGq39+hBvhSrkD
         J/iY2Ac9e5eoDTSxptMZYOMyl6kt6tXVGZLV74as2gk4H9c4zfaYqC5mv9D7V7xkoe
         thLM3jaXscuocZZpmGDgieKZv8S6pfONNGWKdJgwXKdnxWLBg3XUcpSylU4Pd1uuhY
         LkoroPTQoih0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 67E51609AF;
        Sat, 14 Aug 2021 00:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: marvell: add SFP support for 88E1510
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162890100642.6872.17258777970674718027.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Aug 2021 00:30:06 +0000
References: <20210812134256.2436-1-i.bornyakov@metrotek.ru>
In-Reply-To: <20210812134256.2436-1-i.bornyakov@metrotek.ru>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     system@metrotek.ru, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Aug 2021 16:42:56 +0300 you wrote:
> Add support for SFP cages connected to the Marvell 88E1512 transceiver.
> 88E1512 supports for SGMII/1000Base-X/100Base-FX media type with RGMII
> on system interface. Configure PHY to appropriate mode depending on the
> type of SFP inserted. On SFP removal configure PHY to the RGMII-copper
> mode so RJ-45 port can still work.
> 
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: marvell: add SFP support for 88E1510
    https://git.kernel.org/netdev/net-next/c/b697d9d38a5a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


