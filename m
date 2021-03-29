Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6736234C0E6
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhC2BKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229763AbhC2BKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:10:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA18B61941;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616980209;
        bh=iPhi4z/C0QYSqqaP9g0waeQocCs1+EWmhvb6UZGq4Sg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T/EclykzyW1yVEDPRoQIKZIZmT0rqVZbUTokpwBI5lzGNSReFrIRq8as2GoNwOwc0
         ot4zBlOTtGAvEeJzDSW0P5XfMyj7KT8O3TRxb3RpF8lLRJqCBpnZ+cRwe9pRl0fl9q
         cPXocOwDS4w/QEquH8iXGSI5FVJuN1C2j9zrxoAcO4nQerteYsbfdx7AByjU7cyHgd
         FfADkqSC8Jdll+qR9dytcdE0Tng0tnrNIQpuL61dEvJXtJmd3Ff+hF+suKiiwnMxA0
         npwE1SVvgAAdXOhGgQm5j5d02V4JFBfTryn3XRyrrhJgDTDbyA4x/b6tjqGzS0eEi9
         f0FMzcnPywxQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A39F60A56;
        Mon, 29 Mar 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: hellcreek: Remove redundant dev_err
 call in hellcreek_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161698020962.2631.11933812276689921090.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:10:09 +0000
References: <1616839638-7111-1-git-send-email-huangguobin4@huawei.com>
In-Reply-To: <1616839638-7111-1-git-send-email-huangguobin4@huawei.com>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     kurt@linutronix.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 27 Mar 2021 18:07:18 +0800 you wrote:
> From: Guobin Huang <huangguobin4@huawei.com>
> 
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: hellcreek: Remove redundant dev_err call in hellcreek_probe()
    https://git.kernel.org/netdev/net-next/c/656151aaa623

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


