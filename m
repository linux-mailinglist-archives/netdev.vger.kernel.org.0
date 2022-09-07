Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E165B0C39
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiIGSK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiIGSKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5099C719AB;
        Wed,  7 Sep 2022 11:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62F3EB81E73;
        Wed,  7 Sep 2022 18:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F28E5C433D6;
        Wed,  7 Sep 2022 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662574217;
        bh=fVMXobppjBKa9+amWXxjb+FK8uHD1iOCT8OrhS2yGCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HVkXM/Hez/+BQGlbRg+P32uao7H5mFsVdH1k2ME6npsj/oLpGnpRVNxv6aiCIPWyg
         my8eD1oPpWkF1ZruSGZBpp50njY3pqPr+11y/5+czVtioJAacqe9WXv/v+Qfwqpna8
         XUwuoz5XftRyejic0XtO6m+lkW6rG1Gb/aPoVj+UILaSxuO1Uaf/Wh7B7M/3zsOGCL
         mYpKhrJfclULzikmZcGJFO/V1HCf0d5xY/FW4PZPnOEoxR8MyqCIwkfIksN5cTRuVI
         zv9sTvQZnXhkuWlJ4/3Kt+YCsugaJPRe9QQ+PVMFj5vDVB6hSMq/+pE7/+V50Q5g+A
         Hw+QcI8OIxCjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D25FAE1CABE;
        Wed,  7 Sep 2022 18:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v11 0/7] bpf-core changes for preparation of
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166257421685.4794.15651156526607551143.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 18:10:16 +0000
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, memxor@gmail.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue,  6 Sep 2022 17:12:56 +0200 you wrote:
> Hi,
> 
> well, given that the HID changes haven't moved a lot in the past
> revisions and that I am cc-ing a bunch of people, I have dropped them
> while we focus on the last 2 requirements in bpf-core changes.
> 
> I'll submit a HID targeted series when we get these in tree, which
> would make things a lore more independent.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v11,1/7] selftests/bpf: regroup and declare similar kfuncs selftests in an array
    https://git.kernel.org/bpf/bpf-next/c/012ba1156e4a
  - [bpf-next,v11,2/7] bpf: split btf_check_subprog_arg_match in two
    https://git.kernel.org/bpf/bpf-next/c/95f2f26f3cac
  - [bpf-next,v11,3/7] bpf/verifier: allow all functions to read user provided context
    https://git.kernel.org/bpf/bpf-next/c/15baa55ff5b0
  - [bpf-next,v11,4/7] selftests/bpf: add test for accessing ctx from syscall program type
    https://git.kernel.org/bpf/bpf-next/c/fb66223a244f
  - [bpf-next,v11,5/7] bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
    https://git.kernel.org/bpf/bpf-next/c/f9b348185f4d
  - [bpf-next,v11,6/7] bpf/verifier: allow kfunc to return an allocated mem
    https://git.kernel.org/bpf/bpf-next/c/eb1f7f71c126
  - [bpf-next,v11,7/7] selftests/bpf: Add tests for kfunc returning a memory pointer
    https://git.kernel.org/bpf/bpf-next/c/22ed8d5a4652

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


