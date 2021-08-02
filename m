Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9584E3DDD76
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhHBQUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230265AbhHBQUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F27B960FC1;
        Mon,  2 Aug 2021 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627921206;
        bh=Yv6GiKzovgvY4BupnBuaNGO2kjtQHYIoI4v4ZNWyTe8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ktJjajctVuMcbdQ4eqqD0jlvMaIOjsfY+Blbp9H819CMQlG21ew4X1BsQswBuBIwy
         EmxYgmy7SJIFZUicTMN/QZz76Kuhxvg+uOxddf7Bjsq4wHQwK+YBSwrRK+ivF+4Xo7
         DXrBRFDLhzC6f2FL9HSjpApnMOeSbXNC5F5yyhaaM7MB4L4vhhjcfT0ZIDjJphtTpT
         SgtXFi+D0LROZDjLtR/c0wgvvW7r4mu889aPOcIwgUUaCd26d/+uuR75OsSn9LTkzF
         hu077RTTBBz+pmqnHDx25J0sPwZqJChaqrefRjevvyH7B+bcmvzt1GSWNknkLQYvlf
         bS47DpwgvlQ+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E5FB760A44;
        Mon,  2 Aug 2021 16:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: mscc: make some arrays static const,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162792120593.11903.14519905240994948263.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 16:20:05 +0000
References: <20210801070155.139057-1-colin.king@canonical.com>
In-Reply-To: <20210801070155.139057-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, atenart@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 08:01:55 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate arrays on the stack but instead them static const.
> Makes the object code smaller by 280 bytes.
> 
> Before:
>    text    data     bss     dec     hex filename
>   24142    4368     192   28702    701e ./drivers/net/phy/mscc/mscc_ptp.o
> 
> [...]

Here is the summary with links:
  - net: phy: mscc: make some arrays static const, makes object smaller
    https://git.kernel.org/netdev/net-next/c/1187c8c4642d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


