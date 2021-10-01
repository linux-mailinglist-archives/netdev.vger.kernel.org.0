Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C513E41F75E
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355702AbhJAWVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230292AbhJAWVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A2E261AA4;
        Fri,  1 Oct 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633126807;
        bh=9F0yLwcsvJ+4r5kWrtlh9MVAiAp2cg6CN5WDNMxngKs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UNj/cqmmNqmDJt7wj8TerYzPe0WS3cQx8Hfz3dQtC66RexlV51kCifGilhlLoXLUM
         fJf7hCqqNF3aQpJ93OLrm7lyitBT8QnjmeoMS1kO38iDJMzjwVHWDhB++/kyK5giLi
         cAQksc+hdvQkj9cJdob3nEjFbITqInZmRpbh9kWy9FDppdXYQ0kz2KJFSBeN4oXQp3
         k8C1fe2KQim1OykiBti2eI4qq0xFty/b6bEN/va0ycTDyy4HlgJLlr7wOFVcxullSO
         Z01xrxX8JhnYtFbwl9kG/SKV8zLlG1LLdp38LVSmfSNi8bi4wEruyhevOaQSGthSMl
         IBoxOU62IyAKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B0CD60BC9;
        Fri,  1 Oct 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: fix VCAP filters remaining active
 after being deleted
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163312680723.6540.7879715593054160551.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 22:20:07 +0000
References: <20210930125330.2078625-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210930125330.2078625-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com,
        po.liu@nxp.com, dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 30 Sep 2021 15:53:30 +0300 you wrote:
> When ocelot_flower.c calls ocelot_vcap_filter_add(), the filter has a
> given filter->id.cookie. This filter is added to the block->rules list.
> 
> However, when ocelot_flower.c calls ocelot_vcap_block_find_filter_by_id()
> which passes the cookie as argument, the filter is never found by
> filter->id.cookie when searching through the block->rules list.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: fix VCAP filters remaining active after being deleted
    https://git.kernel.org/netdev/net/c/019d9329e748

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


