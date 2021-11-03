Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8966F444393
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhKCOcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230472AbhKCOco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9BFBB6103C;
        Wed,  3 Nov 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635949807;
        bh=v+l+N51Oa8tbmQcIRXMufkeRZwwktJml8WL3XC3wStA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rvA+GycreYVBktKtIBmsRD8V5ifu2/MDTr9mu2wkyyF79UJd6KXNRlpy6o4SXaUOC
         QucBqC6kUpeHNMqmOlkwls/LZ18dPM57SAms9EKdnNjZIHQBijD07g6aACheAbUZ0o
         e7vErknU6zrhDsgy5Grt3BrpbssN9WIwbinw7Yy/bHfAJZ+FzYzb/qxYxJdCSKnRF1
         wsOixer7h32Y64UIByCKRLz+aZg806Nbazx/Zm7LQfziheQxF6vgtTEdXAL57UKB3E
         NXIN13xHOhhlQoqm3zjN78GOmoJPqQK35ouxaPP7QaVmgMsM5IsL8niS4V9bjEmAgm
         DaY6mLr4Frr8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92A9A609CF;
        Wed,  3 Nov 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: fix broken VLAN-tagged PTP under
 VLAN-aware bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163594980759.8310.12802815876396371831.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 14:30:07 +0000
References: <20211102193122.686272-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211102193122.686272-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        yangbo.lu@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  2 Nov 2021 21:31:22 +0200 you wrote:
> Normally it is expected that the dsa_device_ops :: rcv() method finishes
> parsing the DSA tag and consumes it, then never looks at it again.
> 
> But commit c0bcf537667c ("net: dsa: ocelot: add hardware timestamping
> support for Felix") added support for RX timestamping in a very
> unconventional way. On this switch, a partial timestamp is available in
> the DSA header, but the driver got away with not parsing that timestamp
> right away, but instead delayed that parsing for a little longer:
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: fix broken VLAN-tagged PTP under VLAN-aware bridge
    https://git.kernel.org/netdev/net/c/92f62485b371

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


