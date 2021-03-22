Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4748D345323
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhCVXkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230363AbhCVXkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 19:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A93E619A5;
        Mon, 22 Mar 2021 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616456408;
        bh=k9n/0XdmhH7SmFqauapbeH2d87GHvGAqr/ktpjaMQ5A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hSlBqg7fkTbQrARNQR4ylJZI14NGtgG6fWz7OCrMk6rYaVFQ6krqKrOtAmQLGR1Tl
         Wf1qtyCAO0cB7DVwf1N0wGAyr5X8+uN6qt2WO6zKlLzyUhiQ9jYNsAZdB6zvUMkUX1
         4MvrGsbXcoWJnVUsieXitKzZ1t8JVI9poK3dnBf19mMXqxSa4mAPeARX7pV0IPJqH4
         S8fNv3yNu+BDz61QKPNfo8X4xWaoErYSIK4tjgTlFq7psdJoUzj/8OmG2wf0HCM/O3
         FMvzlZlQ36INBezY7pcLX38EId7sG86Zcf6NwSyS1IoZTBaeAcN1vHJTpYKbage18c
         7l5VhTbDvWBJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 09C1760A1B;
        Mon, 22 Mar 2021 23:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipconfig: ic_dev can be NULL in ic_close_devs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645640803.10796.17856929136475519623.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 23:40:08 +0000
References: <20210322002637.3412657-1-olteanv@gmail.com>
In-Reply-To: <20210322002637.3412657-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, f.fainelli@gmail.com,
        andrew@lunn.ch, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 22 Mar 2021 02:26:37 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> ic_close_dev contains a generalization of the logic to not close a
> network interface if it's the host port for a DSA switch. This logic is
> disguised behind an iteration through the lowers of ic_dev in
> ic_close_dev.
> 
> [...]

Here is the summary with links:
  - [net] net: ipconfig: ic_dev can be NULL in ic_close_devs
    https://git.kernel.org/netdev/net/c/a50a151e311b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


