Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF8540F8DA
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhIQNLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhIQNL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 85C5F611C3;
        Fri, 17 Sep 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631884207;
        bh=rDTFn2UKx0UnyZmbSFXPTqMv4y3lllgPganfYTecDtc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ECT5r+g2vy8ryi7OX7EIY2jzHzRwairDR7G65ptIUk0n2vYgzIOF+8mGmaV80j3sT
         b5PV/tYYMizowx/6VSpiZJkLnD8nDo6eptRw8dpm70w3SoChBDlFRHL32DUT0i/YUW
         tTha+6X4jruOyOiJKSKF7+iBstzP6xRn05bZ2fqt0x7LyGCtkB2kRNxDOLG9CxuKfj
         ulZtCVVSsSRcE2/eMi0YCOyua43ppcCMqPP/lNla2OQi7r1ZFuxPhxvdRMFi29gIAc
         b/Fl62TJMYe9fBJfGJK66gUWLDWomkZqbaujGPhph1cH6625njH7hbi+m4QxR479MD
         da+6U8tD8KNUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 743F260965;
        Fri, 17 Sep 2021 13:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-af: Remove redundant initialization of
 variable blkaddr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163188420747.25822.3507781673338733348.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 13:10:07 +0000
References: <20210917120333.48074-1-colin.king@canonical.com>
In-Reply-To: <20210917120333.48074-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 13:03:33 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable blkaddr is being initialized with a value that is never
> read, it is being updated later on in a for-loop. The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] octeontx2-af: Remove redundant initialization of variable blkaddr
    https://git.kernel.org/netdev/net-next/c/3503e673db23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


