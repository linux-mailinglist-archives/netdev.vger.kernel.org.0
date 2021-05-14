Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763D23813D6
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhENWlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234020AbhENWl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5854C61457;
        Fri, 14 May 2021 22:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621032016;
        bh=dVDisaEu+JLk9tX/gu7S6QVTsa7EUZDoMzF4o0fafaI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uuDzfDGOq5JWBizYc9ZSmjF8TAq0b+lkpUd5LZxMOjqgI8AZfGXezfmxv/vu9Y2+s
         AwxTJ0KsjUCVEUSfqmMt4pVNVTmgAlu0FEsfCP04RJJVW8/DE9vaTyvvLc0tW8qPOi
         +1tbpsYc/pg79BaSHP9HNBV+TshEEqlWHQi+GmmM3ewnVfrY3tSK2LlpME2MzYvtrG
         yCXUihyk9Vkne0TCeMaon/gvy/csvhelfTM+D4RpChhjJymEJ3ViigyzzUMmOIXJRH
         9F+xWrUuEM4XQVHPoTxE6cXw91OwLhrJBSPQq714vo9bfgGMG2EDNVHe8L7RSndM5J
         S03OS3toyUF8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 45D9960A0A;
        Fri, 14 May 2021 22:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 1/3] net: mdio: ipq8064: clean whitespaces in define
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103201628.13732.13977221291107830799.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:40:16 +0000
References: <20210514210351.22240-1-ansuelsmth@gmail.com>
In-Reply-To: <20210514210351.22240-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 23:03:49 +0200 you wrote:
> Fix mixed whitespace and tab for define spacing.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/mdio/mdio-ipq8064.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)

Here is the summary with links:
  - [net-next,1/3] net: mdio: ipq8064: clean whitespaces in define
    https://git.kernel.org/netdev/net-next/c/948640698199
  - [net-next,2/3] net: mdio: ipq8064: add regmap config to disable REGCACHE
    https://git.kernel.org/netdev/net-next/c/b097bea10215
  - [net-next,3/3] net: mdio: ipq8064: enlarge sleep after read/write operation
    https://git.kernel.org/netdev/net-next/c/77091933e453

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


