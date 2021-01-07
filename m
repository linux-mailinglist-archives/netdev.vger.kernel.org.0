Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B752EE9F5
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbhAGXuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729376AbhAGXuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 18:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2EEE7236F9;
        Thu,  7 Jan 2021 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610063411;
        bh=h+950jqqSgUjda9ooX36opiYQV7Oa8z3UVCM2SAVnIs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tnrDazhW4d+Y28BGKbcClARxECdlsxi22LT53PB6sM0hanRlDfiJqnmphkbpkd5fe
         2maMHWu012GihxFPCAxC+JQ3R55f8dae3mHJ54iaWNrrf7yYuE0ygiFi7lFf3FfZsR
         YXojO24eFVzEanE0WDF5NMSw5i2kVkFrwxkyxVvbpN/pp8TiIJkb9qoyKxpr3Wn9ju
         I5+gfCKp4Ugvw7/SG65w7pn8uDkTfHmTXMs/wyXDA7HmdopuakfHG5rQYuku84M28V
         yKEG86OV2Z1BnjoNOqoIA4Ho6kPC4cGvBvzMMGJ3LUW5Auoohqx9ui2zmXNSS92J63
         ycrK544rSHXEw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 2086B605AC;
        Thu,  7 Jan 2021 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] Reduce coupling between DSA and Broadcom
 SYSTEMPORT driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161006341112.8293.6610475069406469009.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jan 2021 23:50:11 +0000
References: <20210107012403.1521114-1-olteanv@gmail.com>
In-Reply-To: <20210107012403.1521114-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, zajec5@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  7 Jan 2021 03:23:59 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Upon a quick inspection, it seems that there is some code in the generic
> DSA layer that is somehow specific to the Broadcom SYSTEMPORT driver.
> The challenge there is that the hardware integration is very tight between
> the switch and the DSA master interface. However this does not mean that
> the drivers must also be as integrated as the hardware is. We can avoid
> creating a DSA notifier just for the Broadcom SYSTEMPORT, and we can
> move some Broadcom-specific queue mapping helpers outside of the common
> include/net/dsa.h.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] net: dsa: move the Broadcom tag information in a separate header file
    https://git.kernel.org/netdev/net-next/c/f46b9b8ee89b
  - [v2,net-next,2/4] net: dsa: export dsa_slave_dev_check
    https://git.kernel.org/netdev/net-next/c/a5e3c9ba9258
  - [v2,net-next,3/4] net: systemport: use standard netdevice notifier to detect DSA presence
    https://git.kernel.org/netdev/net-next/c/1593cd40d785
  - [v2,net-next,4/4] net: dsa: remove the DSA specific notifiers
    https://git.kernel.org/netdev/net-next/c/1dbb130281c4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


