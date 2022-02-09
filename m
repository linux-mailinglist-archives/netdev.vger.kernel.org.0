Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E422C4AFDB6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 20:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiBITuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 14:50:10 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBITuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 14:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F26E04A464;
        Wed,  9 Feb 2022 11:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD30B61A5E;
        Wed,  9 Feb 2022 19:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 143E3C340ED;
        Wed,  9 Feb 2022 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644436209;
        bh=e8pFvxbhVbgkPJkmtPCFaSXj3mo359c3fo7jbgvyb3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pmKkCDn4T19FF6cOMV2tpd42bcr4uKdK7OxXuLutkGplb2+uqZ2SjiuVdoswDFIIK
         rnsCK+2ypNOXMzc3hsAMkcjDYmadBfMZE41u1Kcxz9rzEN9OoZtsdN3j/eWJyyb8Xf
         4NaNpGxtdE20UTOnpc2Hk2th2rOhCOaZ6RHDmL9FE20YX1Yviro0jFb0tSBFbKWMR6
         JtZhG0Iqtl1Axf92K5LY7evz9t8IF1ma+rgXMl3YiDN6KzCD8orfM1l54CHduQDVs3
         zdoQz2+h4vHTsZpSiiA4zHRlRdOv+PA/rnMaW+yVuLzo03GPx+il9FPngRvn1J7M02
         9/6uvidHWA2Ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F11CDE6D447;
        Wed,  9 Feb 2022 19:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] Split bpf_sk_lookup remote_port field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164443620898.30796.17334556024163355601.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 19:50:08 +0000
References: <20220209184333.654927-1-jakub@cloudflare.com>
In-Reply-To: <20220209184333.654927-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@cloudflare.com, yhs@fb.com
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

On Wed,  9 Feb 2022 19:43:31 +0100 you wrote:
> Following the recent split-up of the bpf_sock dst_port field, apply the same to
> technique to the bpf_sk_lookup remote_port field to make uAPI more user
> friendly.
> 
> v1 -> v2:
> - Remove remote_port range check and cast to be16 in TEST_RUN for sk_lookup
>   (kernel test robot)
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
    https://git.kernel.org/bpf/bpf-next/c/9a69e2b385f4
  - [bpf-next,v2,2/2] selftests/bpf: Cover 4-byte load from remote_port in bpf_sk_lookup
    https://git.kernel.org/bpf/bpf-next/c/2ed0dc5937d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


