Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EA556A5A7
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 16:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbiGGOkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 10:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiGGOkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 10:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30672AE07;
        Thu,  7 Jul 2022 07:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5925E62291;
        Thu,  7 Jul 2022 14:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE044C341CB;
        Thu,  7 Jul 2022 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657204813;
        bh=1KvycEYKFO2nkS1lPbHEg1sdOsAMasvPKGJN7xLpDGg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dimJlPy5zSYEZaEI0yxNiUEf7Go9DVZwTv4CVDU9JBPcAd8Uuau4oxTHIxIq1GHW7
         C1yhvBykrAEC8OccgUDODYjwy3LHjA+aYaqZKDi5WJ+St/GsV8LwbFRPe+CfD+QYhX
         CY49l+mj7PffKSeb5AWSf4+m5ul2koXyv2DjfoLsnCXgXWh0HA7ynOW6Bmv5znBsHA
         d+DzODEhY0MN3heLKea9qW6lJzgn7PowTH2xDfT/HAyQzSROs51M/FCN9HhGYQI68G
         VEYc8YN3/GrTEsA1dj6bpAnLjXIoLgDxjgaEq81Dd3v9M1St0YZAGnxYh2xUJNX19j
         ZtR5S78HIf7lw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88F80E45BDC;
        Thu,  7 Jul 2022 14:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] riscv, libbpf: use a0 for RC register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165720481355.13867.6133173423267200694.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 14:40:13 +0000
References: <20220706140204.47926-1-dlan@gentoo.org>
In-Reply-To: <20220706140204.47926-1-dlan@gentoo.org>
To:     Yixun Lan <dlan@gentoo.org>
Cc:     linux-riscv@lists.infradead.org, bjorn@kernel.org,
        bpf@vger.kernel.org, palmer@dabbelt.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, chenhengqi@outlook.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed,  6 Jul 2022 22:02:04 +0800 you wrote:
> According to the RISC-V calling convention register usage here[1],
> a0 is used as return value register, so rename it to make it consistent
> with the spec.
> 
> [1] section 18.2, table 18.2
> https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf
> 
> [...]

Here is the summary with links:
  - riscv, libbpf: use a0 for RC register
    https://git.kernel.org/bpf/bpf-next/c/935dc35c7531

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


