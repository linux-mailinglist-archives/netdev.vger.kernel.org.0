Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA5A41DB16
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351461AbhI3Nbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349759AbhI3Nbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 09:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8072B61882;
        Thu, 30 Sep 2021 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633008607;
        bh=0YaFj5JQtTrqgN8P/y1siPCsPVjjF9pDvxSSHV0lao8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HMxnhpKdYFFYa1pftUXbLLH/jj/7unwF3F88OUEYq6uyJsskN5OtMnZ/q0h3+8h/9
         IVwmaP51ORNsiuZEt6bSAamowwGcs9s4qDWjumt9izQlXMvAey7t0SLkaUQnFLKvKV
         9I7U0vB/5BHG/nW2UH/SuGO4qrECkHdo35yCDTZcxMN0x5iw1yx6ExJR1E5Zwp9dVw
         3zrKJMQyK4oeG9vUMFUqDYb7RP5XHZZjb5bARobTBgwyECw3MrhF0ckIsmRfgZMSID
         CaNxdrfKsLmu3DF9dyBHu12FcGvLLjM9eErAJ9JOX+r6emuGop7CVmeMnxFMLl08nj
         tA3tISOKq2jNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7450E60A3C;
        Thu, 30 Sep 2021 13:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_unix: fix races in sk_peer_pid and sk_peer_cred
 accesses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300860747.18628.8702582052743566111.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 13:30:07 +0000
References: <20210929225750.2548112-1-eric.dumazet@gmail.com>
In-Reply-To: <20210929225750.2548112-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jannh@google.com, ebiederm@xmission.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 29 Sep 2021 15:57:50 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Jann Horn reported that SO_PEERCRED and SO_PEERGROUPS implementations
> are racy, as af_unix can concurrently change sk_peer_pid and sk_peer_cred.
> 
> In order to fix this issue, this patch adds a new spinlock that needs
> to be used whenever these fields are read or written.
> 
> [...]

Here is the summary with links:
  - [net] af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
    https://git.kernel.org/netdev/net/c/35306eb23814

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


