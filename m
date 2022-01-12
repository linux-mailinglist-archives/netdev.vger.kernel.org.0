Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1412D48C5DA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242162AbiALOUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:20:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50774 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238981AbiALOUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:20:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8E69616C6;
        Wed, 12 Jan 2022 14:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 501A0C36AE5;
        Wed, 12 Jan 2022 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641997208;
        bh=d2KS11k5Yjjj+nDTx0R2wRrTlCpdlCZktiY5Q59oXNY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BgdAI7gN5enr4n57ic1pM6PwIuBlYmdXZeSEv62yy+zF6ZU+2CQwUH0HjARRLcoWm
         Y4Ns/VROMn56/RejR1SLKcbHuJZIJCW51stJoacT4m5HTg9Wsk7Xfb7xZQzNfQQ4UV
         cA4Iw7zxCS946UFpUBwu+ljFX9ftOLN4mSNQa9Po4b8d9nBf3C3m+/+8AqDY0IM00Z
         85AmsTgvoScDflPdFBEpEqjb5GWNhuYDQQq0aaTN8cDwHxV1pSj1lAALHd03JaPYjJ
         N+HF1xwCDW+1gK0MoyFqs2wYUkZ1Tm3lj6kufaEU1O67vS0/z5mJBCRSs3/WrKb5R6
         3ln8M0zKiKexg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3738AF6079A;
        Wed, 12 Jan 2022 14:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "of: net: support NVMEM cells with MAC in
 text format"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164199720822.30844.4377196587092278837.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 14:20:08 +0000
References: <20220111081206.2393560-1-michael@walle.cc>
In-Reply-To: <20220111081206.2393560-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafal@milecki.pl, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 11 Jan 2022 09:12:06 +0100 you wrote:
> This reverts commit 9ed319e411915e882bb4ed99be3ae78667a70022.
> 
> We can already post process a nvmem cell value in a particular driver.
> Instead of having yet another place to convert the values, the post
> processing hook of the nvmem provider should be used in this case.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "of: net: support NVMEM cells with MAC in text format"
    https://git.kernel.org/netdev/net/c/3486eb774f9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


