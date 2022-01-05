Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1533848597F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243713AbiAETu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243711AbiAETuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3F9C034002;
        Wed,  5 Jan 2022 11:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EDE5618F1;
        Wed,  5 Jan 2022 19:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E69D1C36AEB;
        Wed,  5 Jan 2022 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641412210;
        bh=asPxWn8xmtKixECs/KOe7TBXxXopnRiSa0bMO9usZFg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WEE+lJMpJF/Ytf8iwiCs1tEiVGd4+1SbYm71Wcq/EQWl2RcZn9MF/Fu3uYYYrzdHT
         UCKk+eCyWsCi9t5ln40+v4dQBaZ/WkLueB9tpsecUdaDoSMl3F/DnsYFS55Wwqq3yf
         PZoThX3yZ7jm1xmJw6TMgoPm/i+SjIjGBi09BqP2w6/JhGU6KQzLQSDKuTLSxYAK4l
         BaiUl1XE3D1uU0Q2LEgqL8TbEpMP4OXt9Kqnrdpvuy3DVR+BVUnEhDe4l2en1LXUsU
         Ypbi0uyOTl7Q93h+m5wNPyxUKbD9OCK/HDahsaeSlnigi+BYnH2ZKV4S6V4zyTzi8k
         5xhlfHvKHV+pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3B46F7940C;
        Wed,  5 Jan 2022 19:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf, arm64: use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164141220979.28548.10398527104221522201.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 19:50:09 +0000
References: <20211231151018.3781550-1-houtao1@huawei.com>
In-Reply-To: <20211231151018.3781550-1-houtao1@huawei.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     ast@kernel.org, kafai@fb.com, yhs@fb.com, daniel@iogearbox.net,
        andrii@kernel.org, zlim.lnx@gmail.com, will@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 31 Dec 2021 23:10:18 +0800 you wrote:
> The following error is reported when running "./test_progs -t for_each"
> under arm64:
> 
>     bpf_jit: multi-func JIT bug 58 != 56
>     ......
>     JIT doesn't support bpf-to-bpf calls
> 
> [...]

Here is the summary with links:
  - bpf, arm64: use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
    https://git.kernel.org/bpf/bpf-next/c/e4a41c2c1fa9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


