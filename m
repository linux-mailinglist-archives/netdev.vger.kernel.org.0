Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B811311FD6
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhBFUAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhBFUAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 15:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8028B64E0D;
        Sat,  6 Feb 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612641607;
        bh=UN3I3fIRRLeRDUTSRvFcTcBBIec5adnRWkvU2+xhVuo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aguzTcBgVmK/2UIKwZvm487d216WdgcsXteussoN8XD6l3CvkhjATxHRpxKAyji+S
         fOuOBOe8qRcHteBGIr8NHdLtHgwuS0f8uVY0DxGehkDUUQ37XLAnXDbUs84XzObOpV
         tR/V/XincXdWRMNMvL7hnT9wwWfgN2HQlqWNJf0iD6f1X+viun7V3DK1sf8S43U5aw
         cUTtYCpAEDIG8+qJyjKre4TuIz2GXoVLIaSgC1tDRy7fEA1j/yB45QksHDCP3gOnKR
         ykgzKetaYE8vXLMxJXw0hk78pdLThst7qvgY30MnjXqQced8NI/VDGEGVGp+Lw2u5T
         JyrnE4ukvzoxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B09460978;
        Sat,  6 Feb 2021 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dwc-xlgmac: Fix spelling mistake in function name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161264160743.7562.14819937782766031642.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 20:00:07 +0000
References: <20210204094944.51460-1-colin.king@canonical.com>
In-Reply-To: <20210204094944.51460-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Jose.Abreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  4 Feb 2021 09:49:44 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in the function name alloc_channles_and_rings.
> Fix this by renaming it to alloc_channels_and_rings.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - net: dwc-xlgmac: Fix spelling mistake in function name
    https://git.kernel.org/netdev/net-next/c/a455fcd7c770

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


