Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA11839AC5D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhFCVLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCVLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A8AFC613D8;
        Thu,  3 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622754605;
        bh=/bRQmt0sxcue7796eOi9ceQ8x3YstzGYaaFCKLQNMjQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Es5mn9GXyRIc32C6KglWG7tqaVHKoUMKQaIut/sXu9Ybejgi593KG+FqtCQYwL2n7
         4k8GRJ9vZY40LzlDJ2eygDKJTUUhO3Q+WXETL151rS5vVPGDa1xgEFGDKQSfjvqN0z
         eWeBv0CznLFNoShPoEKZ5yQiWg7Xa7kXkhtRo7TatInNMJDPW1fGrOISNA1bEvaNON
         trik1zt6uXnWKh2lFkySlU3lVgBxOFiqAXTW/jBjjbCuuvMsBM094XWd9Eq5AHTQo+
         EAIzbLfPhYoYfQPbdzipGzmz0rFcBeP9CQNzvwBdTWQAtocwr2CrBgmBbZAO4ee1RN
         KZGWl99/nAUkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 972C160BFB;
        Thu,  3 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 0/3] tipc: some small cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275460561.4513.13797813713363151788.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:10:05 +0000
References: <20210602174426.870536-1-jmaloy@redhat.com>
In-Reply-To: <20210602174426.870536-1-jmaloy@redhat.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 13:44:23 -0400 you wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> We make some minor code cleanups and improvements.
> 
> ---
> v2: Changed value of TIPC_ANY_SCOPE macro in patch #3
>     to avoid compiler warning
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] tipc: eliminate redundant fields in struct tipc_sock
    https://git.kernel.org/netdev/net-next/c/14623e005a1e
  - [net-next,v2,2/3] tipc: refactor function tipc_sk_anc_data_recv()
    https://git.kernel.org/netdev/net-next/c/62633c2f17f1
  - [net-next,v2,3/3] tipc: simplify handling of lookup scope during multicast message reception
    https://git.kernel.org/netdev/net-next/c/5ef213258ddf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


