Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D713EE40F
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 04:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbhHQCAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 22:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhHQCAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 22:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 084E360F55;
        Tue, 17 Aug 2021 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629165607;
        bh=MVnubLbxEzYHgLlzZ7aRkr3ISMZ+jDiZOyPTzWQo7T0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uFcUAC5i++kNEHGEf/zN8dR594RJDrxGy8M45/u1jF5u/x/NW0eC1qH2OzH5N4cij
         UNlt+R+dh2RI+QPiKTNqdPYcbQpM76L3ajsXvbdX1l20gLz9At/aWY7LpWTbOv3VZH
         cDXf8a+2m2XpsFlLEDOAcrpUEInCa73RfasnzhmqVMtxV25Qn7I6UalGMaRf3i+1MB
         wlGT9chFOYlX7Rn9jK3doqDErpYSED7m99bzE/WM5ehgsFLeRPTKNI9JTnor9YI+Ap
         aq/s+liEKnf7UMDjRTzBrlT8mOGTv8H+aQDYx5uk7nPPRyBv5E0H3UPbRuptmrg5yE
         b48NBWtCYC7hw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB111609DA;
        Tue, 17 Aug 2021 02:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v7 0/5] sockmap: add sockmap support for unix stream
 socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162916560695.26282.3837040617464847653.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 02:00:06 +0000
References: <20210816190327.2739291-1-jiang.wang@bytedance.com>
In-Reply-To: <20210816190327.2739291-1-jiang.wang@bytedance.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, john.fastabend@gmail.com,
        jakub@cloudflare.com, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, lmb@cloudflare.com, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, shuah@kernel.org, viro@zeniv.linux.org.uk,
        christian.brauner@ubuntu.com, rao.shoaib@oracle.com,
        johan.almbladh@anyfinetworks.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 16 Aug 2021 19:03:19 +0000 you wrote:
> This patch series add support for unix stream type
> for sockmap. Sockmap already supports TCP, UDP,
> unix dgram types. The unix stream support is similar
> to unix dgram.
> 
> Also add selftests for unix stream type in sockmap tests.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v7,1/5] af_unix: add read_sock for stream socket types
    https://git.kernel.org/bpf/bpf-next/c/77462de14a43
  - [bpf-next,v7,2/5] af_unix: add unix_stream_proto for sockmap
    https://git.kernel.org/bpf/bpf-next/c/94531cfcbe79
  - [bpf-next,v7,3/5] selftest/bpf: add tests for sockmap with unix stream type.
    https://git.kernel.org/bpf/bpf-next/c/9b03152bd469
  - [bpf-next,v7,4/5] selftest/bpf: change udp to inet in some function names
    https://git.kernel.org/bpf/bpf-next/c/75e0e27db6cf
  - [bpf-next,v7,5/5] selftest/bpf: add new tests in sockmap for unix stream to tcp.
    https://git.kernel.org/bpf/bpf-next/c/31c50aeed5a1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


