Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181BB30832E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhA2BU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:20:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231748AbhA2BUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 257B764DF1;
        Fri, 29 Jan 2021 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611883211;
        bh=IMOKcLTbCks6Z99yHsVEICtg+0+GMY5EvY12btgYyl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e5FiMmi/K9oVm0AuG8BF2ElU0CLpW030Mt/FNpjzpcgZzoJ98iS2y08aFSkUjbN+3
         mnjzemVXHYIp8/jE1igXAOnRMm+MuDRUOUDaopjd6Flqi59mGx0zI5LkISfSNmyFtz
         10T6M5A5euri05WigjMx5+I3Zs9zwGALcs1ZU9oyNDS0yxW1Utmt4L2DCzbnZccGIj
         WwpYl0VxvjNvVZnJBbtIVb4PlVz3+ZDT6stbN5vI4I1XTyHuyfZAeR0hRV8aJ8Fy4S
         2VsNVHdEuwWaILgGSfaVSv+183yKvjeJYP1K3aAJ3btQQ4KJGJ4eZLbkwpxn/T7dUU
         tIo2qcxXi5Xdg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1574F65323;
        Fri, 29 Jan 2021 01:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/4] bpf: expose bpf_{g,s}etsockopt to more
 bpf_sock_addr hooks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161188321108.21586.7538378167940778543.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 01:20:11 +0000
References: <20210127232853.3753823-1-sdf@google.com>
In-Reply-To: <20210127232853.3753823-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 27 Jan 2021 15:28:49 -0800 you wrote:
> We'd like to use the SENDMSG ones, Daniel suggested to
> expose to more hooks while are here.
> 
> Stanislav Fomichev (4):
>   bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_SENDMSG
>   bpf: enable bpf_{g,s}etsockopt in
>     BPF_CGROUP_INET{4,6}_GET{PEER,SOCK}NAME
>   selftests/bpf: rewrite readmsg{4,6} asm progs to c in test_sock_addr
>   bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_RECVMSG
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/4] bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_SENDMSG
    https://git.kernel.org/bpf/bpf-next/c/62476cc1bf24
  - [bpf-next,v2,2/4] bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_INET{4,6}_GET{PEER,SOCK}NAME
    https://git.kernel.org/bpf/bpf-next/c/073f4ec124bb
  - [bpf-next,v2,3/4] selftests/bpf: rewrite recvmsg{4,6} asm progs to c in test_sock_addr
    https://git.kernel.org/bpf/bpf-next/c/357490601621
  - [bpf-next,v2,4/4] bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_RECVMSG
    https://git.kernel.org/bpf/bpf-next/c/4c3384d7abe5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


