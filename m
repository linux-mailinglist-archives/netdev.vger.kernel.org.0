Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CCF52F616
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 01:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344994AbiETXUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 19:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiETXUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 19:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF65193237;
        Fri, 20 May 2022 16:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65A9CB82E83;
        Fri, 20 May 2022 23:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EF36C34113;
        Fri, 20 May 2022 23:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653088812;
        bh=pxfXzwf2fgybsIKDaD5Oz1d3k5S72HQUOYo91VWrp0U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WbY3AD4Fd7hbAM6ytlQ6Y9f7eVl0Vw2swErVigsjQtv8ej3F8OCq98ml2Sva1bEyk
         +On+wdohLysfQfPn5JSmqSCnA/fIlWb7EunQ0j18hKNVjU+l8UpjX2wp4R29IB9Oq1
         /Kdp0xqLigC7cajRN5ccXrr48fB3Z2l/6ipsNB7bGtd1CP+x9jj+gk6KC4sDtcMK77
         xGDqIIjz8qEViFhMErhj3leX6UnO+B0OzUg4KWY45heQaWyFfBGQi49mTj8wSqgTWx
         u/KTVqbcMNZEOSHGnkKwUQ+bW4QdqbzQ+ZvjGweeIGQlv4qRQ+UMLWBKw5W72d8djb
         sWk0qiXB9CLww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 037E5F0383D;
        Fri, 20 May 2022 23:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Add missing trampoline program
 type to trampoline_count test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165308881201.22265.16897739421546601910.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 23:20:12 +0000
References: <20220519150610.601313-1-ytcoode@gmail.com>
In-Reply-To: <20220519150610.601313-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     andrii.nakryiko@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, jolsa@kernel.org, kafai@fb.com,
        kpsingh@kernel.org, kuifeng@fb.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, songliubraving@fb.com, sunyucong@gmail.com,
        toke@redhat.com, yhs@fb.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 May 2022 23:06:10 +0800 you wrote:
> Currently the trampoline_count test doesn't include any fmod_ret bpf
> programs, fix it to make the test cover all possible trampoline program
> types.
> 
> Since fmod_ret bpf programs can't be attached to __set_task_comm function,
> as it's neither whitelisted for error injection nor a security hook, change
> it to bpf_modify_return_test.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] selftests/bpf: Add missing trampoline program type to trampoline_count test
    https://git.kernel.org/bpf/bpf-next/c/b23316aabffa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


