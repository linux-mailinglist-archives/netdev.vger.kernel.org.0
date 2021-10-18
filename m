Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E880431BE8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhJRNgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232285AbhJRNeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 589A5613A9;
        Mon, 18 Oct 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634563810;
        bh=YcQxKFgOwG4U9no21lMH48UCdQH7udic8FNxaAaqmt0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cXy+JO69QXzKNv8cgT0gT+0q0mJ5g30pxpRQtr7sKLO22qg7zG3790kc0HFpASVIU
         AwPhkwWFmcBnr7JhpypNIKbgE9eNR0PsNEsxhm0v3JX2OjWweTIh8Ps2DF+8tjshnH
         TyfJDJib97894gYGecnMBKUxhqpDsFgswS7AEiwuAZN0gsXCVlG7l1v8tcq+BNnogD
         QdKKWFn9NRLECh1bYz1TiGdU1BlOlDa/+WMDnbwYoHnaKyzCxiUVIgWd3s70TVOZ28
         Z7yj478DaMQfl/V5T0sdVVfWfU/QaUlas8e0q5nw25sqBdyTcySS8xEDn1pyYOAy1f
         Wa/lRj6zTleZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F8E5609E4;
        Mon, 18 Oct 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc: Fix reading non-legacy supported link modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456381032.15402.834559957967695883.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 13:30:10 +0000
References: <20211017171657.85724-1-erik@kryo.se>
In-Reply-To: <20211017171657.85724-1-erik@kryo.se>
To:     Erik Ekman <erik@kryo.se>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 17 Oct 2021 19:16:57 +0200 you wrote:
> Everything except the first 32 bits was lost when the pause flags were
> added. This makes the 50000baseCR2 mode flag (bit 34) not appear.
> 
> I have tested this with a 10G card (SFN5122F-R7) by modifying it to
> return a non-legacy link mode (10000baseCR).
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>
> 
> [...]

Here is the summary with links:
  - sfc: Fix reading non-legacy supported link modes
    https://git.kernel.org/netdev/net-next/c/041c61488236

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


