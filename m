Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCADC37EEA1
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442129AbhELV4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239858AbhELVlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7693F6142F;
        Wed, 12 May 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620855609;
        bh=1Lqxn84H64+ezBbhQnDG/tO26vWLXPKn8CQET9Vg6a4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QkO6cnpibqiK77uHnTSQ0WSZ+WGDr0KE01KntBRReohrFoFqCzzB30s4oWp+EFHDt
         AcGCochY+mYm/zqGUu+FZgvXkrBRjQ7q6HYjdavqXP5mhQV+NiJknQjlculh6ZXz/a
         L34aNlmF4qMclgaJt64tIwJdEJrijiT4UlhLThOa1uqUo0LdzrUfKcAq86HlWgRGXQ
         2uDHBkMk1wA91n3nAvz5GFgEg/YXTdBGJ8gBq28pmdHOFtzcdZRMUoKF9S0r2BK3os
         eyIU6+pc4hbFp3dirrBxenib/ZeMSJVsLXohfpkY4H9Ho1LNkBA33WSZWGOGSTfWkd
         WZ1U2L2B/hx+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68CF260A23;
        Wed, 12 May 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] chelsio/chtls: unlock on error in chtls_pt_recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085560942.18109.197930634344340062.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:40:09 +0000
References: <YJunyKKpMGnT/Ms/@mwanda>
In-Reply-To: <YJunyKKpMGnT/Ms/@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     ayush.sawal@chelsio.com, rohitm@chelsio.com,
        vinay.yadav@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 12 May 2021 13:02:48 +0300 you wrote:
> This error path needs to release some memory and call release_sock(sk);
> before returning.
> 
> Fixes: 6919a8264a32 ("Crypto/chtls: add/delete TLS header in driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] chelsio/chtls: unlock on error in chtls_pt_recvmsg()
    https://git.kernel.org/netdev/net/c/832ce924b1a1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


