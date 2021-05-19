Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF98D38978C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhESULc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232832AbhESULa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:11:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A8A6E6135C;
        Wed, 19 May 2021 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621455009;
        bh=LVv35J+SVIysPkAjL2LeQM1KmjYIFwyN9ZE3IxwnS+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=smx+qElOyVEZyxtYzyazl3fACrxt7LgzDJH/nsOV6sJoDbDdUxfNjibNB6zkf5r43
         CZpCjiku9VidEFn8NnTpTUfvB4D2IEKQFn0BLz1tWLl3kqgNhNy2PnvYFNcGiD/Qmj
         RVxf9PeeMTwuiMBmvPh1Fe9/O3YgwfUXbrQOb+VCDKMYTVQ3O1ZCkmOIUPCUI3GWef
         2zisQ1awdpuCRAVOWMrjjcdzub9Z6rB/75tf07xpPCAl5Szy0wX8torg/htlziyfy8
         dP0XiGnbqXXoGXekM1ya9OGZSsJvTBwCF3jgPMxIm2k+u3DbFhREpX/cd6la+EY54t
         6djXUSCQecMhg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C1C660CD2;
        Wed, 19 May 2021 20:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: avoid accessing registers when clearing filters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145500963.9091.12672013796670658821.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 20:10:09 +0000
References: <20210519111831.12478-1-rajur@chelsio.com>
In-Reply-To: <20210519111831.12478-1-rajur@chelsio.com>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 19 May 2021 16:48:31 +0530 you wrote:
> Hardware register having the server TID base can contain
> invalid values when adapter is in bad state (for example,
> due to AER fatal error). Reading these invalid values in the
> register can lead to out-of-bound memory access. So, fix
> by using the saved server TID base when clearing filters.
> 
> Fixes: b1a79360ee86 ("cxgb4: Delete all hash and TCAM filters before resource cleanup")
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: avoid accessing registers when clearing filters
    https://git.kernel.org/netdev/net/c/88c380df84fb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


