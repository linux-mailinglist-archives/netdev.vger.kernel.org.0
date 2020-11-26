Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A8B2C4D23
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 03:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732292AbgKZCKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 21:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730764AbgKZCKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 21:10:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606356605;
        bh=Nf6CDhay0gejj0HYl6ztIGfNjJHoJrPIjOXPz8yRjNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SkrssBiEe2vNh54od3RCrK0fjP6Jms6MUJlUzm8whEGTR6k+I0qaI3x7sot/tSoIt
         RjVksaKjP0TY/K+ddJfzdnymdkD2fKhyRzf/hDpUT5u1g25CYsM1cCABoEiEtysTQv
         QZKdxuWA6+6tVdMmmnXLw2E22WKH/GwMncHdDAro=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v5 0/4] net: dsa: mv88e6xxx: serdes link without phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160635660574.32694.2697138080235929457.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Nov 2020 02:10:05 +0000
References: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, pavana.sharma@digi.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Nov 2020 17:34:36 +1300 you wrote:
> This small series gets my hardware into a working state. The key points are to
> make sure we don't force the link and that we ask the MAC for the link status.
> I also have updated my dts to say `phy-mode = "1000base-x";` and `managed =
> "in-band-status";`
> 
> I've dropped the patch for the 88E6123 as it's a distraction and I lack
> hardware to do any proper testing with it. Earlier versions are on the mailing
> list if anyone wants to pick it up in the future.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/4] net: dsa: mv88e6xxx: Don't force link when using in-band-status
    https://git.kernel.org/netdev/net-next/c/4efe76629036
  - [net-next,v5,2/4] net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185
    https://git.kernel.org/netdev/net-next/c/f5be107c3338
  - [net-next,v5,3/4] net: dsa: mv88e6xxx: Add serdes interrupt support for MV88E6097
    https://git.kernel.org/netdev/net-next/c/5c19bc8b5734
  - [net-next,v5,4/4] net: dsa: mv88e6xxx: Handle error in serdes_get_regs
    https://git.kernel.org/netdev/net-next/c/0fd5d79efa4a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


