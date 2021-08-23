Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BF93F4B42
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbhHWNAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235731AbhHWNAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 09:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EDFD9613C8;
        Mon, 23 Aug 2021 13:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629723609;
        bh=jlMYI2wq3qAtpmX7x3t1yFUv2yIsZ5oqvaHDi9/CJKo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e+ef2JFZq0Y2gXjiTbqvKLuUhRa1Bmz2T/R6lInYTK6tmWniMIeWt3CU+YK59NLO3
         VwoRrY2NtdWlyq+hKq91+bRpV5anBGXcyJ/Ur/OuqW46Yqz+QtTvZe946GWKeSnzE+
         jq1Sh0gPzn5NR+sjzVzHZI/lB8ktAK+lduzoZiWB7GOlY5qgjQI580SHhSaQahKuYf
         xN7uLDLWr3k3D6QZjR3Rg4w4vPeECh2iEkC+hhtgur6z7v8jIJ70GGJpX78dv4CgoZ
         ZnF3BLwkp/vn03NyOQ4F2zVAiifL875ZXSPQCl+6vpayTWQT6py37sr56GAfkvenI1
         avgC7YkWcE7bg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF6616098C;
        Mon, 23 Aug 2021 13:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] af_unix: fix NULL pointer bug in unix_shutdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162972360690.29348.8530821383166301782.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 13:00:06 +0000
References: <20210821180738.1151155-1-jiang.wang@bytedance.com>
In-Reply-To: <20210821180738.1151155-1-jiang.wang@bytedance.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     bpf@vger.kernel.org, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, kuniyu@amazon.co.jp, digetx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, viro@zeniv.linux.org.uk,
        christian.brauner@ubuntu.com, rao.shoaib@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sat, 21 Aug 2021 18:07:36 +0000 you wrote:
> Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> introduced a bug for af_unix SEQPACKET type. In unix_shutdown, the
> unhash function will call prot->unhash(), which is NULL for SEQPACKET.
> And kernel will panic. On ARM32, it will show following messages: (it
> likely affects x86 too).
> 
> Fix the bug by checking the prot->unhash is NULL or not first.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] af_unix: fix NULL pointer bug in unix_shutdown
    https://git.kernel.org/bpf/bpf-next/c/d359902d5c35

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


