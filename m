Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D0B31C3B6
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBOVkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:32870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhBOVkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 16:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A94D64DFF;
        Mon, 15 Feb 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613425207;
        bh=DOlRn5h3P1TfYOlplomAz4cTWP0S0UZfSaaFiWRTmpM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=INe5vpLtzjz90KkoO8HuO4ibNq1RnLH7vzHzlGj+o4qfoW/MS1e+OCWQmDbnak3yR
         YBKhXqNxMMtyGz2RSsnUj1U0MDaIbPRD6tCA2mvs4ZaM4q8fqYBf7PvOoGEAQnc2oj
         zb9Llt7XtMFhY3c2jtsjINc0DI4ewPiKLYkQAtMtVxakCwsaJflF40gKM9RoyxDIO8
         iumr3dmZbhPKEUuU4ONHGxXoUTa7l3wCEkeOTv8L/J8Al4L/S/xdcuahYpkhXdZURx
         GQs8yBn9XrbKlAmzRhsqLeGqFXFZp55q3uPlXsHxfyQ5e2cEd72ARER8Vy10gS11+S
         s+t8ZKosJ3M1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5643860977;
        Mon, 15 Feb 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] net: mvpp2: reduce tx-fifo for loopback port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342520734.31720.7249924080168567340.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 21:40:07 +0000
References: <1613311803-17806-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1613311803-17806-1-git-send-email-stefanc@marvell.com>
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

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Feb 2021 16:10:03 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> 1KB is enough for loopback port, so 2KB can be distributed
> between other ports.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvpp2: reduce tx-fifo for loopback port
    https://git.kernel.org/netdev/net-next/c/7c29451550cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


