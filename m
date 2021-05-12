Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCADF37EE8B
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240236AbhELVw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237691AbhELVLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C4E9361428;
        Wed, 12 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620853810;
        bh=cyLh9qw8T4SCn3I4q6HRtt8w7L6qy334n3YIsO2B4eI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a+qFWytqlmOHR3o/TvH02n99ZEmf+DH4TLWBjmgegXCRcpgIRZXRin31f0E+8uqcb
         rh3BpH6F0LPLkey1VQRMaHXSmziaPnJldoazgB0hvVjBLV4Dvmn0S2LoU/aLsIKwYl
         TyzrVWQBNm1osiuf/TgvemUXm6MjMlkeFxmMVv4A+hamksu48m2SSWbNOdmoLd7fJo
         BhdI9hUYdpbsGm704ZQGECHC5pp1Yf0ASaYRmyO/EAC3i9icytAd+P2AqJ8ryOg5vZ
         HUNR7cU6oFhCspSO/Pfe7W2K/AuqeMvXCqUcMxLp6a7q7xOLSfGgtFkV4u/qAOYtIh
         lTiKftP7OF7Dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B6530609D8;
        Wed, 12 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-pf: fix a buffer overflow in
 otx2_set_rxfh_context()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085381074.5514.7569325730400775140.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:10:10 +0000
References: <YJup3/Ih2vIOXK2R@mwanda>
In-Reply-To: <YJup3/Ih2vIOXK2R@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 12 May 2021 13:11:43 +0300 you wrote:
> This function is called from ethtool_set_rxfh() and "*rss_context"
> comes from the user.  Add some bounds checking to prevent memory
> corruption.
> 
> Fixes: 81a4362016e7 ("octeontx2-pf: Add RSS multi group support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-pf: fix a buffer overflow in otx2_set_rxfh_context()
    https://git.kernel.org/netdev/net/c/e5cc361e2164

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


