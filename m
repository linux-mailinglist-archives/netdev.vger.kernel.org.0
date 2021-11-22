Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AB4459060
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbhKVOnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239770AbhKVOnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:43:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3864A604D1;
        Mon, 22 Nov 2021 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637592009;
        bh=3iFuKliPS+OS4p3jtvyWWwr3LNFHl6PYi7GnohJOviY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uG/ykPIBpaO2fxZsG4wB2HdsnRCrS+tc0X5Kx8mi/wsan0HF0fAvjDZj7dKTPEmV8
         hMFcAiRoJkdxXg2rqRelE9YpNtbqv9RLSFNR0JkOtTOizlAfqwtAZ1rKPRnzznoFJz
         fHDRApQqOTNvOYuFN3TYYLPXL9Fjseb3kROga5jSj1TYnsdsb4z5G5lu93a4Pwd74n
         soDDE3vA5Lar7J5vH7HjoH+Sb3KRM4rb73RF4TnMSWwSm0kasJTUeKxgrkQR/Jo20R
         6AIT9GarrmTTEj48LDo+eFBqez84hvruj4t1obXSv/9w/jHCRKHNEHz9DeUa2Gfa+7
         kal2iX7+nQKJA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 28815609D9;
        Mon, 22 Nov 2021 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: stmmac: retain PTP clock time during
 SIOCSHWTSTAMP ioctls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759200916.2046.16368068009111419388.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 14:40:09 +0000
References: <20211121175704.6813-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211121175704.6813-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xiaoliang.yang_1@nxp.com, yannick.vignon@nxp.com,
        m.olbrich@pengutronix.de, a.fatoum@pengutronix.de,
        h.assmann@pengutronix.de, kernel@pengutronix.de,
        kurt@linutronix.de, richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 21 Nov 2021 19:57:04 +0200 you wrote:
> From: Holger Assmann <h.assmann@pengutronix.de>
> 
> Currently, when user space emits SIOCSHWTSTAMP ioctl calls such as
> enabling/disabling timestamping or changing filter settings, the driver
> reads the current CLOCK_REALTIME value and programming this into the
> NIC's hardware clock. This might be necessary during system
> initialization, but at runtime, when the PTP clock has already been
> synchronized to a grandmaster, a reset of the timestamp settings might
> result in a clock jump. Furthermore, if the clock is also controlled by
> phc2sys in automatic mode (where the UTC offset is queried from ptp4l),
> that UTC-to-TAI offset (currently 37 seconds in 2021) would be
> temporarily reset to 0, and it would take a long time for phc2sys to
> readjust so that CLOCK_REALTIME and the PHC are apart by 37 seconds
> again.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: stmmac: retain PTP clock time during SIOCSHWTSTAMP ioctls
    https://git.kernel.org/netdev/net/c/a6da2bbb0005

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


