Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CEC5FDD8B
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJMPu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJMPuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB805E304;
        Thu, 13 Oct 2022 08:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5818B81F20;
        Thu, 13 Oct 2022 15:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66D1BC433D7;
        Thu, 13 Oct 2022 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665676217;
        bh=6Jmi9yxaqUq0TiuKlx6pKicXoRk7Q06JDNLxaUfZ8A0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H82fgKs74BZSHePBrCvnMYSm0Bh5prZWgg6ed88gOAuomxlkrxveqyA9VFfCJUbyd
         HT6d55BqleSzMG446hj3FI7OnmjV29mEb0ZNIAvWsWROGf0yHduNLOmkMKZHzwTBBg
         HD5dexYuEFu33hOvRq3+pCO5Exse0UiyhGJ2DR95V8am2bmXKazcDPdtIQ0hhWlvt2
         Gwlc54cNJuzeo5Tnp9xTLDIRHnFFtOagH8NsWqA5WWhtQlG6DXxdEMd3nycIne5qgs
         y9Yisy0Me5XQBkaynP1oNJ2XckxcT/BKxuWD1aHtp9ADacJys8eX6d3yyHcB10RV87
         zx3dWGZeXyw6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42D9BE29F30;
        Thu, 13 Oct 2022 15:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4 0/6] Fix bugs found by ASAN when running selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166567621726.30586.15920096866905291891.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Oct 2022 15:50:17 +0000
References: <20221011120108.782373-1-xukuohai@huaweicloud.com>
In-Reply-To: <20221011120108.782373-1-xukuohai@huaweicloud.com>
To:     Xu Kuohai <xukuohai@huaweicloud.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        shuah@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, memxor@gmail.com, alan.maguire@oracle.com,
        delyank@fb.com, lorenzo@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 11 Oct 2022 08:01:02 -0400 you wrote:
> From: Xu Kuohai <xukuohai@huawei.com>
> 
> This series fixes bugs found by ASAN when running bpf selftests on arm64.
> 
> v4:
> - Address Andrii's suggestions
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4,1/6] libbpf: Fix use-after-free in btf_dump_name_dups
    https://git.kernel.org/bpf/bpf-next/c/02c1e5b0bbb8
  - [bpf-next,v4,2/6] libbpf: Fix memory leak in parse_usdt_arg()
    https://git.kernel.org/bpf/bpf-next/c/cd168cc6f685
  - [bpf-next,v4,3/6] selftests/bpf: Fix memory leak caused by not destroying skeleton
    https://git.kernel.org/bpf/bpf-next/c/fbca16071678
  - [bpf-next,v4,4/6] selftest/bpf: Fix memory leak in kprobe_multi_test
    https://git.kernel.org/bpf/bpf-next/c/159c69121102
  - [bpf-next,v4,5/6] selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
    https://git.kernel.org/bpf/bpf-next/c/496848b47126
  - [bpf-next,v4,6/6] selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c
    https://git.kernel.org/bpf/bpf-next/c/cafecc0e3df3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


