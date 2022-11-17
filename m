Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1005962E99D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiKQXaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiKQXaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA791101;
        Thu, 17 Nov 2022 15:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEE2D62287;
        Thu, 17 Nov 2022 23:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F31CC433D6;
        Thu, 17 Nov 2022 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668727816;
        bh=FhiyCof4/fOvLHe+Xa1w/QZuG5s46sbjoPQRXM8h11k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TKXWYBPuhOeul+mRoD6TrcBJXnt+/FfgfeV30/QnD0jolKO6fRH+qVyF6guIxsRD2
         tJirBNNGnKfuqn47ID8fQMlCXtGd/z3rrpLRoDqnN31tSgDgr/U1aJchOKmOHhbPbD
         FkT2G9pBzkvtvwdfBhNixLzehQ3zhapXlheDlm+qCuocn+N15fmQX3hp0vbrKrReWI
         iuOfmYw3enbNJgOalpaxdGGJxNukutJiazGtwflNVYbMKiwYL8XqBL9TKM18A/sNV5
         AB9RDqbc0BQ1E+2NFJo553mNvDFgQHN9gw6+8WsbpTpovdlywo7MWtc9wd9n1RpnSL
         9DHxOdEUrNe1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36A51E21EFA;
        Thu, 17 Nov 2022 23:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf 1/2] selftests/bpf: Explicitly pass RESOLVE_BTFIDS to
 sub-make
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166872781621.28336.4991961626759200885.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 23:30:16 +0000
References: <20221115182051.582962-1-bjorn@kernel.org>
In-Reply-To: <20221115182051.582962-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     bpf@vger.kernel.org, andrii@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, bjorn@rivosinc.com,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        anders.roxell@linaro.org, mykolal@fb.com,
        linux-kselftest@vger.kernel.org
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

On Tue, 15 Nov 2022 19:20:50 +0100 you wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> When cross-compiling selftests/bpf, the resolve_btfids binary end up
> in a different directory, than the regular resolve_btfids
> builds. Populate RESOLVE_BTFIDS for sub-make, so it can find the
> binary.
> 
> [...]

Here is the summary with links:
  - [bpf,1/2] selftests/bpf: Explicitly pass RESOLVE_BTFIDS to sub-make
    https://git.kernel.org/bpf/bpf-next/c/c4525f05ca3c
  - [bpf,2/2] selftests/bpf: Pass target triple to get_sys_includes macro
    https://git.kernel.org/bpf/bpf-next/c/98b2afc8a67f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


