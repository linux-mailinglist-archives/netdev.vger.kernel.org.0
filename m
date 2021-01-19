Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18AE2FAF7F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbhASEex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731401AbhASEat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4661522E00;
        Tue, 19 Jan 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611030609;
        bh=eL44+9rg0Zvxo5uHlVFjSlncbY6y8HAovdYXrosCplQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c2v+N7Yjr/rujoY+m8Di1qoHlAmTA5OPaXJxaA5CSMRvGnNNHrdo/8T/kb2QMNkbQ
         gBlHQo/du2vbfqnygykXKCFnp7T0Fd7z5iUAUKVe1nwzf9I1AOp8kaP0XWaxS+n7yR
         W+w9QQ6sK/OqeUi/VnbHYxd9yd3n5brurXLQLzskbF7+mmle1WMKQwI9hoRRfMe14M
         dMdjSkWhZeFH7DAg7tdVcOio0AGHJ6x/pkJvu6p2vwIgGMjQ+76qv5C8dpd7zVY1k9
         n9yUIHdV61fKQSh3OH/CIOYmGyv+eLkJZUUr1lGBpe2clo/iMoxWu3lwnB1u4sKP3f
         7sGwG66D3treg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 3EC0D604FC;
        Tue, 19 Jan 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: national: remove definition of DEBUG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161103060925.4335.15792230225258843308.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 04:30:09 +0000
References: <20210115235346.289611-1-trix@redhat.com>
In-Reply-To: <20210115235346.289611-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 15:53:46 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Defining DEBUG should only be done in development.
> So remove DEBUG.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> 
> [...]

Here is the summary with links:
  - net: phy: national: remove definition of DEBUG
    https://git.kernel.org/netdev/net-next/c/6ea9309acc28

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


