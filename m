Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BA06B8B60
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCNGkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjCNGkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1E951C8A;
        Mon, 13 Mar 2023 23:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E76DE615CD;
        Tue, 14 Mar 2023 06:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F6DEC4339B;
        Tue, 14 Mar 2023 06:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678776018;
        bh=S/evt7zjetgiN2BMM4mSEN3WplNPDs/OsGnIu1y3LdU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yrp74YoCrOdHxh2xAg9cyOF46rMdOl4fYJt5ANGwf+H7qTPeCkjLDl0RHTaWfbwfE
         KmV5YGl8U6gutFh30slM6HmlXHnefJ5si8D4lOqTuhpNePxlDMKka4erSKZawlyZCY
         bUcTp5UoDn5QdlFUaa9zk0CKTj4/tiEoeTz6lM+RAutIDCPmsIf2np2c5AAicAdcbR
         7pIgPZTWtR9HxZK6nXoPB7gsQevhZPpahVuYAfgMvNl15IszfnxK6b8Cqo7kLbY0a8
         9KuAnOF+3CzfHlV7M2lK3BsRLSRJcFAY+CchYwnOrI9w2Ho+CkxgrViCvDPqnPK+Pg
         hlaD3jv0ME1wA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 317CEE66CBB;
        Tue, 14 Mar 2023 06:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/3] bpf: Allow helpers access ptr_to_btf_id.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167877601819.27484.6120031814046560581.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 06:40:18 +0000
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Mon, 13 Mar 2023 16:58:42 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Allow code like:
> bpf_strncmp(task->comm, 16, "foo");
> 
> Alexei Starovoitov (3):
>   bpf: Fix bpf_strncmp proto.
>   bpf: Allow helpers access trusted PTR_TO_BTF_ID.
>   selftests/bpf: Add various tests to check helper access into
>     ptr_to_btf_id.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/3] bpf: Fix bpf_strncmp proto.
    https://git.kernel.org/bpf/bpf-next/c/c9267aa8b794
  - [bpf-next,2/3] bpf: Allow helpers access trusted PTR_TO_BTF_ID.
    https://git.kernel.org/bpf/bpf-next/c/3e30be4288b3
  - [bpf-next,3/3] selftests/bpf: Add various tests to check helper access into ptr_to_btf_id.
    https://git.kernel.org/bpf/bpf-next/c/f25fd6088216

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


