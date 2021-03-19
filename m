Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3C13412C4
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbhCSCUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhCSCUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F82064F30;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=qzUn0wNfq6toZsJIKjh0nYE4QOxqNGAgcBQI2onEO0U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jHMS/CDkyoc3oOw7yWl7lci5PdjtVBnRHM8Ptm7wNbBfpI328tHzl9jM2ZhD+QMlh
         Ic6A4wwvmWqBgJzZl1sSnXLm1h6VMSsAVgdik+4ir8nN/Yss+nFzpcMQrR155so4NS
         O6vlOULXOVRNAKDxuRu33P1Wl8DnxUMtXe+7aDXkosNelXXNhohg9A0jscV5biJElV
         RAz6VWXCBuAD1CYqgsMANbWSfrFWZkO5o/inmYOfp1PsmQ+hc9alIYZiJEJahvzWPW
         tMeW5xQycpDzJqdovu85o5zDKQf44Vg5IS8xCfPwdtr24H8SfPOu/ULngzHjeJzKLY
         heKxXPiTusx+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 445A7600DF;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ocelot: Fix deletetion of MRP entries from MAC
 table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041227.22955.13723895013574396796.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210318192938.504549-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210318192938.504549-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 20:29:38 +0100 you wrote:
> When a MRP ring was deleted or disabled, the driver was iterating over
> the ports to detect if any other MPR rings exists and in case it didn't
> exist it would delete the MAC table entry. But the problem was that it
> used the last iterated port to delete the MAC table entry and this could
> be a NULL port.
> 
> The fix consists of using the port on which the function was called.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ocelot: Fix deletetion of MRP entries from MAC table
    https://git.kernel.org/netdev/net-next/c/d25fde64d1c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


