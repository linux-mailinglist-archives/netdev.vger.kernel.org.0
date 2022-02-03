Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7764A7FDB
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 08:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347146AbiBCHaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 02:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbiBCHaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 02:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E499C061714;
        Wed,  2 Feb 2022 23:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B521617B6;
        Thu,  3 Feb 2022 07:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF5DFC340EC;
        Thu,  3 Feb 2022 07:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643873410;
        bh=kNWYm/UnNlW2g43C17rFAPBP2wFvAbp2oLQ6HAuliDQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rn0bkng68L0NaRZMPtB0hRuhRdh1sUQbN9yJ+TpmIpqKErJOQA2Jnq2CCQmux0hGv
         B4NCpzugwWAmP1Y5w4LgWRmsiGeFfTBlp9IgdkgLFSh5xPLxZAX5N8r3uV7OlD9YcX
         csbJ7g/q7HGXpzfNP6NhAAuTtcqr+uS4IGUWwP8DeHMcVbVGfXbAwh+w7P6o5FfB7a
         /s5p6/zQpiT8awnJprb6d/p+UeNYk54/wYTxLc5fd+Xg7bQ5b9xVjTd0jEtbfnMELE
         JM81x4rY5F7TVNKpuOk/0cvYUXWn1VegOlBDNX3J3Aioyb/SaglSD0D2rfGwOSUelN
         AXCXCNi5dhdRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAF20E5D09D;
        Thu,  3 Feb 2022 07:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164387340989.17246.1195357867240982633.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 07:30:09 +0000
References: <20220202060158.6260-1-houtao1@huawei.com>
In-Reply-To: <20220202060158.6260-1-houtao1@huawei.com>
To:     Hou Tao <hotforest@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, houtao1@huawei.com,
        syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed,  2 Feb 2022 14:01:58 +0800 you wrote:
> After commit 2fd3fb0be1d1 ("kasan, vmalloc: unpoison VM_ALLOC pages
> after mapping"), non-VM_ALLOC mappings will be marked as accessible
> in __get_vm_area_node() when KASAN is enabled. But now the flag for
> ringbuf area is VM_ALLOC, so KASAN will complain out-of-bound access
> after vmap() returns. Because the ringbuf area is created by mapping
> allocated pages, so use VM_MAP instead.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
    https://git.kernel.org/bpf/bpf/c/b293dcc473d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


