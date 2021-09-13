Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CF3408AC0
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbhIMMLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 08:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236301AbhIMMLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 08:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E99560FBF;
        Mon, 13 Sep 2021 12:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631535007;
        bh=RaGhWI0o4MUqwZo1FJ6SXGSplQ5E5XdW6QpITu3+Zl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h2/VqlXvcAScByBmG1MM91aKZFl9ZJCytrylUZtUebzE6mNCPkpGwFRuuy4Q+b2xs
         YDkPKqISDhuNM8zVZORHGqL3Bvq9Xh2oZx2fNeNZxfCECF9jCu3WralKLE8UpM3Vc8
         BMz6+3nQWCJ1QnSXNGv6+5jVRf9gxh2nPQg5XBGn27C2rBY4q8sZ9k6kDAzBOQxflt
         1FEQ6jgcTsPLflKMxKHNs8UCukKSZiLakTXOLpUKFbtgq4bn02Zsf1M3s5NYs5PSXg
         F7IZWwdHgH4PnyN/NVMOuUIYC6STjEDIxYN/ZjwG9CowPEF2ikkTyTQmGafI5NHDXa
         dLAUGDTGLngag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2C4E560A47;
        Mon, 13 Sep 2021 12:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net,v2] net: dsa: lantiq_gswip: Add 200ms assert delay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163153500717.9327.7042325413099063008.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Sep 2021 12:10:07 +0000
References: <20210912115807.3903-1-olek2@wp.pl>
In-Reply-To: <20210912115807.3903-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.blumenstingl@googlemail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 12 Sep 2021 13:58:07 +0200 you wrote:
> The delay is especially needed by the xRX300 and xRX330 SoCs. Without
> this patch, some phys are sometimes not properly detected.
> 
> The patch was tested on BT Home Hub 5A and D-Link DWR-966.
> 
> Fixes: a09d042b0862 ("net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: lantiq_gswip: Add 200ms assert delay
    https://git.kernel.org/netdev/net/c/111b64e35ea0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


