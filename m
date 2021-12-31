Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3004D482183
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242170AbhLaCaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241060AbhLaCaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 21:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13752C061574;
        Thu, 30 Dec 2021 18:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B5D36177F;
        Fri, 31 Dec 2021 02:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB47BC36AF0;
        Fri, 31 Dec 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640917809;
        bh=GcCjbJw9rm7bUosAdgziUcMxKlLhea+f5ezzR1oOwTE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mN8GCkoIN1aoLjHv+jtuGuWKlnOSdLD1iBy70Q6gHVfwbcGmAAgylKZJB9wYDtHZV
         RBwGlxuJuaZUETCtHENMrLAqxg2k95hlusSnZeuF48X93PqJ86RxenZ9B26HeS9jSl
         oRRcHtctyFFbhxow9BARXjiX6ioUauqL3zopsv4lbXiARHos0XEnAWTKunlAk2SdRS
         FTybwwQADhutVXzuiwgOOyXbjlzrfpLy7nXZfjrLSqEwtfF772P7Gj7kbuWU1YWSC9
         79gew2+on8WZSRGVKtuz+uZSidwBsmDnKgt237Hh94yRFlCRdjb6bD7l/8LdIqDyKz
         +ON//zcLwgdbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9311CC395E8;
        Fri, 31 Dec 2021 02:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: remove references to CONFIG_IRDA in network header files
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164091780959.19399.6215347131350470669.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Dec 2021 02:30:09 +0000
References: <20211229113620.19368-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20211229113620.19368-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Dec 2021 12:36:20 +0100 you wrote:
> Commit d64c2a76123f ("staging: irda: remove the irda network stack and
> drivers") removes the config IRDA.
> 
> Remove the remaining references to this non-existing config in the network
> header files.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: remove references to CONFIG_IRDA in network header files
    https://git.kernel.org/netdev/net-next/c/d6c6d0bb2cb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


