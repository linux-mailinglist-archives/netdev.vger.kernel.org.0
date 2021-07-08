Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC7A3C1AD7
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhGHVMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhGHVMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 17:12:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6737F61879;
        Thu,  8 Jul 2021 21:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625778603;
        bh=ycO46sPn9SF/y2HH4YmUKWneyoVGQpxdzkURV02pbG0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=drer0/uoE6R0++zh6+i/AzY6ojbKOoqTtwfgfKFY0U38eMYNSVn3FlnyhpZ/TJaZa
         gWAPmL9WjRlmJwMWdeMMeZQ+vrQWk3Bz4T5EGoW1muo1Cwz2c0nKuyxU8poUA4Oku0
         /0IId0uodJx4gkELqyvnjg3bzwsRcPK/aGicBEvSxI0ujL+4eo5uDsfFDgIWlw7jI6
         SLEQgXDvyIZsl/TF642MPQSMWUWdDe4IgymZ4JjC5StQEMS1/xVm/OiBTcqFLtSypX
         Fczd//CfdaH1mWLv07fqdO1gye+oa0xyq+4/2ac/wv9paDehPEzieK7w5uHxHCW/iX
         C73tRAsvrHAhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D40A60A4D;
        Thu,  8 Jul 2021 21:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: microchip: sparx5: fix kconfig warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162577860337.27238.17965837673029609536.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 21:10:03 +0000
References: <20210708173310.7370-1-rdunlap@infradead.org>
In-Reply-To: <20210708173310.7370-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Jul 2021 10:33:10 -0700 you wrote:
> PHY_SPARX5_SERDES depends on OF so SPARX5_SWITCH should also depend
> on OF since 'select' does not follow any dependencies.
> 
> WARNING: unmet direct dependencies detected for PHY_SPARX5_SERDES
>   Depends on [n]: (ARCH_SPARX5 || COMPILE_TEST [=n]) && OF [=n] && HAS_IOMEM [=y]
>   Selected by [y]:
>   - SPARX5_SWITCH [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICROCHIP [=y] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
> 
> [...]

Here is the summary with links:
  - [net-next] net: microchip: sparx5: fix kconfig warning
    https://git.kernel.org/netdev/net/c/96248d6da657

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


