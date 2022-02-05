Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC844AA675
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379332AbiBEEaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:30:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53186 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379316AbiBEEaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A597CB839AC
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 04:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E33CC340EC;
        Sat,  5 Feb 2022 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644035409;
        bh=+rKEbOIq+WKe9+t33SgmB3ZxB7ue3FeoGtsv60Tuzkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SXuDrv2JOldeLBW1MCavghKCnp9Z/kZXrADDWUyh8J/Q+NxmdyYIUKNC1a70hwq5Q
         jrTdpwISmHrnawmQfQDvoFK9ZImnP251au3UVJo5suZdaXVfgwpdY2NGPC6GfkjmcR
         8aXP5TWNedkrcp9BBkGHyQclpC37BWZJaiBPYWwMgLAD3Ld/WKfpr3VfVjlq3BQNmP
         yilL0YF3nqutHHXBRDYbp/kEomATpI1jbHLZgcKk7Qs3a4KmCSLYLYtxH4ZeGO86v9
         5WVGVmfM1j12VIQ00pbOA64clTQsVJpfnGtAnQdMAlL/9aaUR+mAiXHwRmCFEkMpeG
         M3uXp9gRcGnhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40B89E6D3DE;
        Sat,  5 Feb 2022 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: take care of mixed splice()/sendmsg(MSG_ZEROCOPY)
 case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164403540926.14792.15149477966460152526.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 04:30:09 +0000
References: <20220203225547.665114-1-eric.dumazet@gmail.com>
In-Reply-To: <20220203225547.665114-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com,
        talalahmad@google.com, arjunroy@google.com, willemb@google.com,
        soheil@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  3 Feb 2022 14:55:47 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot found that mixing sendpage() and sendmsg(MSG_ZEROCOPY)
> calls over the same TCP socket would again trigger the
> infamous warning in inet_sock_destruct()
> 
> 	WARN_ON(sk_forward_alloc_get(sk));
> 
> [...]

Here is the summary with links:
  - [net] tcp: take care of mixed splice()/sendmsg(MSG_ZEROCOPY) case
    https://git.kernel.org/netdev/net/c/f8d9d938514f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


