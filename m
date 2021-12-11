Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCC1471181
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 05:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbhLKEnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 23:43:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48906 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhLKEnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 23:43:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45A41B80066;
        Sat, 11 Dec 2021 04:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 126F8C004DD;
        Sat, 11 Dec 2021 04:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639197609;
        bh=xeW3bwmw915rvkG8+C1VkMRTOUA/n3gUWRrH6yU+qyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R97+SI3fiUcWCOcHQ85J+5tH2icEjmI1kUknJ13a7oJhTWtwdKT4u0zOr2zehutUb
         4BpDp3eRWCwIjAAugEQuVyyN6H5M1pjLrf09s90ZGWfHh0ZWp3RHx5WMmCC6UGh7OF
         JlYxYjR5rslt/CMwVMkkYqm1lFWWATfnBjMMT1zqoEi6cz4m15pSdRfAWHUccpcQIK
         D+A44t3S+7rrWrh076gIqR0xA73IWtKCh6X1fHmY3PxDGESLeQKjPRZPtGu0vXEW8y
         +UuM176cKrN8dKMMdjk+aIrkf88dnRpT6FdKTOP/3Qa2jIrLWRH6nuggS9r1yD31IN
         qgj1C6i+FWqYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EA0B260A4F;
        Sat, 11 Dec 2021 04:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Phonet: refcount leak in pep_sock_accep
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163919760895.24757.1184327103179847593.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 04:40:08 +0000
References: <20211209082839.33985-1-hbh25y@gmail.com>
In-Reply-To: <20211209082839.33985-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     courmisch@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 16:28:39 +0800 you wrote:
> sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
> invoked in subsequent failure branches(pep_accept_conn() != 0).
> 
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/phonet/pep.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] Phonet: refcount leak in pep_sock_accep
    https://git.kernel.org/netdev/net/c/bcd0f9335332

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


