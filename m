Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524C24CB150
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245119AbiCBVa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235450AbiCBVa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:30:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6FBC12F4;
        Wed,  2 Mar 2022 13:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CFEDB82259;
        Wed,  2 Mar 2022 21:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E016DC340EF;
        Wed,  2 Mar 2022 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646256610;
        bh=i+i4Wl2tm2Zfc0swWiYdjwD2LtuWtpDfWAxCgUYt0Rg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XsAn1fEsRDcHt4ULGp4CRH/mHTR7OlFlq7dXYH2AHZvF9bMHviuKiWATkHuh31rvh
         V51uLWkd2jnjZP4iAAhN/No0MG20Y6eAilAuvxObY/zI+NQFQn99XM4FgDIuF5WRIh
         81RlTXJi2DIQ2WeizYVmgblXftmcN9d7RcAAZKLn+pOo5OP8xMYiQ9gIEzS3ZpfFz3
         ja7hp0PNTBGFdjrUGv51YzinQV8DEnzsDEoARJG/sRyPb0ahy1cjET13rmjfIFsegH
         X6fA8V+NX3rBL9EfF2lmaCpEdg/aIH0xc16X9/4XwYZA4Fbk+mX4IBTUvT2r2G1RuW
         UiqdlAMX0ZaDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4C16EAC096;
        Wed,  2 Mar 2022 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/2] fixes for bpf_prog_pack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164625661080.14464.1524494677053022306.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 21:30:10 +0000
References: <20220302175126.247459-1-song@kernel.org>
In-Reply-To: <20220302175126.247459-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 2 Mar 2022 09:51:24 -0800 you wrote:
> Changes v1 => v2:
> 1. Rephrase comments in 2/2. (Yonghong)
> 
> Two fixes for bpf_prog_pack.
> 
> Song Liu (2):
>   x86: disable HAVE_ARCH_HUGE_VMALLOC on 32-bit x86
>   bpf, x86: set header->size properly before freeing it
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/2] x86: disable HAVE_ARCH_HUGE_VMALLOC on 32-bit x86
    https://git.kernel.org/bpf/bpf-next/c/eed1fcee556f
  - [v2,bpf-next,2/2] bpf, x86: set header->size properly before freeing it
    https://git.kernel.org/bpf/bpf-next/c/676b2daabaf9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


