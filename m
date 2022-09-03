Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4953B5ABCA4
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 05:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiICDuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 23:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiICDuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 23:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59F25A883;
        Fri,  2 Sep 2022 20:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21993621AB;
        Sat,  3 Sep 2022 03:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78324C433D6;
        Sat,  3 Sep 2022 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662177019;
        bh=I4BYw1AbwIAZgnbk6kAzWoNLDpi6ePxRNZJ6m0+1CRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Za5Lxy35TjibvBhAPIfRlNKJ4k7JDT+EzkU/LSw6pTa7wCRwMCrOfu5VqF3fur1p6
         ffBcsB5vcfp+9xE6yMyvRLHjlUBMVHJIgLb+DlomhYQTkFAn2a3V3+CIF8YqJIx+wy
         ED/sWfQ/Jrah6Q+Q7885wmcSVL9b5b5bG+grXzzlDRuJkhyCDBT80PjSeHbW5FZs/F
         MODOKcTus0gwKITEDFpGeY2qZkGZm5LTLr6KChRL9oNWXHXw43vslWvps1x97nOYYK
         tZsiG20YCKWqSviJwJV8/DQPhFH3otD9w03sXxfyVe8Ad2u3C3r9Vhs7ENqsQPaOzf
         wCLKPAD+LAFaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C0B5C4166E;
        Sat,  3 Sep 2022 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 00/17] bpf: net: Remove duplicated code from
 bpf_getsockopt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166217701936.16352.10281500162790893698.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 03:50:19 +0000
References: <20220902002750.2887415-1-kafai@fb.com>
In-Reply-To: <20220902002750.2887415-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kernel-team@fb.com,
        pabeni@redhat.com
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

On Thu, 1 Sep 2022 17:27:50 -0700 you wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> The earlier commits [0] removed duplicated code from bpf_setsockopt().
> This series is to remove duplicated code from bpf_getsockopt().
> 
> Unlike the setsockopt() which had already changed to take
> the sockptr_t argument, the same has not been done to
> getsockopt().  This is the extra step being done in this
> series.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,01/17] net: Change sock_getsockopt() to take the sk ptr instead of the sock ptr
    https://git.kernel.org/bpf/bpf-next/c/ba74a7608dc1
  - [v2,bpf-next,02/17] bpf: net: Change sk_getsockopt() to take the sockptr_t argument
    https://git.kernel.org/bpf/bpf-next/c/4ff09db1b79b
  - [v2,bpf-next,03/17] bpf: net: Avoid sk_getsockopt() taking sk lock when called from bpf
    https://git.kernel.org/bpf/bpf-next/c/2c5b6bf5cda0
  - [v2,bpf-next,04/17] bpf: net: Change do_tcp_getsockopt() to take the sockptr_t argument
    https://git.kernel.org/bpf/bpf-next/c/34704ef024ae
  - [v2,bpf-next,05/17] bpf: net: Avoid do_tcp_getsockopt() taking sk lock when called from bpf
    https://git.kernel.org/bpf/bpf-next/c/d51bbff2aba7
  - [v2,bpf-next,06/17] bpf: net: Change do_ip_getsockopt() to take the sockptr_t argument
    https://git.kernel.org/bpf/bpf-next/c/728f064cd7eb
  - [v2,bpf-next,07/17] bpf: net: Avoid do_ip_getsockopt() taking sk lock when called from bpf
    https://git.kernel.org/bpf/bpf-next/c/1985320c54dd
  - [v2,bpf-next,08/17] net: Remove unused flags argument from do_ipv6_getsockopt
    https://git.kernel.org/bpf/bpf-next/c/75f23979888a
  - [v2,bpf-next,09/17] net: Add a len argument to compat_ipv6_get_msfilter()
    https://git.kernel.org/bpf/bpf-next/c/9c3f9707decd
  - [v2,bpf-next,10/17] bpf: net: Change do_ipv6_getsockopt() to take the sockptr_t argument
    https://git.kernel.org/bpf/bpf-next/c/6dadbe4bac68
  - [v2,bpf-next,11/17] bpf: net: Avoid do_ipv6_getsockopt() taking sk lock when called from bpf
    https://git.kernel.org/bpf/bpf-next/c/0f95f7d42611
  - [v2,bpf-next,12/17] bpf: Embed kernel CONFIG check into the if statement in bpf_getsockopt
    https://git.kernel.org/bpf/bpf-next/c/c2b063ca3458
  - [v2,bpf-next,13/17] bpf: Change bpf_getsockopt(SOL_SOCKET) to reuse sk_getsockopt()
    https://git.kernel.org/bpf/bpf-next/c/65ddc82d3b96
  - [v2,bpf-next,14/17] bpf: Change bpf_getsockopt(SOL_TCP) to reuse do_tcp_getsockopt()
    https://git.kernel.org/bpf/bpf-next/c/273b7f0fb448
  - [v2,bpf-next,15/17] bpf: Change bpf_getsockopt(SOL_IP) to reuse do_ip_getsockopt()
    https://git.kernel.org/bpf/bpf-next/c/fd969f25fe24
  - [v2,bpf-next,16/17] bpf: Change bpf_getsockopt(SOL_IPV6) to reuse do_ipv6_getsockopt()
    https://git.kernel.org/bpf/bpf-next/c/38566ec06f52
  - [v2,bpf-next,17/17] selftest/bpf: Add test for bpf_getsockopt()
    https://git.kernel.org/bpf/bpf-next/c/f649f992deee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


