Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5AE4D58C5
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244166AbiCKDVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiCKDVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:21:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0061A7D92;
        Thu, 10 Mar 2022 19:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89D17610A2;
        Fri, 11 Mar 2022 03:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBE5AC340EF;
        Fri, 11 Mar 2022 03:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646968812;
        bh=VsGSHD7E4OpMLRoeX2QE+gkBvx0t0j1p1Ol0/Z7+yS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=luK9NBPoQgXMbyWFT8nnbcOtbyvjfOpUXfoOyFuWrpBiEM/r/ufilfCNcmQ3oVX/N
         x6EmdIwPtaD6MCifUK+Hc8W3j4ClYF0ea+osOGypIv+l54kemQJm3teGPCbJrg/K+D
         PMfBAcbK1yHAMxvAjhMlIAtNyo5vkumxWmasEyVMW/j1VhX1tIcNLPBnZg1kJ9YboQ
         vOVi5oPXv6Wd0LhliEjJ+UFFRokUEInZd6Fh9pxft3HJKZU+TLVmYVV8hauMZn3vMA
         fC+cLp4bWjNI6uMmh0gGsKjYyzPxK5wEkV8O8OOQ0rWS5p7UO6vRDIsdb3yCy6RiOs
         VhEo/gLcl723g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE6D9EAC095;
        Fri, 11 Mar 2022 03:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164696881277.12219.12423811667872228529.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 03:20:12 +0000
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
In-Reply-To: <20220302111404.193900-1-roberto.sassu@huawei.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     zohar@linux.ibm.com, shuah@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, revest@chromium.org,
        gregkh@linuxfoundation.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed, 2 Mar 2022 12:13:55 +0100 you wrote:
> Extend the interoperability with IMA, to give wider flexibility for the
> implementation of integrity-focused LSMs based on eBPF.
> 
> Patch 1 fixes some style issues.
> 
> Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
> measurement capability of IMA without needing to setup a policy in IMA
> (those LSMs might implement the policy capability themselves).
> 
> [...]

Here is the summary with links:
  - [v3,1/9] ima: Fix documentation-related warnings in ima_main.c
    https://git.kernel.org/bpf/bpf-next/c/bae60eefb95c
  - [v3,2/9] ima: Always return a file measurement in ima_file_hash()
    https://git.kernel.org/bpf/bpf-next/c/280fe8367b0d
  - [v3,3/9] bpf-lsm: Introduce new helper bpf_ima_file_hash()
    https://git.kernel.org/bpf/bpf-next/c/174b16946e39
  - [v3,4/9] selftests/bpf: Move sample generation code to ima_test_common()
    https://git.kernel.org/bpf/bpf-next/c/2746de3c53d6
  - [v3,5/9] selftests/bpf: Add test for bpf_ima_file_hash()
    https://git.kernel.org/bpf/bpf-next/c/27a77d0d460c
  - [v3,6/9] selftests/bpf: Check if the digest is refreshed after a file write
    https://git.kernel.org/bpf/bpf-next/c/91e8fa254dbd
  - [v3,7/9] bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
    https://git.kernel.org/bpf/bpf-next/c/df6b3039fa11
  - [v3,8/9] selftests/bpf: Add test for bpf_lsm_kernel_read_file()
    https://git.kernel.org/bpf/bpf-next/c/e6dcf7bbf37c
  - [v3,9/9] selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA policy
    https://git.kernel.org/bpf/bpf-next/c/7bae42b68d7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


