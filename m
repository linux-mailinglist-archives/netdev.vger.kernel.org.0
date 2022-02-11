Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A684B1CD5
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 04:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiBKDKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 22:10:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiBKDKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 22:10:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B71B33;
        Thu, 10 Feb 2022 19:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40B87B8280E;
        Fri, 11 Feb 2022 03:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF27CC340EE;
        Fri, 11 Feb 2022 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644549008;
        bh=Rg+pjK0yDI3M8/jncgu9eoCMS85mL4Na0m2TWJzrGu4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V6B+9G1yehOYDNw9ZlpFoILbiSo1rCDCPSHAyzT6eWA2QYH11FQU7sdTh80nVJVB7
         rbK9ndo1UeQnUuHyc5tLiAshJ/BzeZgM2dxDurp/D65TinNT0gnSuB7FwTCU0L7F1S
         BNj8cFhAVc+KsHQTHW67132tOb15fCuVF0wZRDTSHsnolY+QYr/G5SzorrX5Vgl6cS
         X23zN8uXneFYP7ojrOjZNEu57iebJeArlCEgLzkC8ikq7DzaCXGhKkKW557KIiQ0NT
         tEKC7/gV81WFyDDhnmtmUdRuedNeSP4Gg/5uZ1PTAI4lwLTCHieci3xIVq7hiFrhF3
         2ZnA95DNo3L+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C505BE6D447;
        Fri, 11 Feb 2022 03:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] bpf: fix bpf_prog_pack build for ppc64_defconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164454900880.19736.1427816578859377756.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 03:10:08 +0000
References: <20220211024939.2962537-1-song@kernel.org>
In-Reply-To: <20220211024939.2962537-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com,
        sfr@canb.auug.org.au
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

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 10 Feb 2022 18:49:39 -0800 you wrote:
> bpf_prog_pack causes build error with powerpc ppc64_defconfig:
> 
> kernel/bpf/core.c:830:23: error: variably modified 'bitmap' at file scope
>   830 |         unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>       |                       ^~~~~~
> 
> This is because the marco expands as:
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] bpf: fix bpf_prog_pack build for ppc64_defconfig
    https://git.kernel.org/bpf/bpf-next/c/4cc0991abd39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


