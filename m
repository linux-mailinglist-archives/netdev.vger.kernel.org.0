Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0444ED1C4
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 04:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiCaCcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 22:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbiCaCcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 22:32:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF5F689B6;
        Wed, 30 Mar 2022 19:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E5E60AD2;
        Thu, 31 Mar 2022 02:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86FAFC340F0;
        Thu, 31 Mar 2022 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648693810;
        bh=aPj1c8RvzvGXAuQsqkTav5kOLpi/LGbYefX1+4dbdjM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MlUqh7kPJOIW1zapDRtfFqPeNv1DKo5BphJRywVIKcLNqzUDUV/IBZbF9AetL+8L5
         Bdujwr+KY7sVcC0hbpyGgdJzg7Pk6qdvf6O2q2+9QbHvGnNimkreuY0fWdx1qgBPj0
         jxc6gTzElSMicfeP4bO9XGpWWew3ln/A7B/6FMYnBYigpyWZthupHapg29/S8+Ud2U
         8sD1JvxeNA9S/saaK8uwxqm5nIFt98Taca9UU5CF+YrRknqXh3K/u6bagra4kfCZst
         n5o90eOnC/BltyvufRWrb7dNez4PeyReKb4s9rLVZe8P5YBKzH5MhFYonbZmyLPAdx
         KEfwqqVNvDzDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A887F0384A;
        Thu, 31 Mar 2022 02:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] rethook: Fix to use WRITE_ONCE() for rethook::handler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164869381043.25553.521399058404787775.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 02:30:10 +0000
References: <164868907688.21983.1606862921419988152.stgit@devnote2>
In-Reply-To: <164868907688.21983.1606862921419988152.stgit@devnote2>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     ast@kernel.org, alexei.starovoitov@gmail.com, davem@davemloft.net,
        daniel@iogearbox.net, peterz@infradead.org, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 31 Mar 2022 10:11:17 +0900 you wrote:
> Since the function pointered by rethook::handler never be removed when
> the rethook is alive, it doesn't need to use rcu_assign_pointer() to
> update it. Just use WRITE_ONCE().
> 
> Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf] rethook: Fix to use WRITE_ONCE() for rethook::handler
    https://git.kernel.org/bpf/bpf/c/a2fb49833cad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


