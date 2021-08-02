Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5E73DD2FB
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhHBJa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232855AbhHBJaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 05:30:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 81C44610CE;
        Mon,  2 Aug 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627896606;
        bh=8pmS78nH0Gs+QBVFcw890adFMY5Pf7CbCNmyYhP7wPw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NqZF8jKZNjEiygcdn5RMw/xzLaemjbzRLhHhjUaadu+78h6qB20Ulb1QGCdk7GfQs
         PnEvsKYK0V91wZ/lMX3DE5XcEKqIezXkgzIxnx0TIVWY7Ruf0B5jxjCVq8ajXkSAsX
         FOiQPj9JEXCoWK7nseAJt0bunQH2hDLweIS7n+8g0Vuag4jTwQ4eHbD0vi94STIxQY
         t6/+fEB5zF+HdwdGTStPU98ciPHsHrLN4ECnL+Mg3LgHIc/zC984fk2D4QS14ziNYI
         9xtoCzKth1tqgr/1JR0ecz6qwuKXvxySjdjDKNCsoHUfgXUqZe7hvm2ByANO2YC9Of
         rV/FJBm2klhrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7C3CD60A54;
        Mon,  2 Aug 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] niu: read property length only if we use it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162789660650.5679.12923624139744072169.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 09:30:06 +0000
References: <20210729074354.557-1-martin@kaiser.cx>
In-Reply-To: <20210729074354.557-1-martin@kaiser.cx>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 09:43:54 +0200 you wrote:
> In three places, the driver calls of_get_property and reads the property
> length although the length is not used. Update the calls to not request
> the length.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
>  drivers/net/ethernet/sun/niu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - niu: read property length only if we use it
    https://git.kernel.org/netdev/net-next/c/451395f798a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


