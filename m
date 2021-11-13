Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728A244F12D
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbhKMEXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235620AbhKMEXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 23:23:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BD1CA61104;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636777209;
        bh=Ix6fDQS5ZE8+lVpjyL0lac20SB1SuTzE8UUJXm9EpQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IzCS0brH71Nm1cN067PpMafpv+xLQyYHykqCs0UbNITIWnBq3E2wIIGBzH/fP4VRV
         kIwmnVxENDYtXlMBalA8LTTvSDKBdiLpLNRrqxwGejjdHD8PaAf8aPbUeaWOfB/zO4
         683fEoQ5Vfvmh0yk1x6gxKnhhvDuNnHnzF+vbCnvsHS7Qa7+WxSVZh2uUW5pEBtJbJ
         VsoV/G9K6INoIUs2R1arbHsxriWpxx/tBtLIo2fJ++nHehQd7twHx9sSGcXhTFmgY9
         rPcJiGc5ApTUePrwUYKarNokjldQHuQh944UeEGNZd4bdnubwNRVisy2fqR/H+ZWic
         sNFidbs5aw6oA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC3C160AA4;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v2] tcp: Fix uninitialized access in skb frags array for Rx 0cp.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163677720970.27008.1100209211155509466.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Nov 2021 04:20:09 +0000
References: <20211111235215.2605384-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20211111235215.2605384-1-arjunroy.kdev@gmail.com>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Nov 2021 15:52:15 -0800 you wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> TCP Receive zerocopy iterates through the SKB queue via
> tcp_recv_skb(), acquiring a pointer to an SKB and an offset within
> that SKB to read from. From there, it iterates the SKB frags array to
> determine which offset to start remapping pages from.
> 
> [...]

Here is the summary with links:
  - [net,v2] tcp: Fix uninitialized access in skb frags array for Rx 0cp.
    https://git.kernel.org/netdev/net/c/70701b83e208

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


