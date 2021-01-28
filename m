Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51C6306BAC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhA1Da5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:30:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhA1Dax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 22:30:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E12CF64DDA;
        Thu, 28 Jan 2021 03:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611804612;
        bh=DyOBy2xjYpKsPCJAZ9ugfjDQxPmTMooiZRuXnU22JYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EN3lcMGmWYWo2dDmtmG1QGcOfB3en14ZNZw40Vdd18lO+t4bT5rdil7j3VHljHzof
         nlRC6JJlju+R7d6ANy3nGHZbaRruTwf6Sl0Bux+H5W/4MpsPV6S1YUOXlmBsOZTruF
         NpQpeShiuVAEgOIEyC9UAtecFgRRyoiliNHbthr7qC3XqFb0rDlMycH/rqwzF7o1wq
         4TkKd5xwTbu96TRSupBkTEpC/JpCM1OwUHxqnMsGcqEj32gMhbwAGzIUg7ro7DWpfA
         z9eDVWvsYhZ2kPdaMs7pnke1JB4PAevaSUHP1BxqE9gp9jrAxqmZisgIICNunphSSs
         FY+QJGBTGy5ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DD15665307;
        Thu, 28 Jan 2021 03:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2] net: dsa: mv88e6xxx: Make global2 support
 mandatory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180461290.10551.18374031014537618888.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 03:30:12 +0000
References: <20210127003210.663173-1-andrew@lunn.ch>
In-Reply-To: <20210127003210.663173-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        f.fainelli@gmail.com, tobias@waldekranz.com,
        vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 01:32:10 +0100 you wrote:
> Early generations of the mv88e6xxx did not have the global 2
> registers. In order to keep the driver slim, it was decided to make
> the code for these registers optional. Over time, more generations of
> switches have been added, always supporting global 2 and adding more
> and more registers. No effort has been made to keep these additional
> registers also optional to slim the driver down when used for older
> generations. Optional global 2 now just gives additional development
> and maintenance burden for no real gain.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: mv88e6xxx: Make global2 support mandatory
    https://git.kernel.org/netdev/net-next/c/63368a7416df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


