Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E97397D92
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbhFBAMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235267AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 44116613D7;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=GL4+ucwIjyp80vawKes7lgQ+7FdYlowqRGWpZ/xgcf8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kcxEq+j7FbMZqrORGL/IfHicMQQtgc2MWciKCZq/WGvvr17yYfp1Xaj9giIu4VqwA
         fGQsfZbHLXEEj74kSxTGn/RwbjuOmx6yqfXyqftuQMbcaneLp4GU/tPoSING/nEjpm
         YRaEPdA6oxpeJcHabrmD+X5wzH6iELmf+DpC6eQ0U5rtKQJzOoY39gvgWihS0iTO/j
         Z6bWXXZZ1xCt15Uo+UMwDtSIT09VNnSFT/pK5x+ddF6qvUYC82JddKLfJG6DqXPVzX
         TxaoSvDtck7UgvYXJzTXUFtrqzUaBhhnpyJEg7q4rPRRYoVi06cnrnjgNm6rNGKEVX
         d3JpfP4xMy/0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3CEE360BFB;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dcb: Return the correct errno code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260824.22595.14975192070822553857.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601141358.4131155-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601141358.4131155-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:13:58 +0800 you wrote:
> When kalloc or kmemdup failed, should return ENOMEM rather than ENOBUF.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/dcb/dcbnl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: dcb: Return the correct errno code
    https://git.kernel.org/netdev/net-next/c/b923cda96388

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


