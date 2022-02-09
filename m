Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B224AE946
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbiBIF1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiBIFU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396FDC03CA4E;
        Tue,  8 Feb 2022 21:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4CF7ACE1E35;
        Wed,  9 Feb 2022 05:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9012EC340F0;
        Wed,  9 Feb 2022 05:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384025;
        bh=k6PypT7qH2lRLxSC1Wl+El4Grn8uim7k/ofn7s3Gc0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YZsE6yiZYMfoaSawVVi6oy6IiZxn+u5SeK5Dck+aGKMhulgY5JaxKVHc0HHDzXC9e
         ashYE7L3yZumzu15qvFFoOd9aU6hd5qZKE/ueING/GkeulPhPK0dUYHDq3Aopyzt7n
         ytLlolNHPWI+ZaSct46Yn/5KKp8MJJDp9t3iHTl9/n5gLzZY7QtOMELTWn5qKAbw/h
         31sWVPHvLp7ve+Pi7iNjoDU8PDoUGAo8o5Lx22EIZuY0snHvUcDY9PF+H0uVZm/QII
         fXwIDwoA71QHSOQiRLN1wl2BysLrUOafmDyjl0o3I84DvcFVVbj8JbZ7SIXppLP3LM
         xsWcylQPMOrQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 765DDE5D09D;
        Wed,  9 Feb 2022 05:20:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] fix bpf_prog_pack build errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438402548.12376.6829583277073012575.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:25 +0000
References: <20220208220509.4180389-1-song@kernel.org>
In-Reply-To: <20220208220509.4180389-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com
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

On Tue, 8 Feb 2022 14:05:07 -0800 you wrote:
> Fix build errors reported by kernel test robot.
> 
> Song Liu (2):
>   bpf: fix leftover header->pages in sparc and powerpc code.
>   bpf: fix bpf_prog_pack build HPAGE_PMD_SIZE
> 
>  arch/powerpc/net/bpf_jit_comp.c  | 2 +-
>  arch/sparc/net/bpf_jit_comp_64.c | 2 +-
>  kernel/bpf/core.c                | 4 ++++
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf: fix leftover header->pages in sparc and powerpc code.
    https://git.kernel.org/bpf/bpf-next/c/0f350231b5ac
  - [bpf-next,2/2] bpf: fix bpf_prog_pack build HPAGE_PMD_SIZE
    https://git.kernel.org/bpf/bpf-next/c/c1b13a9451ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


