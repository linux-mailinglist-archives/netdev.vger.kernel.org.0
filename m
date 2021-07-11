Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C141B3C3E33
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 19:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhGKRMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 13:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhGKRMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 13:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B87F461108;
        Sun, 11 Jul 2021 17:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626023403;
        bh=T0DWwkHMfMCk8CidjvkzgZlQcRuKkKHVseD/+xd32UE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hlSrsrcijNNeCi6goMT0Vr9eHLK5K6gVO1zvr6UePQW1lp0+JtYQ8upOlXm10ouOv
         EkbNVbmqW7VHI8geUkThXg0DID9Q/JWQzbARQRkcA8Vu0mVMR3dmQzQrV/o5G8ZGm/
         jOiPQXl+Cc3+1x+b2wx4hsAGi76fyiRC/ok5DLsbJmO9TohTKMKbRjvnLZtP9EC+Sh
         ZAZYYw8mAMaaWrlszGx6DK/OsVMGAjWFp5LbIUg6lXki361WXM8aJSOVFKeBv5b8Dm
         bq6As4EQD7fwxsgmRKOl5fG9uOBIjR9I4aDKkyAoLdiAufVBSU+TC0D8q8y6Q8/x/j
         7xHRKtOXB2vCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A6E0160A0C;
        Sun, 11 Jul 2021 17:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: marvell10g: fix differentiation of 88X3310 from
 88X3340
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162602340367.16607.5987179891891595336.git-patchwork-notify@kernel.org>
Date:   Sun, 11 Jul 2021 17:10:03 +0000
References: <20210711163815.19844-1-kabel@kernel.org>
In-Reply-To: <20210711163815.19844-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk, andrew@lunn.ch,
        davem@davemloft.net, kuba@kernel.org, mcroce@linux.microsoft.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 11 Jul 2021 18:38:15 +0200 you wrote:
> It seems that we cannot differentiate 88X3310 from 88X3340 by simply
> looking at bit 3 of revision ID. This only works on revisions A0 and A1.
> On revision B0, this bit is always 1.
> 
> Instead use the 3.d00d register for differentiation, since this register
> contains information about number of ports on the device.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340
    https://git.kernel.org/netdev/net/c/a5de4be0aaaa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


