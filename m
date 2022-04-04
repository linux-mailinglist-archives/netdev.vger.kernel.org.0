Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B8A4F0D27
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350581AbiDDAMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 20:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241240AbiDDAMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 20:12:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E9D13F6B;
        Sun,  3 Apr 2022 17:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2B8460FF5;
        Mon,  4 Apr 2022 00:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1260C340F2;
        Mon,  4 Apr 2022 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649031012;
        bh=MpObaTh3p43VrwtDFP8tfQ8niteSKrlB7UujmJqAZ10=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IwJ731gWL1I6R8EngP+PapPvbKBNs1HV/KESeWUVU3WxIJZKE5oNHJHDLFKJ9NrRE
         At2Cju6EYqye+t2OwTiKiIq6Z634Qc6HomoJO8gxYi9jJ3MM1mcCbWhHI8srHBiiiN
         Jg7rgAZmCFVGnmYB+aMv4BFmQMNQAqfOOtY3KFqA/oK57r2nqsDSfYA0YCR5Sq023r
         5daYGLGhtPa5FI2ReVEAFcgxRevXW8yvWtSZMbCseE+rbB+qXI3ObGm7bpHOu85baz
         QjB4muSBCQWovmZd0CfeywgfYQ3gaaWgMA9QtOTBDf1Xd59I60Wi/eC5Iak1ayhHKS
         iWnBagclqrgMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CAEE3E85AE7;
        Mon,  4 Apr 2022 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix cd_flavor_subdir() of test_progs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164903101181.15203.10673780637284892563.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 00:10:11 +0000
References: <20220403135245.1713283-1-ytcoode@gmail.com>
In-Reply-To: <20220403135245.1713283-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Sun,  3 Apr 2022 21:52:45 +0800 you wrote:
> Currently, when we run test_progs with just executable file name, for
> example 'PATH=. test_progs-no_alu32', cd_flavor_subdir() will not check
> if test_progs is running as a flavored test runner and switch into
> corresponding sub-directory.
> 
> This will cause test_progs-no_alu32 executed by the
> 'PATH=. test_progs-no_alu32' command to run in the wrong directory and
> load the wrong BPF objects.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Fix cd_flavor_subdir() of test_progs
    https://git.kernel.org/bpf/bpf-next/c/9bbad6dab827

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


