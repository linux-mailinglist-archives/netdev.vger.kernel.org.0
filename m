Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9694646F47A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhLIUDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:03:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42166 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhLIUDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:03:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1A1CB8264D
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 20:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91BDBC341CA;
        Thu,  9 Dec 2021 20:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639080011;
        bh=k4e5vaMY3Akx9DBxzZH6dqi3LVi0C955ThA3wRlNuRE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=spUSXhwda0lPJIn2HK2hx0ChqTnDNgyUFwIxuIqEY00qNFxH3NsGnGAPToGQGXPkm
         uCKTFMnfyRbSO0wNlpoDT1WNlq+zbxSP7WZWsIXtf4CDXjeHW/onPkhEa9LOnPAg3k
         v6DGW7pbKlFWRGcW3zLz7t1QS/hNdnMj1l8Bm9CKY2E3HDerz3Ue+itUdbLTOgb4ts
         fstebIgDiLtSyl8QP53FB8yiTVPKgPUg2+fNfO1eV0mh0VJpbNoKd320zX7GNTanLN
         eMPD9On68by/kiCzwliq5rbhCN/u+kBKlu4DDZnMuPhgMaBtnyN0h8P8j5R8bFdRtL
         2u5FJUg1KwrmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6595060BE3;
        Thu,  9 Dec 2021 20:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: prefer 1000baseT over 1000baseKX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163908001141.24516.17236728183167042807.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 20:00:11 +0000
References: <E1muvFO-00F6jY-1K@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1muvFO-00F6jY-1K@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 08 Dec 2021 11:36:30 +0000 you wrote:
> The PHY settings table is supposed to be sorted by descending match
> priority - in other words, earlier entries are preferred over later
> entries.
> 
> The order of 1000baseKX/Full and 1000baseT/Full is such that we
> prefer 1000baseKX/Full over 1000baseT/Full, but 1000baseKX/Full is
> a lot rarer than 1000baseT/Full, and thus is much less likely to
> be preferred.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: prefer 1000baseT over 1000baseKX
    https://git.kernel.org/netdev/net-next/c/f20f94f7f52c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


