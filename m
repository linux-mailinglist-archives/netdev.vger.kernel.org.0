Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DD63050EC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbhA0Eaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727012AbhA0Buv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D716C64D84;
        Wed, 27 Jan 2021 01:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611712210;
        bh=H4LNNlGkkI9AJgqotdQld1JsAZi8JDwvywXfbSQd6ls=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RB6NzZBu0gi+ricd4LH/5HIFGE3p0CsqejyFwUCO1kHZp0grU2QznUlhizS1xaZQc
         BNIEEle5rZhvsk27QfRKc7KcEHtt7EYBR1XUqpPLalyNaEPAMXuXPi7Fdu12vSZnK6
         7z8RrNKi8K72hF05nbEZnvUn4Oelo5rpWDAAjLZE8k5X4e+nOyfHAihzPaTnFU/DYZ
         2KWVW0NG/uBdThZyE/OL7UhAknQ0mWec3mLe2u+OeDUGIMRcgJqpUxx1S+tTxc20Fl
         oXAiAc6GELWfrfOt2nrf/m1CG1xhggXP6aFKuzwo4XgYl7Zi+FyojF/kCx9KGV2QF5
         922g+hqb/7R7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB04D652E0;
        Wed, 27 Jan 2021 01:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [net-next] bonding: add TLS dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161171221082.14694.3231614939806661225.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 01:50:10 +0000
References: <20210125113209.2248522-1-arnd@kernel.org>
In-Reply-To: <20210125113209.2248522-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        mchehab+huawei@kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        loic.poulain@linaro.org, pablo@netfilter.org, masahiroy@kernel.org,
        martin.varghese@nokia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 12:31:59 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When TLS is a module, the built-in bonding driver may cause a
> link error:
> 
> x86_64-linux-ld: drivers/net/bonding/bond_main.o: in function `bond_start_xmit':
> bond_main.c:(.text+0xc451): undefined reference to `tls_validate_xmit_skb'
> 
> [...]

Here is the summary with links:
  - [net-next] bonding: add TLS dependency
    https://git.kernel.org/netdev/net-next/c/285715ac9a81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


