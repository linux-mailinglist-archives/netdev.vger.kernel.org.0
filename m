Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A1A348215
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbhCXTk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237925AbhCXTkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 15:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E43CA61A27;
        Wed, 24 Mar 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616614808;
        bh=KLYENuOcXI14xb4rj4Fs42f+fX8Y8nzzaYL3MtEcvmE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H65ORv819BZRboWNPrL9tqsKb7Uip7DzXHRDOPOK+zFOiZWt4GZxJMeiEb10cbiYq
         lTDs9KhUE8w3e9xBy7dlizlmCyJIQptiXRsazQeuaW+Om89Sy388MgJrjTJv7OTieo
         ZPuZBvgT+xvxEPkSlJmAO1vN8XqeYVXDz9/uSz/iz7pyr4QiFIAgebGDP4kL6RS9ia
         n2+WoDzSzOf1mUGS1O5PCce4OzyWLSyBMsozRBCpvkY7zxu7rGRm70kpgbi3pQ0bEp
         wLQCUlBCrkR7kTNXv0fQsrU39V/EE0MPjG1wuo7CRp07D+75i5gOUbQpegepnUdsnw
         U+bmpP9ub07dg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DDDC960A3E;
        Wed, 24 Mar 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] bridge: mrp: Disable roles before deleting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161661480890.20893.12247357786552976282.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 19:40:08 +0000
References: <20210323083347.1474883-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210323083347.1474883-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 09:33:45 +0100 you wrote:
> The first patch in this series make sures that the driver is notified
> that the role is disabled before the MRP instance is deleted. The
> second patch uses this so it can simplify the driver.
> 
> Horatiu Vultur (2):
>   bridge: mrp: Disable roles before deleting the MRP instance
>   net: ocelot: Simplify MRP deletion
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] bridge: mrp: Disable roles before deleting the MRP instance
    https://git.kernel.org/netdev/net-next/c/b3cb91b97c04
  - [net-next,2/2] net: ocelot: Simplify MRP deletion
    https://git.kernel.org/netdev/net-next/c/5b7c0c32c904

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


