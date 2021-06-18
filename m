Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CC73AD24C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbhFRSmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231617AbhFRSmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 14:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 003F061175;
        Fri, 18 Jun 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624041605;
        bh=VAfuWVKUPi3vtXy5DceYRC/mCcnNDVHNu0te44kXmyM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TRHVU4q/EU+toboE8pHG/DMD70sjTLqKeWdnoUrY7jBqjAuEw2g/11rLmDRJY2Cr5
         2Y5duKZypxcvZdhcqtYff1MmwmTj7WBMi4+h6BW3u58YDJgFE1BizhynRbD4dONIUt
         gKEtSKEhJFr80tg+LOzaHJ7gKrPG/Qyx05v8JqsOabgOTwe+8DVg65fuiN1fZWNfu1
         7QT+8mcggoErrZxZ/NyoP8i8mCZxOyyLTpltqr28t0R9De7wxAjFHZjIeYam5TyKd9
         bUkEPruYhwngwqUtYyoHF1Ub1l//+ZtOwuBa7bU+EQ9HtASVeGrkSMfM1nhFB/YJ6Y
         hVC6KJWm9n9hg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E798260A17;
        Fri, 18 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: neterion: vxge: remove redundant continue statement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404160494.23407.1819293520423665241.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 18:40:04 +0000
References: <20210617121449.12496-1-colin.king@canonical.com>
In-Reply-To: <20210617121449.12496-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 13:14:49 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The continue statement at the end of a for-loop has no effect,
> invert the if expression and remove the continue.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - net: neterion: vxge: remove redundant continue statement
    https://git.kernel.org/netdev/net-next/c/d1434cf51358

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


