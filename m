Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850564FB261
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 05:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiDKDcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 23:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244580AbiDKDc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 23:32:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0DF36300;
        Sun, 10 Apr 2022 20:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD262B8108E;
        Mon, 11 Apr 2022 03:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FB1DC385AA;
        Mon, 11 Apr 2022 03:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649647812;
        bh=KPWGZxeJcdtMOA9v/bD97Fc8EjRW2dksoSRXlDuEqP8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AI1c1OfJpcZWutVtQ5UP75AA59vqvBY6V4164rR+d8agnl7I1bzwxR4xSgVZp5uut
         sYy15EbFq8J9afl25fZjx6hXIAEGub7TvOenidrsc7Vo7oDlo830z2MXWsGKOQDLgh
         /sPCX5U87rf9Sfoj0p6BSXUykPZn6qAyBzCkvrPAATVV2ohjnlsMzXomPVYjMvHPSe
         xaFa7vpaNBqz+fA1TgWKrBSLjnnqqC++/t5WNA87gGppjqWlMyNugb5W2aR6BJojrz
         kKPk1rukX9ov9P8Xgb/Op8reFOv4+W2eQVvWYRmcuR0AccmnaeqfusB+0FK6BXOeYv
         fxBZU4qtwitPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4EDE5E85D90;
        Mon, 11 Apr 2022 03:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4 0/4] bpf: RLIMIT_MEMLOCK cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164964781231.15976.11920610137850939633.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 03:30:12 +0000
References: <20220409125958.92629-1-laoar.shao@gmail.com>
In-Reply-To: <20220409125958.92629-1-laoar.shao@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Sat,  9 Apr 2022 12:59:54 +0000 you wrote:
> We have switched to memcg-based memory accouting and thus the rlimit is
> not needed any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK was introduced in
> libbpf for backward compatibility, so we can use it instead now.
> 
> This patchset cleanups the usage of RLIMIT_MEMLOCK in tools/bpf/,
> tools/testing/selftests/bpf and samples/bpf. The file
> tools/testing/selftests/bpf/bpf_rlimit.h is removed. The included header
> sys/resource.h is removed from many files as it is useless in these files.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4,1/4] samples/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
    https://git.kernel.org/bpf/bpf-next/c/b25acdafd373
  - [bpf-next,v4,2/4] selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
    https://git.kernel.org/bpf/bpf-next/c/b858ba8c52b6
  - [bpf-next,v4,3/4] bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
    https://git.kernel.org/bpf/bpf-next/c/a777e18f1bcd
  - [bpf-next,v4,4/4] tools/runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
    https://git.kernel.org/bpf/bpf-next/c/451b5fbc2c56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


