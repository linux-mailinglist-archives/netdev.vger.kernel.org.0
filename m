Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111793894E9
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 20:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhESSBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 14:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhESSBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 14:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20C4461355;
        Wed, 19 May 2021 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621447210;
        bh=CK3dPcPkjHmRlidzM6ynNYCsg5H2ja+kLbvpqxITUKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BzXZ2Prc7b1Na3+WzH5irOwv2MAy7iBrErcPfFVZgPtC9H4Kh1XoJuxjxEdqFABH4
         w7de9AnBrJsMdCUwn8vxJAY4ENB407DMi/frwbl6JtZTHgO11XwFcTXAWJPHNuj46T
         rfdNJ34cv5XbzMsD9/LV6l0JWVYJdr3qScCRWurrl2gyv2YFPFs9Oco89pb4wSX5oz
         3MGfdX+AKe8e86neT/KvVkSsVBPgAQfNM040X7hrr254mfSyVX5qXa+bO2etdwek/9
         AvqkwQUCLTKIRaGRavE4WtTSNktUuYW8YYlRUBijWOHiuQ9iiCqP5JqBKN8uo9HCTY
         +fMnqQPR0Uzcw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 145E060A0D;
        Wed, 19 May 2021 18:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Make some symbols static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162144721007.17992.14944688848279969975.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 18:00:10 +0000
References: <20210519064116.240536-1-pulehui@huawei.com>
In-Reply-To: <20210519064116.240536-1-pulehui@huawei.com>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 19 May 2021 14:41:16 +0800 you wrote:
> The sparse tool complains as follows:
> 
> kernel/bpf/syscall.c:4567:29: warning:
>  symbol 'bpf_sys_bpf_proto' was not declared. Should it be static?
> kernel/bpf/syscall.c:4592:29: warning:
>  symbol 'bpf_sys_close_proto' was not declared. Should it be static?
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Make some symbols static
    https://git.kernel.org/bpf/bpf-next/c/3a2daa724864

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


