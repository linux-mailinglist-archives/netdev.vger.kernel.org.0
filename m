Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D313D8394
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhG0XAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233328AbhG0XAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:00:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D97D60F90;
        Tue, 27 Jul 2021 23:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627426805;
        bh=LXUPZ17rRnu85rgqXUn5R6YtDFnd7Ui13cA4aP3Wh8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m1CUPgmBjkxhxQcTRdhymFwwsve7LqLCZHbWCs98h6SfnwiNC+ubu407vAs5lJE/o
         BNCluUlru90W6tcgmdxj7bGSOS6HUtbBK7Bvyh4G7xQ97KKViX05d7n/akIOZlbSyS
         pxkHVsGbyDYTpqz3eg0wnsBVizo0abjQy4WA15C+te5105N5Ar29i8NsVaMRMquGyP
         H0qnV9/IHxDI4OcWK7web9xTqJyl7fluxRTOfmxwAKcwBDyoSkeZj1vSFD1EsdoonX
         xqpHKWfI/l+yeLMgd5aghbwYxkXPtf3z+f31S/QhhvxAoQqWHtma0g/wpgSts8J9+Q
         PUkhqe3+HhfeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4037A60A59;
        Tue, 27 Jul 2021 23:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4] bpf: increase supported cgroup storage value size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162742680525.4269.10769027496846055563.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 23:00:05 +0000
References: <20210727222335.4029096-1-sdf@google.com>
In-Reply-To: <20210727222335.4029096-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, yhs@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 27 Jul 2021 15:23:35 -0700 you wrote:
> Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
> storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's align
> max cgroup value size with the other storages.
> 
> For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> allocator is not happy about larger values.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4] bpf: increase supported cgroup storage value size
    https://git.kernel.org/bpf/bpf-next/c/33b57e0cc78e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


