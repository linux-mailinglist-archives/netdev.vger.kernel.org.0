Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB20C30C732
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbhBBRM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236884AbhBBQux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 86A3D64F94;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612284607;
        bh=12nSluOgQyJ2wv+7iGqSVWf+VHEp1BJBN9IbLXstS3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gx2559Rcea5jZEJTveoFOXapLkmrhuEdjyBXzv+cVq2X/Xiduc7jve3PKwllVXh2c
         uaHQYIR9pD9VeO3bhglOO6k8D5jfPW15QEDZ61mnlx9/IYaoD4CLJJ+cxeoSViDhGJ
         D/lpct4CgrJLusHRLa35aUvb1hkXQP/8IP7Aku3y6+sf2K7kSoEks6NeBeOPk4CP7e
         jfumXIs/mjkB/keNyCaiROZ3KzL9g9Fk2mwlj7PWSXFVnmpV1OyRIoTyi8CnrTC6cW
         mWJcYVArWyXUa5+imLdUbgy7UpmjIsTKVKbge8rrjF43oeghe4l0acTjD2AymFnkTA
         ifRJcs0l22xCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A5C8609E1;
        Tue,  2 Feb 2021 16:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mvpp2: TCAM entry enable should be written after
 SRAM data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161228460749.23213.3728583728115526378.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 16:50:07 +0000
References: <1612172139-28343-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612172139-28343-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 1 Feb 2021 11:35:39 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Last TCAM data contains TCAM enable bit.
> It should be written after SRAM data before entry enabled.
> 
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] net: mvpp2: TCAM entry enable should be written after SRAM data
    https://git.kernel.org/netdev/net/c/43f4a20a1266

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


