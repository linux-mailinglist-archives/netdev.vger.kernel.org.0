Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538DB38CF82
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhEUVBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhEUVBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E2EC613E6;
        Fri, 21 May 2021 21:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621630810;
        bh=6nsRKmQatkw3eNA9TZ4yZMU+yKrRlDJRWpO8kflzF4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qeDaLh+kSBCqdoIL+TDwWSlOshHnwKzVVR3Kp5JQnPyDbDl8DZh345RGrvldu/m3S
         o3nKNgf/r3PSoAdZRdn5zj2cTKVCJ7O0oD/OI89xLrVlpFDurVm52oqCoPrdO5zVzL
         6u9JoG7Xl2NrWwJitepDzTSvJ5TQgJR/9LtXFVK/PL2pv6bH96xpjyV2LDRDVPgyHV
         GkvmB8mC2vEwP3/rEH5lzygP5U8BdR2mSYuEqFaVOx3mvXtenGy4G5MQyAp0mwkA9F
         SVYZ0adMNDeIRg7eXeEoafRggIUf1fhn6g78KRh9YWFgbdkhH13rET1FZFeueTQuNY
         kB7XfT5MhsBCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8DFC06096D;
        Fri, 21 May 2021 21:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: Fix inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163081057.24690.7776480693053528517.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:00:10 +0000
References: <1621590014-66912-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1621590014-66912-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 17:40:14 +0800 you wrote:
> Eliminate the follow smatch warning:
> 
> drivers/net/phy/phy_device.c:2886 phy_probe() warn: inconsistent
> indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net: phy: Fix inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/b269875f91c3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


