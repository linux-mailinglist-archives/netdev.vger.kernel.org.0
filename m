Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D962F410B42
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhISLVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhISLVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7F95E6128E;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632050409;
        bh=Db2yX11B4jOmJCVVz2subuUWDOH0T1aHAUVLlMFpmpM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DjOhRZLq0Rq5UQWVE/qhDVlNLPdC692u6T9j1sVh5t4O7fwXGjRrevrl4J5IdYRl8
         BGeU1ysAGD+yBjYumkEfj4KQOqh4FGrG6OlHKDgP1S48b7fjoBY4ua7tYhQ4XNKMda
         No2AVSeFS1Pb6lhGwSGxKVHLM2JN3FqH33zgQIEUDvFuy3bUYlPJTQVdDBW7RyanDW
         z0dYhBN4lfdhokVcB4cx7nCakvXljaYdixePXjZpFFXdfPToCvk0YtFMzlKg+R9XZ7
         Br0PbOtzkMXsC2S36b8xgo8Joj4PXZtVoJ64EYr9AfDapJJVpGNDwtem/Ffd6biMlh
         Hje9DHfj0+W4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 788AD608B9;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next] net: dpaa2-mac: add support for more ethtool
 10G
 link modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205040948.14261.10514356075575619297.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:20:09 +0000
References: <E1mRE7B-001xlF-UX@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mRE7B-001xlF-UX@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, ioana.ciornei@nxp.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 14:41:17 +0100 you wrote:
> Phylink documentation says:
>   Note that the PHY may be able to transform from one connection
>   technology to another, so, eg, don't clear 1000BaseX just
>   because the MAC is unable to BaseX mode. This is more about
>   clearing unsupported speeds and duplex settings. The port modes
>   should not be cleared; phylink_set_port_modes() will help with this.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] net: dpaa2-mac: add support for more ethtool 10G link modes
    https://git.kernel.org/netdev/net-next/c/9eb7b5e7cb50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


