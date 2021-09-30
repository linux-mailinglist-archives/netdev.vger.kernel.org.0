Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CE141D961
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350666AbhI3MLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236162AbhI3MLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 60CC66162E;
        Thu, 30 Sep 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633003808;
        bh=Mav6ojXpIEY74hjbVzhcPAlIYTrO+Y9vjzx26Qf4avc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QHrjJs5Tnt85htldGZJAhCxZGKuvTLWe2QaNszNr/N5O93YlodTwfltXAVuhBmfpn
         C7xe6ApCnRQwh/rmBK8XSir5bOAorAyyZ3lqVDJBzdaHRPYUr/P7KljsHk778IR9U1
         7lNQmQemaa9MufspmHqtNdVGSTS/LC8VkCBZ+/aURSafEzWRFV3SbtGqLN8zoROHMU
         QNl+UfpGzyrj+07jgAtOUKHmzhg7w8Us52a7Gh1r+dxNjBDDjyen5WIMnE1iHiZLyS
         HYWGI6y3gI87/M9iaQ4PJUTOKWPQ1DEb/GhFVeDFNJUjrRm/Zz4+V+fk1wq/ZvKeze
         KkgLEfWIEIbmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53F0060A9F;
        Thu, 30 Sep 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: rtl8366rb: Use core filtering tracking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300380833.14665.17977587285258379262.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:10:08 +0000
References: <20210929112322.122140-1-linus.walleij@linaro.org>
In-Reply-To: <20210929112322.122140-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, sandberg@mailfence.com, dqfext@gmail.com,
        alsi@bang-olufsen.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 13:23:22 +0200 you wrote:
> We added a state variable to track whether a certain port
> was VLAN filtering or not, but we can just inquire the DSA
> core about this.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> [...]

Here is the summary with links:
  - net: dsa: rtl8366rb: Use core filtering tracking
    https://git.kernel.org/netdev/net-next/c/55b115c7ecd9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


