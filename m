Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488F834AD02
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 18:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhCZRAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 13:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhCZRAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 13:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A705461A32;
        Fri, 26 Mar 2021 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616778009;
        bh=zi7Yw29nGX7eFRndPIuksT2wCdwaw5U6HKwjp2NGPTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ikNejc7q0CYFlg4qUYsDAqNmBoS3n3SB+xPaa3qL64fEXfrNxJnLHfYZMh3TqwwRM
         iiMupXGhKJPNyShWfu/3q66uPECfus+b/ev2ddibLWxfSpxYh/jejNQ3574ZpSG4GK
         4aTubBO/fal3GHTze/V7ryBFyAq17c8hIe5kl7Dlmv99FIJ1FY7pCSUcZ+pmBnkPki
         LCy6J8/tV5UztLHal7rCp9nLEFeCFMY3fNhONHPDWd4hUX0mfLItGbsyYeJTGTrbC0
         vGtmUMBODW5OOwDj6C37P973+VMqWbL7syR3WXqkVxdSiKigRPiCJMcm1u7v0ukZKQ
         lyXDbjlIvpc5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8462660971;
        Fri, 26 Mar 2021 17:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3] bpf: Fix a spelling typo in kernel/bpf/disasm.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161677800953.29837.10166838117496494818.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 17:00:09 +0000
References: <20210325134141.8533-1-xukuohai@huawei.com>
In-Reply-To: <20210325134141.8533-1-xukuohai@huawei.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        jackmanb@google.com, kpsingh@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, john.fastabend@gmail.com,
        songliubraving@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Thu, 25 Mar 2021 13:41:41 +0000 you wrote:
> The name string for BPF_XOR is "xor", not "or", fix it.
> 
> Fixes: 981f94c3e92146705b ("bpf: Add bitwise atomic instructions")
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Brendan Jackman <jackmanb@google.com>
> ---
>  kernel/bpf/disasm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next,v3] bpf: Fix a spelling typo in kernel/bpf/disasm.c
    https://git.kernel.org/bpf/bpf/c/d6fe1cf89026

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


