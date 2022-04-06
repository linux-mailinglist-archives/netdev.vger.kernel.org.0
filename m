Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83D14F541C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355169AbiDFEWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390337AbiDFDEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 23:04:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38BD33E07;
        Tue,  5 Apr 2022 17:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABCA06153E;
        Wed,  6 Apr 2022 00:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B6B5C385A1;
        Wed,  6 Apr 2022 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649203214;
        bh=KMNIOTy7tQqMiQJt2a1NiAN3Cf5KwEY7COeHi3Y3npQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WY3GCFkU9JF3B4v5HSCFdz0Gj1g3tb96D7PZJkiSm3vvC8jb4MWHldVEgv5bCarKh
         FWQCvugxZ2/CJSFokNg9fa9+Hgivxt8yKUATeDfmS/qrTyAEFf2bzVv73Qyz8tTQmd
         wV32dqGQxfQP6I+vUAWitf0/Fu8a5GWZ+W+O3SjU03jfpTzmIPE0DzxD+79U/Mamls
         smqmtdr/Bvo2LEC6L8pXtT6x62lQUBUDe0+CpAL1stRKfhEU1ZMsz+691auXyuZHM3
         7TNBTaLkX2QOSi+7vwLyYimeZf/XStjOuJcZHj/p6CRltTsVivnrOoHA/zHGyBJIfx
         Fk1tgNG+yQunw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5D48E6D402;
        Wed,  6 Apr 2022 00:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix file descriptor leak in
 load_kallsyms()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164920321379.789.15662598832496347807.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 00:00:13 +0000
References: <20220405145711.49543-1-ytcoode@gmail.com>
In-Reply-To: <20220405145711.49543-1-ytcoode@gmail.com>
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

On Tue,  5 Apr 2022 22:57:11 +0800 you wrote:
> Currently, if sym_cnt > 0, it just returns and does not close file, fix it.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/testing/selftests/bpf/trace_helpers.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [bpf-next] selftests/bpf: Fix file descriptor leak in load_kallsyms()
    https://git.kernel.org/bpf/bpf-next/c/2d0df01974ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


