Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781033FFEB7
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349012AbhICLLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348679AbhICLLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 07:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B74D4610E7;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630667406;
        bh=b6DmMxFQoRat6nGxgdS77F7cJDlwEUEPp+gDtbPf0uw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZYcJgG84S5W/URNHOmZFeBRgazNh5jx/LmCOzENB2ryitVyMSg5hO7H6/86vkrGFv
         InhFKW2P6nIrYfNTqYcOr2QggmTMHd1Zq2MvmPgOYEYyV/ymTOJ7UfGSjj+90rjuiZ
         Tit8lPi7Ew1azPTES/gnuWHyOqPenQFJIopG8UatTQYez8D4K7F8QXkPU1LlDeEfeb
         7wHEcSs8RINHewPKGA6vsLDsyz1GnmPt5O2tFRNmo+1/dju1TJ+sTQcIHW0kTxiPrT
         YLewAg5DQYRxUsPEinuFQ1pUHP11KFztIHlooNBR2ZvJIwBXPszVTgE2t975xDTjbT
         wxKSNP5bxbCGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B048460A49;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: 3com: 3c59x: clean up inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163066740671.18620.507463871873218138.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 11:10:06 +0000
References: <20210902221745.56194-1-colin.king@canonical.com>
In-Reply-To: <20210902221745.56194-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     klassert@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 23:17:45 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a statement that is not indented correctly, add in the
> missing tab.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - net: 3com: 3c59x: clean up inconsistent indenting
    https://git.kernel.org/netdev/net/c/743238892156

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


