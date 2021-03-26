Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE17349DD2
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhCZAaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36667 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCZAaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A7FC61A41;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718610;
        bh=EiZKWVxjH6LCsHn0ItN/vRqhuZI3koTU0V8hc/1Jo3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mUeU+Y3jHW2KXX8BFRF3sUiHXRbCXdN00vrlQCSU2WzCKglSOAsadSagGsX6Ad3cX
         YWZ3Ioop3oelPtac+MZo/Lca3Wjl258Oh+FV955aZnFW5M3tV44kGP13vtKchTkhhT
         aNg2XyDz5mFQpZ0NhPl+oKRlZIYI6Hu8r0CvUeKCLmVPyd0HWAenHuHkTsTsQMj4B0
         6jFPLnkOQ+ZhC0+lgrvURlwg1Meg5eWnt4wpKsqJf4NmVBJrvyr/GFkux/aRdY+Lb6
         b2V4KxBY0xAVe0hzAtnZZI4Muj89fdkVHK8arIaUaGguqeiC8hpH72PQHGZ8g2sclw
         TFdsRclmSKQGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A2D460A6A;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: axienet: allow setups without MDIO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671861056.2256.2487245849622783826.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:30:10 +0000
References: <20210324130536.1663062-1-daniel@zonque.org>
In-Reply-To: <20210324130536.1663062-1-daniel@zonque.org>
To:     Daniel Mack <daniel@zonque.org>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 24 Mar 2021 14:05:36 +0100 you wrote:
> In setups with fixed-link settings there is no mdio node in DTS.
> axienet_probe() already handles that gracefully but lp->mii_bus is
> then NULL.
> 
> Fix code that tries to blindly grab the MDIO lock by introducing two helper
> functions that make the locking conditional.
> 
> [...]

Here is the summary with links:
  - [v2] net: axienet: allow setups without MDIO
    https://git.kernel.org/netdev/net/c/de9c7854e6e1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


