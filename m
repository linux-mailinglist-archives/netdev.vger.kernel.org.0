Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1B41D9D3
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350882AbhI3Mb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350807AbhI3Mbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3AB92617E5;
        Thu, 30 Sep 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633005008;
        bh=TezYo0sj/9Omo4ncoa+BczOs/YNSjMI0iKoxDFWsx9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b9egAGop+8NAuLqftBCM2sBs0/yOY1SFumYdomUlia6p/aRRfM+TZAc+zQ6A2Xj33
         VMTB9RKQXvpPF5N11RGoSRra3Uo8c0aoscYzVfef0w9frTtgijMPqPwkHdi/zEJVp7
         /L3XG23TGbjGnsAO1CXLKP5NYvE8xQw5f6Be1U/tpsY7VhAKmEyAwN2IczK8hTVihe
         ndBld/7rkL5c4gFNAEQQKqH1e15WveKikCUICw0U78JepmyyXkyAKBjv6dMwq2eskK
         AP9IzwZetDEePqFj3JQqrnzZOKITPrwTEO3cuPjNNspg6ETgVdHQ6IoqqSI7HX+e0L
         us0SlKkdI+j6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 34E9760A3C;
        Thu, 30 Sep 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phy: marvell10g: add downshift tunable
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300500821.24074.11476501072018988742.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:30:08 +0000
References: <E1mVbVt-0004Fh-Dv@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mVbVt-0004Fh-Dv@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kabel@kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 16:28:53 +0100 you wrote:
> Add support for the downshift tunable for the Marvell 88x3310 PHY.
> Downshift is only usable with firmware 0.3.5.0 and later.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> v2: updated comment
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phy: marvell10g: add downshift tunable support
    https://git.kernel.org/netdev/net-next/c/4075a6a047bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


