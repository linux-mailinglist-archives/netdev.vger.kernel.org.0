Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C125345492B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbhKQOxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232209AbhKQOxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:53:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1529361BCF;
        Wed, 17 Nov 2021 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637160610;
        bh=nivLXWPIItXyELugbroJwojIvmx9DNTHps75iyew6ds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qCv9tMtXQl9uMfcw36EJUwvHrJrMM9yQAyWmkfQ56KA62PgyCiUg4fuXcygQvv4Xi
         mKoaie78OfHvi/1/m25ghghICWnGJUv8lEb1RBl6J6iWqs7O7po08gA4pS5xkDaJSk
         uJ22YtAYUfvjIoq1tc9axZa0ylmAbUKFeq4C2aoTCDtZP8euu6c9azvigg7KELA2vl
         dZu7XXBX7/X41pNuRC2AALDIxryPariyup6g9nJjsnOFYTtp8+TaL+W6jHK35iqVEF
         6KjXzXSb+ptUAkvsGiQaA1CvgmGlFPoNAf8nfgFG9FoWMmidoUVqvm1cJGOKx6jOef
         fyuunbXIcrY6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D17160BD0;
        Wed, 17 Nov 2021 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more Lenovo
 Docks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716061004.12308.10463476878060001504.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 14:50:10 +0000
References: <20211116141917.31661-1-aaron.ma@canonical.com>
In-Reply-To: <20211116141917.31661-1-aaron.ma@canonical.com>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hayeswang@realtek.com,
        tiwai@suse.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 22:19:17 +0800 you wrote:
> Like ThinkaPad Thunderbolt 4 Dock, more Lenovo docks start to use the original
> Realtek USB ethernet chip ID 0bda:8153.
> 
> Lenovo Docks always use their own IDs for usb hub, even for older Docks.
> If parent hub is from Lenovo, then r8152 should try MAC passthrough.
> Verified on Lenovo TBT3 dock too.
> 
> [...]

Here is the summary with links:
  - net: usb: r8152: Add MAC passthrough support for more Lenovo Docks
    https://git.kernel.org/netdev/net/c/f77b83b5bbab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


