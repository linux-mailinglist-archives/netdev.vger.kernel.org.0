Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CC1362805
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhDPSug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231510AbhDPSue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 839A46124B;
        Fri, 16 Apr 2021 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599009;
        bh=svvE4OMxykgkqb6b0ifvshCmX1Ltbn3ev/kuonLzjBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bxv/TIdZFLiY+NwFlRv76btSSk+XaQR75nFof15p1tx2ZdKokakvYWCGXP/ceyTHd
         mBVXH53JU+p94ioTrblzae3ZSovzm3AaU62if5KTjQFLs46H3tda4wTUFLZo/wYm7S
         gM5/qneXQFfeB/Ttl/U6gDfm2R4OvsN+ajm1bltnzMvJZoNtLWay2gnTA+lAHF6v/n
         FaGh+y2MFDDAnscSRc/uObH0GM8aSHgIYgamVsX6QULqjqEe0ecilSlW46a1ntFVCY
         gfJde//dltju8Uh8uynOefq0YAYHFLimuaz3hl8yAcH0vlMDwMJc6DotmTTvHII7bX
         tD1UMogU01F5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 72FF160CD4;
        Fri, 16 Apr 2021 18:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] scm: fix a typo in put_cmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161859900946.24076.5130171755963195214.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 18:50:09 +0000
References: <20210416183538.1194197-1-eric.dumazet@gmail.com>
In-Reply-To: <20210416183538.1194197-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 11:35:38 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We need to store cmlen instead of len in cm->cmsg_len.
> 
> Fixes: 38ebcf5096a8 ("scm: optimize put_cmsg()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] scm: fix a typo in put_cmsg()
    https://git.kernel.org/netdev/net-next/c/e7ad33fa7bc5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


