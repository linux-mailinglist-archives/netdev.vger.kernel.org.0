Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE9C57672E
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiGOTKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiGOTKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E488E3CBD3;
        Fri, 15 Jul 2022 12:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AFA360A54;
        Fri, 15 Jul 2022 19:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D52E5C3411E;
        Fri, 15 Jul 2022 19:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657912215;
        bh=9L63cBTgXa+KsEQqG1D/NEZqIihhpwJ9sTIMALvPoFU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l8PIW8asO8HNtRdM0+6aTNa44bhpDaE4I6Dv+RoM7FvzyI8vAvRKULdqrLR7kKUTJ
         erpBCFrzQeX1CKP37jhhLOmWXvf5IqwuwpcLDO/+4ikhUE89QKPLNK+0Niv1lc0r0x
         0sWwKCael7lVoS4YL+ocFMjKWi941iTzum9oYjvxQFYI2OJpsn9A0aRX+ZMzfW1zfS
         hA2my5vbMtduWLLdKRxo96/ea+kPlLkuRQoVRyoNxnY7kmddiorGVgBOP4wSiBLp0r
         WwHysl6+LpQBUJ+RL7Zxk/37pGpAG0nehVKxGknqLYLF+onFht5wPx4zwmDeuo719W
         zJFXn5fJnp/pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B247AE4521F;
        Fri, 15 Jul 2022 19:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/3] Use lightweigt version of bpftool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165791221572.3895.16901953403677326761.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 19:10:15 +0000
References: <20220714024612.944071-1-pulehui@huawei.com>
In-Reply-To: <20220714024612.944071-1-pulehui@huawei.com>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, quentin@isovalent.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, jean-philippe@linaro.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 14 Jul 2022 10:46:09 +0800 you wrote:
> Currently, samples/bpf, tools/runqslower and bpf/iterators use bpftool
> for vmlinux.h, skeleton, and static linking only. We can uselightweight
> bootstrap version of bpftool to handle these, and it will be faster.
> 
> v2:
> - make libbpf and bootstrap bpftool independent. and make it simple.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/3] samples: bpf: Fix cross-compiling error by using bootstrap bpftool
    https://git.kernel.org/bpf/bpf-next/c/2e4966288c16
  - [bpf-next,v2,2/3] tools: runqslower: build and use lightweight bootstrap version of bpftool
    https://git.kernel.org/bpf/bpf-next/c/3a2a58c4479a
  - [bpf-next,v2,3/3] bpf: iterators: build and use lightweight bootstrap version of bpftool
    https://git.kernel.org/bpf/bpf-next/c/3848636b4a88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


