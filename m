Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110746D711C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbjDEAKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDEAKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3344224;
        Tue,  4 Apr 2023 17:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C67E76220E;
        Wed,  5 Apr 2023 00:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F157C433EF;
        Wed,  5 Apr 2023 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680653419;
        bh=CWCLP2JJf4j6XiElzYy6ip+9KcnzKaPbfabGe4t5fis=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YkBS27E/wjobpwO/Av5EPqZumUutGYWz+s9eEE1qogjHLTn38qMJxeJlje63QyvH/
         0RlaIWG1g96gR8exKGa4Me2nsqGqHse9kB5ikLCtgbZACBIbKRzo7XnwN7OsO311r2
         4FXFuMQMnjApDFe9LwXumzuHw+sFZ8E0puEMg/KQhnUXqCekQrOiyJoJVl49ILrQMT
         1l74TlsdUlU8+7p8HdU8sZH6zcpipqwYD3hFuYDlb7//4ASXhfhvZKUqi/hiWAwuN2
         uQ3lxVxXaka3Up4z417bfb2ncjRvn+9JI626KYGpFv1TfCj2msWwbkFJZIE7yISRGL
         z5UY2CriA8SZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC985C395C5;
        Wed,  5 Apr 2023 00:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the
 verifier.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168065341896.29228.5741257659998997557.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 00:10:18 +0000
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon,  3 Apr 2023 21:50:21 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The patch set is addressing a fallout from
> commit 6fcd486b3a0a ("bpf: Refactor RCU enforcement in the verifier.")
> It was too aggressive with PTR_UNTRUSTED marks.
> Patches 1-6 are cleanup and adding verifier smartness to address real
> use cases in bpf programs that broke with too aggressive PTR_UNTRUSTED.
> The partial revert is done in patch 7 anyway.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/8] bpf: Invoke btf_struct_access() callback only for writes.
    https://git.kernel.org/bpf/bpf-next/c/7d64c5132844
  - [bpf-next,2/8] bpf: Remove unused arguments from btf_struct_access().
    https://git.kernel.org/bpf/bpf-next/c/b7e852a9ec96
  - [bpf-next,3/8] bpf: Refactor btf_nested_type_is_trusted().
    https://git.kernel.org/bpf/bpf-next/c/63260df13965
  - [bpf-next,4/8] bpf: Teach verifier that certain helpers accept NULL pointer.
    https://git.kernel.org/bpf/bpf-next/c/91571a515d1b
  - [bpf-next,5/8] bpf: Refactor NULL-ness check in check_reg_type().
    https://git.kernel.org/bpf/bpf-next/c/add68b843f33
  - [bpf-next,6/8] bpf: Allowlist few fields similar to __rcu tag.
    https://git.kernel.org/bpf/bpf-next/c/30ee9821f943
  - [bpf-next,7/8] bpf: Undo strict enforcement for walking untagged fields.
    https://git.kernel.org/bpf/bpf-next/c/afeebf9f57a4
  - [bpf-next,8/8] selftests/bpf: Add tracing tests for walking skb and req.
    https://git.kernel.org/bpf/bpf-next/c/69f41a787761

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


