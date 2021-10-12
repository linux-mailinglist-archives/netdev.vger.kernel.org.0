Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912AB42A1E2
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbhJLKWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235153AbhJLKWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D74D761056;
        Tue, 12 Oct 2021 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634034006;
        bh=gNymWPiDlchEDLhjNPYvJKld6H+Htdyogl+URBc/S3M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nQcn6EvUTUx9wRtYJgezac/78sTJcvEnvYeoNQ8Oxl2xoJ7wefi8D0niMj3C9Dbsu
         9et3Zjg11Wm6DZyHzpg8EsodPFv8CuHWdBbhXhXztftNNH8hZzrxRpr+kbb7nO7dXp
         YM0Y9hWw9QCiNZAEACupR0mw0YFhwCx8TmEe+SHFU8tcLYeY4QBQKVAwPikIo6k4bT
         wNnBR54PqWtSc2vLy2NtepcHiZ9cdVQx3B5Iacp1vEf/+MppNQONaZaYOlu/Xm0SS3
         EYSEcq1GvvJkr3LdkDYNMwHwDqcqFZ5Kqswdkwek4MmdaQvAfKfxJ8yPuML8GT/S4n
         O1qH06p4GHi0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C069360965;
        Tue, 12 Oct 2021 10:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] af_unix: Rename UNIX-DGRAM to UNIX to maintain backwards
 compatability
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163403400678.16702.616769036972068377.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 10:20:06 +0000
References: <20211008215946.3961353-1-swboyd@chromium.org>
In-Reply-To: <20211008215946.3961353-1-swboyd@chromium.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jiang.wang@bytedance.com,
        andrii@kernel.org, cong.wang@bytedance.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, digetx@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 14:59:45 -0700 you wrote:
> Then name of this protocol changed in commit 94531cfcbe79 ("af_unix: Add
> unix_stream_proto for sockmap") because that commit added stream support
> to the af_unix protocol. Renaming the existing protocol makes a ChromeOS
> protocol test[1] fail now that the name has changed in
> /proc/net/protocols from "UNIX" to "UNIX-DGRAM".
> 
> Let's put the name back to how it was while keeping the stream protocol
> as "UNIX-STREAM" so that the procfs interface doesn't change. This fixes
> the test and maintains backwards compatibility in proc.
> 
> [...]

Here is the summary with links:
  - af_unix: Rename UNIX-DGRAM to UNIX to maintain backwards compatability
    https://git.kernel.org/netdev/net/c/0edf0824e0dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


