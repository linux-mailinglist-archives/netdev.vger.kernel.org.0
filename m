Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC723254C1
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhBYRuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 12:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232237AbhBYRur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 12:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7467664F2F;
        Thu, 25 Feb 2021 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614275407;
        bh=HGZf4wD+9SOJFs9WegPWYrqiO6JXVwTAhHqsRSUtSDY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uqj57k/TvNUKhiNBepHLh6c1SW+Uog71DDfJVO6KkV7KQREY2mx/5/IYxW4gUMv9n
         HC1M7NP0f77X9wUT1xGM8sDXhD32Si8W0LKVU5Vrj7JG6lPHIBuuhaXw1uXWNj6E+h
         mbsEfWu3K0IdWVO9UqibS1Kf9R9ApnQRIPIXru4yHF/JEN9Ku28bJ6lrStN/aRMwY/
         j1Zv0G5BEvjeuuV5H/piynF9CVgH19YQnwiO6ETlumqyH0w2Y8vVOKmfgPypoBK2TN
         dqza7Z8EtxKhw9tT/01+JrwT4ut4LwLLz4OqZlRlTZefiGpSD5lL8rZG6ZGUVezH3A
         wWyRLm+PEO5SA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6862660A10;
        Thu, 25 Feb 2021 17:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: sja1105: Remove unneeded cast in sja1105_crc32()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161427540742.4743.13860069967965207667.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Feb 2021 17:50:07 +0000
References: <20210223112003.2223332-1-geert+renesas@glider.be>
In-Reply-To: <20210223112003.2223332-1-geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 23 Feb 2021 12:20:03 +0100 you wrote:
> sja1105_unpack() takes a "const void *buf" as its first parameter, so
> there is no need to cast away the "const" of the "buf" variable before
> calling it.
> 
> Drop the cast, as it prevents the compiler performing some checks.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> [...]

Here is the summary with links:
  - net: dsa: sja1105: Remove unneeded cast in sja1105_crc32()
    https://git.kernel.org/netdev/net/c/fcd4ba3bcba7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


