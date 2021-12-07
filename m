Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296D946AF4D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378629AbhLGAnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378612AbhLGAnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:43:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3841CC0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4F09CE194B
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 00:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFD1BC341CB;
        Tue,  7 Dec 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638837609;
        bh=49RQQoceVLaeZk1kiDZ9ZmyEJ7q87iCUvRq7UQ9b1lI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RWSyDDMGtVt1OVKob65TSU2lfAhCLFVHSk4gAB0IA6n1oW5E8RlxznEBtyQrq+xiE
         Gk2JPw8/WdWgL9GAOgpvO6zev26YRto//ivPN6U/tUjduKDeAPOXVV5rfLVB9EPO+0
         LFythp9CVr6QEo1yBx3qAEsyeQ6xFkAdJrYuvTwBdd21Egdl9nbSquNEvaFxZ2wcK8
         yDUAfVFA8+AUuA0nSSrS8hJMRefvhhwQDLwMQK7m+0Z0cdmaOzooY3RbDqMdujkwko
         cfT9qDsgk2I63svmPfraze9d4eTrtoOUZzcsUNQqksB1ShiG1HEK3jLDm1OSveXAre
         v8DGoPaDPEt8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF67A60A7C;
        Tue,  7 Dec 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: fix recent csum changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163883760971.11691.16842940852777036427.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 00:40:09 +0000
References: <20211204045356.3659278-1-eric.dumazet@gmail.com>
In-Reply-To: <20211204045356.3659278-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, vladimir.oltean@nxp.com,
        David.Laight@ACULAB.COM, dlebrun@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  3 Dec 2021 20:53:56 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Vladimir reported csum issues after my recent change in skb_postpull_rcsum()
> 
> Issue here is the following:
> 
> initial skb->csum is the csum of
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: fix recent csum changes
    https://git.kernel.org/netdev/net-next/c/45cac6754529

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


