Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F457539962
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348324AbiEaWKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiEaWKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A701712D8;
        Tue, 31 May 2022 15:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F0161411;
        Tue, 31 May 2022 22:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CB4FC3411C;
        Tue, 31 May 2022 22:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654035013;
        bh=NHduzSrHSTkUo6SczPZztFAfc6A9Ik98aFoaPiMWvi4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JuM1QIOPY+n2Teh9EVDZ5gXbDQ60zIFEMsSDrEyz6TaQNCGSrTUIL/rEvX1KcsRvm
         VJiek5m3z+SwrCx8PfQQjY3bQAECivfJNXL9FiMgVpd/WQbAgsO1tJ2JAECXEfnSkQ
         HFf3y92EgooLb5CcwfyBOJoXlMAFAbvJUKhba3TIIItwlDCkQgyRQBiKBdrGNDEITq
         cQ2SZz1BPFMuDawrqbEyyxP6+yNgb0MKC2LONz8U8KdGLWHoZtIqHKto6dRtDLVI8C
         lN80k5rWy+e2/BoaaVAbVall9DC3j5zaqcIOX9mJknzoVojWFWgq7UT/HPML7R5lic
         gqFfJYOL/FAuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 647D1F0383D;
        Tue, 31 May 2022 22:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_run logic in fexit_stress.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165403501340.21268.15920693593241298541.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 22:10:13 +0000
References: <20220521151329.648013-1-ytcoode@gmail.com>
In-Reply-To: <20220521151329.648013-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 21 May 2022 23:13:29 +0800 you wrote:
> In the commit da00d2f117a0 ("bpf: Add test ops for BPF_PROG_TYPE_TRACING"),
> the bpf_fentry_test1 function was moved into bpf_prog_test_run_tracing(),
> which is the test_run function of the tracing BPF programs.
> 
> Thus calling 'bpf_prog_test_run_opts(filter_fd, &topts)' will not trigger
> bpf_fentry_test1 function as filter_fd is a sk_filter BPF program.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: Fix test_run logic in fexit_stress.c
    https://git.kernel.org/bpf/bpf-next/c/960b8ef9609c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


