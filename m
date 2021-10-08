Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF48426C43
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhJHOCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232200AbhJHOCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:02:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A475761039;
        Fri,  8 Oct 2021 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633701607;
        bh=69Qf6wb8av9yd/wWk0FOxoCxwUMbVQmaHVYG3qL511o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tlzRpeRoIjk0kIBez2dh2IKxvhQuRr5iKPcRplh+lzXoAcolKEDr6Ul5rFMgNIcpH
         ksBYymz3OR1fYiI/xSAGlbHrY6wONrE/ZnhJh024czt5PGHhQ8czFlEgOdhokDFU2K
         m8Trz/ABtIbQIYbzWC8SBcU42skcnNhaPM731NWkzjyEFKkBGxdn8ZUkm27zNE8f2g
         IrFk91EG4VcdUelkGGVWJUkv9DoBthfNOaiyHLlKXx9hlUEfqoFBf+H7Gd9tZghqUi
         520AMi8MwMyf17GSjNHS5O6EMIvOdwWDzNgR+tHO4AJ3MiROtJITvKo7FTU0gAK9lO
         KFghakdfyU3rQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 984AB60A23;
        Fri,  8 Oct 2021 14:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: fix possible stall on recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370160761.24973.5860013311748951004.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 14:00:07 +0000
References: <20211007220500.280862-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20211007220500.280862-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        syzbot+3360da629681aa0d22fe@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 15:05:00 -0700 you wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> 
> recvmsg() can enter an infinite loop if the caller provides the
> MSG_WAITALL, the data present in the receive queue is not sufficient to
> fulfill the request, and no more data is received by the peer.
> 
> When the above happens, mptcp_wait_data() will always return with
> no wait, as the MPTCP_DATA_READY flag checked by such function is
> set and never cleared in such code path.
> 
> [...]

Here is the summary with links:
  - [net] mptcp: fix possible stall on recvmsg()
    https://git.kernel.org/netdev/net/c/612f71d7328c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


