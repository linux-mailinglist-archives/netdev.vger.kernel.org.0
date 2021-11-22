Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C69D458EB1
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbhKVMxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhKVMxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 07:53:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C22FA60F6F;
        Mon, 22 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637585409;
        bh=jkV15e+h13fqBlCOC03XHtk5plPiB5OzGsYSyYaXLEo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fyiqRK5g+KsmKmjO1IYdnncMAeo3L8OIEIDFNchMwdgFEK/vBfaE0Poje03bSMyMi
         3OAisRoTJkmA8u9xCYNVOPeA/ybViUEKiGfSZpFjsiFaZBbf+eljt2eqEjEkTEDsnC
         I3t1w0sq/fJaBDIE9qOAnYG8CksPLZ1kIRcGXFGJU6JKlQB8dle2ntDF8YXmxeduqS
         pPRrdD23uKjwZGSSHC+bq3wRmaFDF14eiZmIHsj4JJKe3HEvRBN9aon9J2OJdXQqYT
         xBMGHvsjcjr85kzT3NCF+ow3fqvIcCNmhpdMXz3nV5ymDlDlBCZEnOGYV9JaClG7UP
         WDJehxaXuhwyg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B399960A50;
        Mon, 22 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix internal delay applied to the
 wrong PAD config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758540972.16054.17356014346069605466.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 12:50:09 +0000
References: <20211119020350.32324-1-ansuelsmth@gmail.com>
In-Reply-To: <20211119020350.32324-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        noodles@earth.li, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 03:03:49 +0100 you wrote:
> With SGMII phy the internal delay is always applied to the PAD0 config.
> This is caused by the falling edge configuration that hardcode the reg
> to PAD0 (as the falling edge bits are present only in PAD0 reg)
> Move the delay configuration before the reg overwrite to correctly apply
> the delay.
> 
> Fixes: cef08115846e ("net: dsa: qca8k: set internal delay also for sgmii")
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: dsa: qca8k: fix internal delay applied to the wrong PAD config
    https://git.kernel.org/netdev/net/c/3b00a07c2443
  - [net,2/2] net: dsa: qca8k: fix MTU calculation
    https://git.kernel.org/netdev/net/c/65258b9d8cde

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


