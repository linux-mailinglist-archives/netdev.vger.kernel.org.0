Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BD540CF47
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 00:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhIOWVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 18:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232196AbhIOWV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 18:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BEAAE61131;
        Wed, 15 Sep 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631744407;
        bh=7tmQKcwmdXch6fwTwZkEmR+6drZiXGiaw5nK/VmgqgI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hDo33tAanigDwDn31WRTh3P0QZF4lgmF+xXeIJvE8nqi03XhuXDC9+G9TCBPm0rdX
         vz25hncX9XUNOMwsTFsHlNYG5trtRR8gl9tZ+sxkXmiTrRKSRrrN1cxtcmpeo1eGzM
         hDCl1rrfZvzloTIm+xCTX4j/Nq72lC5noRnH2Tb5hArEUDDh7kH0F0G9GPQPGcP3O+
         uvEN5TJTMfKBFdmUOK0o4UVBlBF2NkNXCG4uMrp2B7NtpFQSqLDG4ZWBPA6opvge+q
         jsKu51UYT5Dj1A6uTyzt+v9wXN3WdhP5A6jhxKu7ResOqljuh09XeYm12gyCObj8FL
         u+qtKPq7cE9rw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB85560BC7;
        Wed, 15 Sep 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: flush switchdev workqueue before tearing
 down CPU/DSA ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163174440769.30266.8199462326937690514.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 22:20:07 +0000
References: <20210914134726.2305133-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210914134726.2305133-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 14 Sep 2021 16:47:26 +0300 you wrote:
> Sometimes when unbinding the mv88e6xxx driver on Turris MOX, these error
> messages appear:
> 
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete be:79:b4:9e:9e:96 vid 1 from fdb: -2
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete be:79:b4:9e:9e:96 vid 0 from fdb: -2
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 100 from fdb: -2
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 1 from fdb: -2
> mv88e6085 d0032004.mdio-mii:12: port 1 failed to delete d8:58:d7:00:ca:6d vid 0 from fdb: -2
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports
    https://git.kernel.org/netdev/net/c/a57d8c217aad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


