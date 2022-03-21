Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AB04E1EF9
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 03:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344137AbiCUCLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 22:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbiCUCLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 22:11:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE76D12E774;
        Sun, 20 Mar 2022 19:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C78E0CE12CE;
        Mon, 21 Mar 2022 02:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D730BC340F0;
        Mon, 21 Mar 2022 02:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647828610;
        bh=dmJaM8pSN3Q47PrSfm6KBYcZyyHqe6iSZEpGeXjHSmo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N1pR5RPLo7FXsCnIlYTt4Dq1Esz0RL+KfGMG7bYBOg1iTKjuJOq/rTIKYOx//lJzm
         EDwyHUCINC1GIm3OQS8WD3svVr/tGkoCaewKW6rhdXmkYLnrfkHownPxIftDWXhtUL
         AherlntDypFiedf8Z/JiV4XObt8KcEwlD19WoZVUTi1nYKR7ZjIenEuJx+QkuIFnTo
         QTdJdjfO1CGO61u20lKFRT1VsVu+ZpyYF/SpON5jMOPziUCCX+pNHxJCaJvUuve64f
         FXEbbGw2I0QRpP1jf5TOWibiDNTGYyyHnp/z8032nWdap4tn7CwbodutNWiurJ8lp7
         EZHhKr4xjQlNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BAF74EAC096;
        Mon, 21 Mar 2022 02:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/3] Make 2-byte access to
 bpf_sk_lookup->remote_port endian-agnostic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164782861076.4078.4417800847243367932.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 02:10:10 +0000
References: <20220319183356.233666-1-jakub@cloudflare.com>
In-Reply-To: <20220319183356.233666-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@cloudflare.com, kafai@fb.com, iii@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 19 Mar 2022 19:33:53 +0100 you wrote:
> This patch set is a result of a discussion we had around the RFC patchset from
> Ilya [1]. The fix for the narrow loads from the RFC series is still relevant,
> but this series does not depend on it. Nor is it required to unbreak sk_lookup
> tests on BE, if this series gets applied.
> 
> To summarize the takeaways from [1]:
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/3] bpf: Treat bpf_sk_lookup remote_port as a 2-byte field
    https://git.kernel.org/bpf/bpf-next/c/058ec4a7d9cf
  - [bpf-next,v2,2/3] selftests/bpf: Fix u8 narrow load checks for bpf_sk_lookup remote_port
    https://git.kernel.org/bpf/bpf-next/c/3c69611b8926
  - [bpf-next,v2,3/3] selftests/bpf: Fix test for 4-byte load from remote_port on big-endian
    https://git.kernel.org/bpf/bpf-next/c/ce5236800116

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


