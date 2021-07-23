Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90B63D3D6F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhGWPjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhGWPjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 11:39:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 01FDD60E8B;
        Fri, 23 Jul 2021 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627057205;
        bh=M1Wa06am4V1FmiDRPqqoBhX4TlcEWJmbElcKTuemr/c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qICpRbZW9f2NHQQqfeN2Z7MerQpNYL8+qEa5RhOK0nAfTghFgRcJ+Ca3V72g2RZhz
         soFJKpinlcqrE/kGspy0Lquwk/2NQXv1I8QsMqPEYF2sovMO+yDpD4OBkdGU0I2Ee/
         iU1yBA/qbIYAOM6MMibpVWWkIwmFoxQzh74qbs7NOQ/5F9IYuSjlQnIGlH3L7jfC8o
         yp+MZMJQVezY4bLp+1YAbN2VFctY1JqY7/slTHQcRlrqwYgpNeoWdIm9vaHXnId4Us
         gx0QPUeBdtfgtc6Y23f05SSKTfb1UB1uo0iqshm49vK8xOL0j4G9QSPKFZfPFA7xSB
         9QUTSc+LOgbew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB0DF60721;
        Fri, 23 Jul 2021 16:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: silently accept the deletion of VID
 0 too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705720495.6547.12363450919258379070.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 16:20:04 +0000
References: <20210722130551.2652888-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210722130551.2652888-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        eldargasanov2@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Jul 2021 16:05:51 +0300 you wrote:
> The blamed commit modified the driver to accept the addition of VID 0
> without doing anything, but deleting that VID still fails:
> 
> [   32.080780] mv88e6085 d0032004.mdio-mii:10 lan8: failed to kill vid 0081/0
> 
> Modify mv88e6xxx_port_vlan_leave() to do the same thing as the addition.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: silently accept the deletion of VID 0 too
    https://git.kernel.org/netdev/net/c/c92c74131a84

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


