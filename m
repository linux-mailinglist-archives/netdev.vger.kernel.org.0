Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1818476F5B
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhLPLAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbhLPLAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E712C061574;
        Thu, 16 Dec 2021 03:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 373DDB82391;
        Thu, 16 Dec 2021 11:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4D40C36AE4;
        Thu, 16 Dec 2021 11:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639652409;
        bh=DmpsxA1aOWfSVsEX1ZVHYwKzS7MSlyxrPw+WW4awYRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gWmTwBc77miRI9RKKJMiITwfQ6jU5eRN5QgDHdSFFQhM2UeUj8ozaEPOy+k20gUP1
         5UX3aG9yDCt8LWMZvtPMa4dg86fATai7CYBpR6GUk7K0oWYz0XSXy24/jPiH+e7geY
         LxwkvEnQCDJiVdonbO8xqlvUFmVIE/H/0hIfFg1mwhv30yVg2epNAjGpOE/HjDZaP9
         7WGS6jyZN4zHR2WnUQaNJ9Ec9T9B6jTfEAqXHT43hOzv7XnGRHclvG8bp0dftw4jkL
         PoC9pqdsYIKPxO96OiAEE7S0ZEKkuB0Q3zegX5QnD9lbRgSVpTohdO8wLx/7550Zk/
         p7RO6uaX5BazQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C301360A39;
        Thu, 16 Dec 2021 11:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dsa: mv88e6xxx: fix debug print for SPEED_UNFORCED
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163965240979.2516.12545201602474755024.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 11:00:09 +0000
References: <20211215173032.53251-1-Axtone4all@yandex.ru>
In-Reply-To: <20211215173032.53251-1-Axtone4all@yandex.ru>
To:     Andrey Eremeev <Axtone4all@yandex.ru>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Dec 2021 20:30:32 +0300 you wrote:
> Debug print uses invalid check to detect if speed is unforced:
> (speed != SPEED_UNFORCED) should be used instead of (!speed).
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Andrey Eremeev <Axtone4all@yandex.ru>
> Fixes: 96a2b40c7bd3 ("net: dsa: mv88e6xxx: add port's MAC speed setter")
> 
> [...]

Here is the summary with links:
  - dsa: mv88e6xxx: fix debug print for SPEED_UNFORCED
    https://git.kernel.org/netdev/net/c/e08cdf63049b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


