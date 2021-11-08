Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35793449E3B
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbhKHVcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239289AbhKHVcw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 16:32:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C20B61181;
        Mon,  8 Nov 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636407007;
        bh=spRHXcGTXUYBf46hJjqceMd3cP9sEtQ9oVe+PiZLYFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K7wO4kL8/3mD4COANLC2woAr4SU779+wtR9arXyDV68fe4z75LLMiQmDIsR83cGUa
         d7v5x2eYk3Xfay/eHLnWRXgJTo83cJfA4cTLOkUqij6FFSOhreX+nOe0CJSyb6zx6y
         DAJ6XDhi6/vQeX2K9cMaiCkobKgvMR1l95KJABiMzbBr7mv6Hjw6601yKb/aXqqTRA
         gyigOLIf3q7AM/DLVmI0Muy0ouLb752rehmqPYA/Vam/cxiPXNfkUVjhBHZL3eI294
         mX+To6S+v3aam4nBW+wz0NjLyd6h4bY0C0zg/BmhXmklpPMUrNPbuS8bczp3eqZ/Wj
         IxQxlS7/AEIjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4A5B360A23;
        Mon,  8 Nov 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/2] arm64/bpf: remove 128MB limit for BPF JIT
 programs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163640700729.18756.3678999671690416622.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Nov 2021 21:30:07 +0000
References: <1636131046-5982-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1636131046-5982-1-git-send-email-alan.maguire@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ardb@kernel.org, catalin.marinas@arm.com, will@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, zlim.lnx@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, andreyknvl@gmail.com,
        vincenzo.frascino@arm.com, mark.rutland@arm.com,
        samitolvanen@google.com, joey.gouly@arm.com, maz@kernel.org,
        daizhiyuan@phytium.com.cn, jthierry@redhat.com,
        tiantao6@hisilicon.com, pcc@google.com, akpm@linux-foundation.org,
        rppt@kernel.org, Jisheng.Zhang@synaptics.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri,  5 Nov 2021 16:50:44 +0000 you wrote:
> There is a 128MB limit on BPF JIT program allocations; this is
> to ensure BPF programs are in branching range of each other.
> Patch 1 in this series removes this restriction.  To verify
> exception handling still works, a test case to validate
> exception handling in BPF programs is added in patch 2.
> 
> There was previous discussion around this topic [1], in particular
> would be good to get feedback from Daniel if this approach makes
> sense.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/2] arm64/bpf: remove 128MB limit for BPF JIT programs
    https://git.kernel.org/bpf/bpf-next/c/b89ddf4cca43
  - [v2,bpf-next,2/2] selftests/bpf: add exception handling selftests for tp_bpf program
    https://git.kernel.org/bpf/bpf-next/c/c23551c9c36a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


