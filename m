Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835FD5BEF64
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiITVuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiITVuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB7F63E7;
        Tue, 20 Sep 2022 14:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CCEE62E49;
        Tue, 20 Sep 2022 21:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68153C433C1;
        Tue, 20 Sep 2022 21:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663710615;
        bh=ARRvbxIcJ7M+YQg21nn//eBVp6Y44LRwd1TWR31zn+Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FnKCuiZ5NHYpjX+lYO5LMGY8SePJ5m/2JLRCkM1WZTygn+cHDqUfpZS5IMr6jDa2z
         B2aDLhpOh/0XGYbf5US4LJdWx4njvmQoooV5hEMlf19M7Lyn31CqdqzPI0Pb5SY607
         k+tI7o27j3Tte2lLTyMwPBlgNcu9hmOkTtscFijh1i8VvRJKWH/l7rJOJ8R7pyIqlH
         JQqrOF/WnEeJQlK7RSzdWUguUGh4bMMkuMtnv0KEYisLyYVt3Rh6iWF7BKnHAaqDtJ
         Oj5xcsRrbW6JF/R5vwSfffaQrvkTPtnkfZvnhV3nwuUA2xDstbSONxsR2OT/97IifB
         xErHn650daP5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 46273E21EE0;
        Tue, 20 Sep 2022 21:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/3] bpf: Small nf_conn cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166371061528.14033.10203496581444033110.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 21:50:15 +0000
References: <cover.1663683114.git.dxu@dxuuu.xyz>
In-Reply-To: <cover.1663683114.git.dxu@dxuuu.xyz>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev,
        pablo@netfilter.org, fw@strlen.de, toke@kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Martin KaFai Lau <martin.lau@kernel.org>:

On Tue, 20 Sep 2022 08:15:21 -0600 you wrote:
> This patchset cleans up a few small things:
> 
> * Delete unused stub
> * Rename variable to be more descriptive
> * Fix some `extern` declaration warnings
> 
> Past discussion:
> - v2: https://lore.kernel.org/bpf/cover.1663616584.git.dxu@dxuuu.xyz/
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/3] bpf: Remove unused btf_struct_access stub
    https://git.kernel.org/bpf/bpf-next/c/52bdae37c92a
  - [bpf-next,v3,2/3] bpf: Rename nfct_bsa to nfct_btf_struct_access
    https://git.kernel.org/bpf/bpf-next/c/5a090aa35038
  - [bpf-next,v3,3/3] bpf: Move nf_conn extern declarations to filter.h
    https://git.kernel.org/bpf/bpf-next/c/fdf214978a71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


