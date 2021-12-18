Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D08E479869
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhLRDaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhLRDaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1F3C061574;
        Fri, 17 Dec 2021 19:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7498362477;
        Sat, 18 Dec 2021 03:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDA79C36AE8;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798214;
        bh=tGXWTkM7Uzb328e+eUeopkRtyGGMv0hFxb5AtH1+nA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AlhQ5M4cGyVK8RadSLxXBBX1yQOYidu72pQazj7CxwFIkbfJAnrw13KlZ9pGhxdlL
         dIISYs+wT1zEkvioARazRmR/Mj2LtGJG1U7XJWz5sV5rNbB2uSm4oO+atCt78CMLu/
         Y9HtuSRjgEctKy8zO8k1zt6jFuyf4ckEF0hrzX9VTmkLOKn0OGZOZQO4Q2Tn4lFxVp
         +kSu05VV37ufyCOT1XoJ7VbhPqHX8yluVLPxzggTeU+yNZw4GlJX7Rvmo8wYU9tKGD
         XGRa8ssdNcm3bDfjOdShsU6dWpAZLVxmFnx56SJQJhR3IZylbSWEGAi9pWiDoL8ndZ
         76UT8WrAHdmTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B119960A2F;
        Sat, 18 Dec 2021 03:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix incorrect structure access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821472.17814.11509702990078452116.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:14 +0000
References: <20211216171714.11341-1-yevhen.orlov@plvision.eu>
In-Reply-To: <20211216171714.11341-1-yevhen.orlov@plvision.eu>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, volodymyr.mytnyk@plvision.eu,
        taras.chornyi@plvision.eu, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, tchornyi@marvell.com,
        davem@davemloft.net, kuba@kernel.org, vkochan@marvell.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Dec 2021 19:17:14 +0200 you wrote:
> In line:
> 	upper = info->upper_dev;
> We access upper_dev field, which is related only for particular events
> (e.g. event == NETDEV_CHANGEUPPER). So, this line cause invalid memory
> access for another events,
> when ptr is not netdev_notifier_changeupper_info.
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: prestera: fix incorrect structure access
    https://git.kernel.org/netdev/net/c/2efc2256febf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


