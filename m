Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BE3386C23
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbhEQVV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238011AbhEQVV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D87160FF3;
        Mon, 17 May 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621286409;
        bh=RZxNjv6AOm7JX6t07xIRjgjNCdoCH7gHTm3qEEshqao=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c8xSMbdNOj8kIL4IVy0fNT+hUiMHQOFxs3oEvXeLXAA9d2R2ZLDK827GwXrVb1/GS
         kUgi8hg3iMjuL6Cf0CTZ+BJwliGOQeOqjbew5ahsGOA4X0G3mLEbQpImdzZ2gsmich
         i8wslUIWsVDGK1oLkaBoGmhBewc3ANLn74zfD7nv8SJKo5e3UAv/drNw3mYx2uEb84
         XXTvZJFfRs2NGKTP5YUK/Q9QfAHgvamd+9ZtOdOPI3ghydhB7xaY9DIsszcLWGP44M
         FSFMDXCRJP/ilH13Zg560Ikp1OY0frtceV6WMqZufrjSQrBmMmQQW5hzEeQsQiH8Uq
         LBe/o8yAes1nA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 925FE60972;
        Mon, 17 May 2021 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: wait and exit until all work queues are done
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128640959.11371.9655444594394861655.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:20:09 +0000
References: <5db04a37335895e04e98bdf53aff3c8ecb6774db.1621189738.git.lucien.xin@gmail.com>
In-Reply-To: <5db04a37335895e04e98bdf53aff3c8ecb6774db.1621189738.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        ying.xue@windriver.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 17 May 2021 02:28:58 +0800 you wrote:
> On some host, a crash could be triggered simply by repeating these
> commands several times:
> 
>   # modprobe tipc
>   # tipc bearer enable media udp name UDP1 localip 127.0.0.1
>   # rmmod tipc
> 
> [...]

Here is the summary with links:
  - [net] tipc: wait and exit until all work queues are done
    https://git.kernel.org/netdev/net/c/04c26faa51d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


