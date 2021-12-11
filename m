Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693FB471184
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 05:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345923AbhLKEnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 23:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237692AbhLKEns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 23:43:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F5EC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 20:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AC74B82ABD
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09A48C341D3;
        Sat, 11 Dec 2021 04:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639197610;
        bh=2609xlMbAGkC/zYh2BhklKL5G/BuqGVrua3XMNUXrhM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UeZUFudD6DGreMwnvOf6oMwlz8umaBy5V44taym+3UdroJnxPMXVDkm5/VqCPVd/C
         B3/VVUn+bkyo4ABjPUgFqQwLjEkYHkdnemg0WcKrRMDK096Z7dWNQok+/9N8MO5owH
         HqgYCqZ8UzxzCs0NM7B2tBjH9Rluolo1sRmq7/DGxirE+BBBLG+U2nwOHVDSdsrqcX
         lXcHBuWQzMO73egkGynxwLPJbDwPGLUr93dxSjCASUWitSxNawBz2ZUwXERL3x3r49
         8cPS4RYZRsnvQNApcmQQC5o144E2QkB+I3vhKPScA5f/9fvg5RH38Zy1frVUAHBQMB
         +6/3t6L8knWGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF9DF60A4F;
        Sat, 11 Dec 2021 04:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] sock: Use sock_owned_by_user_nocheck() instead of
 sk_lock.owned.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163919760990.24757.11767181595147143657.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 04:40:09 +0000
References: <20211208062158.54132-1-kuniyu@amazon.co.jp>
In-Reply-To: <20211208062158.54132-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, benh@amazon.com,
        kuni1840@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Dec 2021 15:21:58 +0900 you wrote:
> This patch moves sock_release_ownership() down in include/net/sock.h and
> replaces some sk_lock.owned tests with sock_owned_by_user_nocheck().
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/net/sock.h | 23 ++++++++++++-----------
>  net/core/sock.c    |  4 ++--
>  net/llc/llc_proc.c |  2 +-
>  3 files changed, 15 insertions(+), 14 deletions(-)

Here is the summary with links:
  - [v2,net-next] sock: Use sock_owned_by_user_nocheck() instead of sk_lock.owned.
    https://git.kernel.org/netdev/net-next/c/33d60fbd21fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


