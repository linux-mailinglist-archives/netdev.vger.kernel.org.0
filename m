Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03791485C5B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiAEXkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245520AbiAEXkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 18:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9042C034006;
        Wed,  5 Jan 2022 15:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 907AE619AC;
        Wed,  5 Jan 2022 23:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F04A7C36AE9;
        Wed,  5 Jan 2022 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641426009;
        bh=VnB5aRMVZsf+LgbhdEnb7mc/q8PKnT6mmWDJVnaNZD8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=swg6DYRmuYMN0i0hL2QE56Wal/cPnFkpgaHPmRc7KwisrgNHtJ9ABQgodaPc4jCAj
         /nH4r3XE/WWEabu6MXtygU792V+dpj1HwvQdffMVtWP680XP6YwSWGxFn2fqbZpbm+
         rc71sG2Z6P4zNpkymCishoPtRjHsYm39jWKYTb90HsgAahAMXnwB28AMLZkiBBFyiK
         jFUyZImxdb22UovIKvHr4+tkSrklqnNnWi0UHS24Q2+mGAtKwxae1JXFsAdq085BS0
         A2Ts0gTftwRMKABNpXpDLcBkzKgk061ALCMiWoWvyliuyEuUKgy82Q7h7PaFlBaWcA
         z7lPM+tT+pgpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4EACF7940B;
        Wed,  5 Jan 2022 23:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] libbpf: Use probe_name for legacy kprobe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164142600886.21166.4094526896575840947.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 23:40:08 +0000
References: <20211227130713.66933-1-wangqiang.wq.frank@bytedance.com>
In-Reply-To: <20211227130713.66933-1-wangqiang.wq.frank@bytedance.com>
To:     Qiang Wang <wangqiang.wq.frank@bytedance.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        hengqi.chen@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhouchengming@bytedance.com,
        songmuchun@bytedance.com, duanxiongchun@bytedance.com,
        shekairui@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 27 Dec 2021 21:07:12 +0800 you wrote:
> Fix a bug in commit 46ed5fc33db9, which wrongly used the
> func_name instead of probe_name to register legacy kprobe.
> 
> Fixes: 46ed5fc33db9 ("libbpf: Refactor and simplify legacy kprobe code")
> Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
> Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
> Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [v2,1/2] libbpf: Use probe_name for legacy kprobe
    https://git.kernel.org/bpf/bpf-next/c/71cff670baff
  - [v2,2/2] libbpf: Support repeated legacy kprobes on same function
    https://git.kernel.org/bpf/bpf-next/c/51a33c60f1c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


