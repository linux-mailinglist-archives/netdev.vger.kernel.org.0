Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6891E3E1243
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbhHEKKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240361AbhHEKKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 06:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E2E7A6105A;
        Thu,  5 Aug 2021 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628158206;
        bh=LdDU1hP7nfKV0oIxWUczwubMmAzkHkKxMQJ6M4XkNc8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W7va8qbYM0uNpVRMqT/V7mC1BBmI5UQDMyxJkBURsiYBoZFpb7IAFk79kZ7sAsnpk
         sfbmSe2y427cBD7zpr4+VG57/g85vaeAfN8NZwj2VTahcDGcdo0HfO/MyA824dPBl7
         h7fhsHKhNAU2Cz2B5XAENmQISdpH4nYRWisDhBOY3Bn393XFQzXDDal8rTRAR/y88V
         BZ/1f80pSuSSnrX+dyT9ORwg9WqWDwibTaKIP+/u5ml73jneZsAN6lFjEjKJYpc6zP
         E/Gq/Z2xVx/yVUc2iigBREoX8k1pJBNTbe4iFPvswNJUe1wg5zB+yfvyp/nWSDKr/d
         UbvH/nKg9582A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D29F960A88;
        Thu,  5 Aug 2021 10:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: fix IPA v4.9 interconnects
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162815820685.2686.2694998463518499326.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 10:10:06 +0000
References: <20210804135407.1358606-1-elder@linaro.org>
In-Reply-To: <20210804135407.1358606-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  4 Aug 2021 08:54:07 -0500 you wrote:
> Three interconnects are defined for IPA version 4.9, but there
> should only be two.  They should also use names that match what's
> used for other platforms (and specified in the Device Tree binding).
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/ipa_data-v4.9.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next] net: ipa: fix IPA v4.9 interconnects
    https://git.kernel.org/netdev/net-next/c/0fd75f5760b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


