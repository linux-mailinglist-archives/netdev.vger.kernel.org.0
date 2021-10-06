Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B2F424022
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbhJFOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238845AbhJFOcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0134761184;
        Wed,  6 Oct 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633530609;
        bh=4jvK/nmspZrfJBq/pbN/ZJRLBgnxiuFMV/CHx8s2m7I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BRi44otg2mm+82G3xirgA1gfIzupGzmtmmU8nrCTJ9Pg7tlOlnb84HXPqQkyFeZbv
         WVwMS/98Mrvah3f5WIzM73ga6CHak8mQMPSJerKTvnyp8nW/InT/HVWWc+3aIuhw0h
         fJNrbMCa3Ip/qwVvNvMGwXOwNse2drdbKqO26tH3mGyDDnYX7Up5s1H4O+TQSkcYNM
         4vvYe7JDN2Lzo77Ucq8yaGth/7ceEaJGY6lfksBjKkp94KkZZEHdQdi0wjgsdLqxXY
         abtyWnqhSPLh2Uy3dcjvfyAewxF6YhJvV1QZOPYbH6PgRw2CrKj/qxYKbjUoO63CcF
         ndkzvqVOUHqEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF24160A44;
        Wed,  6 Oct 2021 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] qed: Fix spelling mistake "ctx_bsaed" -> "ctx_based"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353060897.19239.16281796436705585007.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:30:08 +0000
References: <20211006084955.350530-1-colin.king@canonical.com>
In-Reply-To: <20211006084955.350530-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  6 Oct 2021 09:49:55 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a DP_VERBOSE message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] qed: Fix spelling mistake "ctx_bsaed" -> "ctx_based"
    https://git.kernel.org/netdev/net-next/c/9cbfc51af026

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


