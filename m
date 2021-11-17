Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07B145497A
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhKQPDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:03:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238256AbhKQPDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 10:03:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 95C0661B7D;
        Wed, 17 Nov 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637161209;
        bh=Crfcd/udbpEjJbyZZeoiDhRHqFCIMc3KbpapY4dzkdI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mDRurjLW8cFptmKJN2pKtbkc9Kbp/QDfhiFlhzrnXdPw7P8keUD5l6VyGtoFHSwTD
         NKPblWrIU4YrNVn/TV3N87h0SE8FLE0m3e/WHoiRcB7PDJCAdAD9xsFI/fY/D4XSE2
         J4GKmhhLdI4ysp96a8Pv0Gc3w6CtX1fzrBuQGs6VtAFVkow323hknl5mZE7tKakQ+V
         zQx8PJ3+AV8IQAAnuuAwQM1Coe6Opr0La5HcTY82dEsyI3/WGOMuEm3XtHzoMDrSs+
         H0d2gkEXL5l+YxwuYwcfGOKpSk0sKF70huqMzXBX0+x+kfhZJrPIobB0Bi8lGpLhru
         /0gS4KDf660CA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 900E06095D;
        Wed, 17 Nov 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ax88796c: use bit numbers insetad of bit masks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716120958.17032.3612163317832202.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 15:00:09 +0000
References: <20211116212916.820183-1-l.stelmach@samsung.com>
In-Reply-To: <20211116212916.820183-1-l.stelmach@samsung.com>
To:     =?utf-8?q?=C5=81ukasz_Stelmach_=3Cl=2Estelmach=40samsung=2Ecom=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, m.szyprowski@samsung.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 22:29:15 +0100 you wrote:
> Change the values of EVENT_* constants from bit masks to bit numbers as
> accepted by {clear,set,test}_bit() functions.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  drivers/net/ethernet/asix/ax88796c_main.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net: ax88796c: use bit numbers insetad of bit masks
    https://git.kernel.org/netdev/net/c/c366ce28750e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


