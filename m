Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4A94788E9
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 11:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhLQKaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 05:30:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44584 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbhLQKaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 05:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC95B620FF;
        Fri, 17 Dec 2021 10:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C7ADC36AE8;
        Fri, 17 Dec 2021 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639737010;
        bh=LNUV5j03T7l6UOi08MpnJmz6o1Cr201IhdmPcf1FhD0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uTIPaJ+uz3VaZ5eLwjpeRKmP9iA7CLJZH/IJym4q4D/DmIbAo9Av+DlGYruM1LsKs
         XvwLRQkSfPIGbxxSXh9VI649vmvHtNR9mTWCX9F/VcQ1Kg4s7XWDxwm+9sPfINt8Vp
         2AO4TQYHqYwRprM/mjjlnu0rz1cTyxyRToGWuCuH+2BOYor+7W2nZhnCt9/36Rj9Cq
         tyYhdBSdP17nNRmW3at6z5HeqVRUh8pYXj/i5LFo/y7cr3bS8Oz1Z0GTnRIyLfALQs
         NkxJAwVAIaAgaBYzVGPqR5PaHqJ2NNkF6KXBoJ0tV/AnIo7EzrkJ+/mWPJ1coDCAZS
         i4P09l+DpSwfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4A3A360A39;
        Fri, 17 Dec 2021 10:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fix typo in a comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163973701029.8885.3534039765805911598.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 10:30:10 +0000
References: <20211216151916.12045-1-wangxiang@cdjrlc.com>
In-Reply-To: <20211216151916.12045-1-wangxiang@cdjrlc.com>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Dec 2021 23:19:16 +0800 you wrote:
> The double 'as' in a comment is repeated, thus it should be removed.
> 
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> ---
>  include/linux/netdevice.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: fix typo in a comment
    https://git.kernel.org/netdev/net/c/b62e3317b68d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


