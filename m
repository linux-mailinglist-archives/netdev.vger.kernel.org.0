Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6450135FC1B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245471AbhDNUAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhDNUAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:00:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C113761166;
        Wed, 14 Apr 2021 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618430410;
        bh=zNJDlMl/JojQyQaGm9JKhWr/2Pc3O8ZvEXp8dLTmwFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F3v2bP7IiOYgc0cCmwuv0dzoRHRfQHS6zRBSZnO3rXAic/EKnJw/vQ2JkqSUwT5My
         /PlC2slzVTueClqWwKghywwhjMP7WnOFKZLD7pf4H2xtzDRMQb9gfSzRFbZVn2hWcs
         2tmejmXvLfdmXqhspWsEpbsXvk0W4Jo+otc05b0emUWc8oajoVITMevThE9KV8wcxp
         qJczdwKSJok/5P2oy265rOfQt2mDjEjDYoQnh0DVz4VWUjKZmAI+ufZCMvrm0DR2Ri
         VRKhZt5axuTM8aWQYxfiQMAKvDKaNqQdRXlk0w+iVeSzZWvu/ahGBCZDA4TVDMAemp
         7Imn5Fv2+bDzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B356460CD2;
        Wed, 14 Apr 2021 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: phy: marvell-88x2222: a couple of
 improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843041072.5559.7785682129967602858.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:00:10 +0000
References: <cover.1618347034.git.i.bornyakov@metrotek.ru>
In-Reply-To: <cover.1618347034.git.i.bornyakov@metrotek.ru>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     system@metrotek.ru, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 23:54:49 +0300 you wrote:
> First, there are some SFP modules that only uses RX_LOS for link
> indication. Add check that link is operational before actual read of
> line-side status.
> 
> Second, it is invalid to set 10G speed without autonegotiation,
> according to phy_ethtool_ksettings_set(). Implement switching between
> 10GBase-R and 1000Base-X/SGMII if autonegotiation can't complete but
> there is signal in line.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: phy: marvell-88x2222: check that link is operational
    https://git.kernel.org/netdev/net-next/c/58581478a734
  - [net-next,v2,2/3] net: phy: marvell-88x2222: move read_status after config_aneg
    https://git.kernel.org/netdev/net-next/c/473960a7b443
  - [net-next,v2,3/3] net: phy: marvell-88x2222: swap 1G/10G modes on autoneg
    https://git.kernel.org/netdev/net-next/c/d7029f55cc46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


