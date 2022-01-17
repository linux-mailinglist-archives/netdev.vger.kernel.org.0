Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAFE49093D
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 14:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbiAQNKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 08:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiAQNKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 08:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8FFC061574;
        Mon, 17 Jan 2022 05:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DF52B81014;
        Mon, 17 Jan 2022 13:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E589C36AEC;
        Mon, 17 Jan 2022 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642425009;
        bh=1KPr3RJ9vJZ9QbTuZ1L39nuwUAuef3jmkI+BhfeQFZs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fxu+ZB5mZ0CY66YvzvL4Uev03KmHUSJsp4DUEioMNjxqU6h7dRMZ7ds6s6fIpp9iI
         LLOAEKhKWglnSjPxljyvPTtev+EsjXNIJg79wkme9YxCBQqgYaOmkO0mXqaxxMmtCq
         fB+JIhgOeEaISFY8x2DR/HHe2Q23P+drK8+qJG1tzT33c1JOrdGProvosL58408agS
         EHYFv/E0aT2gIUuIhorB6DgzEHWBTDRCqrNrvcKYgk9lRyqU1a5Ynr5tZvaphWSk+t
         0JIaz/aUopoOK4Y+UMcB88g13+APBEt+jxFzjmIthw7WSOPROYauHtRFAT+FBNpAjl
         CQibcp5a+MneQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55401F6079A;
        Mon, 17 Jan 2022 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ocelot: Fix the call to
 switchdev_bridge_port_offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164242500934.15907.2434323319190112955.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Jan 2022 13:10:09 +0000
References: <20220117125300.2399394-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220117125300.2399394-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Jan 2022 13:53:00 +0100 you wrote:
> In the blamed commit, the call to the function
> switchdev_bridge_port_offload was passing the wrong argument for
> atomic_nb. It was ocelot_netdevice_nb instead of ocelot_swtchdev_nb.
> This patch fixes this issue.
> 
> Fixes: 4e51bf44a03af6 ("net: bridge: move the switchdev object replay helpers to "push" mode")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ocelot: Fix the call to switchdev_bridge_port_offload
    https://git.kernel.org/netdev/net/c/c0b7f7d7e0ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


