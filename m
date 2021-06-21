Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAAB3AEBE8
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhFUPCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhFUPCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 11:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28A67610C7;
        Mon, 21 Jun 2021 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624287605;
        bh=pnxwEpJNZef6+we8iGAulCkpSgUW5KQYq3qjcW+5qZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uFyIfPrBkIUPkm2QmfrO+uXuvGYArMquRMfkSSwfsU5OOVCF+LF5ef4gPM/A43RG/
         x1zQ2F8mDCPXW/N6Vuj4F9o9Tk4jXTfbSrJ2arTE3BuMyaUeyCKC6whLIrvxgLVoc/
         oqP2g/+WamkF2vL7efJleCH4LhssTfCOiW3FL02Uwm30woq45BevbfLJZSJ0lV5+BO
         qFjlw9fHLjro/5wIDQJb1MEleBwF4ldpOKzsUoAhJQLRbAaEhGpYrykQQrDhUv0nJi
         rC+EdLBkaArbkxeYt+W5AKkQkiOZxDgz+5svO2AhY4ceBx/Ya1wffN4MSMx5Hqsxcd
         9C1McIGWNDjig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 182C06094F;
        Mon, 21 Jun 2021 15:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND bpf v3 0/8] sock_map: some bug fixes and improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162428760509.31493.2198162085381420192.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 15:00:05 +0000
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com, john.fastabend@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Mon, 14 Jun 2021 19:13:34 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This patchset contains a few bug fixes and improvements for sock_map.
> 
> Patch 1 improves recvmsg() accuracy for UDP, patch 2 improves UDP
> non-blocking read() by retrying on EAGAIN. With both of them, the
> failure rate of the UDP test case goes down from 10% to 1%.
> 
> [...]

Here is the summary with links:
  - [RESEND,bpf,v3,1/8] skmsg: improve udp_bpf_recvmsg() accuracy
    https://git.kernel.org/bpf/bpf/c/9f2470fbc4cb
  - [RESEND,bpf,v3,2/8] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
    https://git.kernel.org/bpf/bpf/c/a7e65fe7d820
  - [RESEND,bpf,v3,3/8] udp: fix a memory leak in udp_read_sock()
    https://git.kernel.org/bpf/bpf/c/e00a5c331bf5
  - [RESEND,bpf,v3,4/8] skmsg: clear skb redirect pointer before dropping it
    https://git.kernel.org/bpf/bpf/c/30b9c54a707d
  - [RESEND,bpf,v3,5/8] skmsg: fix a memory leak in sk_psock_verdict_apply()
    https://git.kernel.org/bpf/bpf/c/0cf6672b23c8
  - [RESEND,bpf,v3,6/8] skmsg: teach sk_psock_verdict_apply() to return errors
    https://git.kernel.org/bpf/bpf/c/1581a6c1c329
  - [RESEND,bpf,v3,7/8] skmsg: pass source psock to sk_psock_skb_redirect()
    https://git.kernel.org/bpf/bpf/c/42830571f1fd
  - [RESEND,bpf,v3,8/8] skmsg: increase sk->sk_drops when dropping packets
    https://git.kernel.org/bpf/bpf/c/781dd0431eb5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


