Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5218540296F
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344697AbhIGNLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344507AbhIGNLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 09:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 832E660524;
        Tue,  7 Sep 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631020206;
        bh=TS0Q+JC5+rbsAfXB/DgZ/VfullCGD0MlVd1QbRr/ckk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ij5ydPCxaCWxFVvcK+lEHOY3HUKAtqsHaYDwBDH+Tkx4nSfsVJXmyWuiVMgxMol0M
         W6rKtxoU53Bg+xu+lF1X2vpOftCpOiK+OJmaB//z2GAchT6lr7mG2SlzuX0dNqFWwP
         YuOcpjX8o8NbzO1BMNj/91hmp5+6dXccrXGvWhzhYB3iP49C724V8sz9PXeCOc/aQG
         b2bmLIqucO2StXgvj2mObNXVWLARhMafbGxVMqitDajCWYAhO3Pk+1gBJbLxMK4sh7
         rUGDaTodewaYxbJqBz18vklkw4KKidJa8GnIiMy7i1UjaznBBQIGtePqstTWlxLDaM
         HWjC+IpR/4W4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A4FA60A6D;
        Tue,  7 Sep 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ieee802154: Remove redundant initialization of variable ret
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163102020649.3494.1324550414949481903.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Sep 2021 13:10:06 +0000
References: <20210907102814.14169-1-colin.king@canonical.com>
In-Reply-To: <20210907102814.14169-1-colin.king@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 11:28:14 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never read, it
> is being updated later on. The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - ieee802154: Remove redundant initialization of variable ret
    https://git.kernel.org/netdev/net/c/0f77f2defaf6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


