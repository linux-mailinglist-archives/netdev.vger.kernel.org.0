Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E402EC74C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 01:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbhAGAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 19:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbhAGAUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 19:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F05DC221EA;
        Thu,  7 Jan 2021 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609978808;
        bh=Pyd7Q5FpX6EiuoWn5shNq4eTuiszLENLn3GuRwZrnS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kPseRpZPB4bZ3cNniRVigU92yJzYUITFRNKZGzGk/mI/aHETom0ATTFeM2TR9qQTb
         0q55aFjfrIJuB0Q0I4YfnHE+3VgC8p8NIgfa6W9KWL3yDcS3bQqjlLCHarGeM7rXti
         FpiadYijg/zb1byy9daByttb64bZnLtspdFZ1a7aWHyetuEGuhtToMjaFL9WeIYgU9
         M6UAgMTcVX0iEdKx2R/pVGpaqcQ8eQg0dZYZaAUFt6JfNua0Z/mLZ+ZujZcPC+rhWR
         TI494KnfP7BLrHH2FereL8fMN4UBb4uRt1bmNyfwZNnooCZBHXKvXGkgwYOWd4Yhmy
         47D3mmBf2L28w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id E115360385;
        Thu,  7 Jan 2021 00:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: fix led_classdev build errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160997880791.16542.2183389787876275211.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jan 2021 00:20:07 +0000
References: <20210106021815.31796-1-rdunlap@infradead.org>
In-Reply-To: <20210106021815.31796-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, lkp@intel.com, kurt@linutronix.de,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Jan 2021 18:18:15 -0800 you wrote:
> Fix build errors when LEDS_CLASS=m and NET_DSA_HIRSCHMANN_HELLCREEK=y.
> This limits the latter to =m when LEDS_CLASS=m.
> 
> microblaze-linux-ld: drivers/net/dsa/hirschmann/hellcreek_ptp.o: in function `hellcreek_ptp_setup':
> (.text+0xf80): undefined reference to `led_classdev_register_ext'
> microblaze-linux-ld: (.text+0xf94): undefined reference to `led_classdev_register_ext'
> microblaze-linux-ld: drivers/net/dsa/hirschmann/hellcreek_ptp.o: in function `hellcreek_ptp_free':
> (.text+0x1018): undefined reference to `led_classdev_unregister'
> microblaze-linux-ld: (.text+0x1024): undefined reference to `led_classdev_unregister'
> 
> [...]

Here is the summary with links:
  - net: dsa: fix led_classdev build errors
    https://git.kernel.org/netdev/net/c/7f847db30408

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


