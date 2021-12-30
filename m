Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB403481888
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbhL3CaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52822 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhL3CaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E61F615DE;
        Thu, 30 Dec 2021 02:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74C91C36AEC;
        Thu, 30 Dec 2021 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640831410;
        bh=01mLfxTFA2XUBdbggo8RTtjdpx1Q3CHNtL8LkGXsbqo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IXMNDjVgdTOD5/FMZs6RJNC4oUAYRnPcdBeRoTFgm8UHv/m6pE41cOQ4F8iy5+1pT
         BoLAl37UOeTlOXQpPpRUzMFKgHhC6oHfaigBJt2rm2Zi2J2nOhDhNvjbGI72J4NYiI
         JYt3MVd3KU+AkrvX34rbLy6gOpyt+rAEftIWqpbfs5QDk4mDK52NGff9ncdU3u26WE
         AT2cYyOPLZsGWaADgiPkMujgkG/iVL0dNDn3Fj/j3f2rSqF7defYDRPlkss3Xt90iu
         kEmIdKgyoGA921PAany6iQ0ve6UV2FLbT/VdHWQSiaHXo75BfljhEy+VkqOVYTo2hX
         iM3o9PiEU4zkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5988FC32795;
        Thu, 30 Dec 2021 02:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/ncsi: check for error return from call to nla_put_u32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164083141036.11132.4978969481832476065.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 02:30:10 +0000
References: <20211229032118.1706294-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211229032118.1706294-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     sam@mendozajonas.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Dec 2021 11:21:18 +0800 you wrote:
> As we can see from the comment of the nla_put() that it could return
> -EMSGSIZE if the tailroom of the skb is insufficient.
> Therefore, it should be better to check the return value of the
> nla_put_u32 and return the error code if error accurs.
> Also, there are many other functions have the same problem, and if this
> patch is correct, I will commit a new version to fix all.
> 
> [...]

Here is the summary with links:
  - net/ncsi: check for error return from call to nla_put_u32
    https://git.kernel.org/netdev/net/c/92a34ab169f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


