Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0643D6A72E2
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCASKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCASK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:10:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0E73D087;
        Wed,  1 Mar 2023 10:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 273C66144F;
        Wed,  1 Mar 2023 18:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86534C4339B;
        Wed,  1 Mar 2023 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677694219;
        bh=NvqbQPfNT8/mBCN/R6ERVi6Ly/6FYEjQpl/SK6ePBxw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rKc7ZgnM1G/SwvkUZwNfpyY5DQHw6Vwgsvopw2EZQtYUKNpiIXOcR2VXycsJW1i93
         42ix8+/jwZ7hxGe95OmYY0wGKhjLU9BQigyGZGYNoICvHXGhu5hb2vFRc1dJSNNJPJ
         6FMMepLEDiWip3k+g9qAy5v/q1AoZ9y8Ybo3maHxZVRSvYwnIXNX2wmzgFken+YoRd
         y0yk2vH4M7z+uYg3401y0YVZyVkEvcZJyO0F9HvwnKbJwiMU3XKmGXsY94j46xXRMP
         AdVsc1T5g3TQEia0WLQQD9YjqqEXo1wdHwCUNOE8P6jc4IOJ59UxfiwslKAk3iDVRQ
         diiuNkuyB5n+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DE94C395EC;
        Wed,  1 Mar 2023 18:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v13 bpf-next 00/10] Add skb + xdp dynptrs 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167769421944.16358.12443693977215512909.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Mar 2023 18:10:19 +0000
References: <20230301154953.641654-1-joannelkoong@gmail.com>
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, martin.lau@kernel.org, andrii@kernel.org,
        ast@kernel.org, memxor@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, toke@kernel.org
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
by Alexei Starovoitov <ast@kernel.org>:

On Wed,  1 Mar 2023 07:49:43 -0800 you wrote:
> This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
> 
> This patchset adds skb and xdp type dynptrs, which have two main benefits for
> packet parsing:
>     * allowing operations on sizes that are not statically known at
>       compile-time (eg variable-sized accesses).
>     * more ergonomic and less brittle iteration through data (eg does not need
>       manual if checking for being within bounds of data_end)
> 
> [...]

Here is the summary with links:
  - [v13,bpf-next,01/10] bpf: Support "sk_buff" and "xdp_buff" as valid kfunc arg types
    https://git.kernel.org/bpf/bpf-next/c/2f4643934670
  - [v13,bpf-next,02/10] bpf: Refactor process_dynptr_func
    https://git.kernel.org/bpf/bpf-next/c/7e0dac2807e6
  - [v13,bpf-next,03/10] bpf: Allow initializing dynptrs in kfuncs
    https://git.kernel.org/bpf/bpf-next/c/1d18feb2c915
  - [v13,bpf-next,04/10] bpf: Define no-ops for externally called bpf dynptr functions
    https://git.kernel.org/bpf/bpf-next/c/8357b366cbb0
  - [v13,bpf-next,05/10] bpf: Refactor verifier dynptr into get_dynptr_arg_reg
    https://git.kernel.org/bpf/bpf-next/c/485ec51ef976
  - [v13,bpf-next,06/10] bpf: Add __uninit kfunc annotation
    https://git.kernel.org/bpf/bpf-next/c/d96d937d7c5c
  - [v13,bpf-next,07/10] bpf: Add skb dynptrs
    https://git.kernel.org/bpf/bpf-next/c/b5964b968ac6
  - [v13,bpf-next,08/10] bpf: Add xdp dynptrs
    https://git.kernel.org/bpf/bpf-next/c/05421aecd4ed
  - [v13,bpf-next,09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
    https://git.kernel.org/bpf/bpf-next/c/66e3a13e7c2c
  - [v13,bpf-next,10/10] selftests/bpf: tests for using dynptrs to parse skb and xdp buffers
    https://git.kernel.org/bpf/bpf-next/c/cfa7b011894d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


