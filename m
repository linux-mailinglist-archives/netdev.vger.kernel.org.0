Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2BD5756AE
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiGNVAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 17:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGNVAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 17:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1716C109;
        Thu, 14 Jul 2022 14:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABCBA61A46;
        Thu, 14 Jul 2022 21:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07BD7C34115;
        Thu, 14 Jul 2022 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657832413;
        bh=dND1VBu3o/295ifQKIWvv78xvo1DIs2Aw01upfwFQ7w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dfuZ+Tulzl8Cmq5pqXlcizO9g67r12orLOfU8GKC3bzb3TTmHTx8DDVfQldO0Xn4b
         EDMW3LRMy4sgdc9IX0BxSBXOHnGPVY6tY0kkyunvoCxJIBOh+tCUeQDgp1sImfcAnB
         qR5cd6uMJqkGNuKsLtl5LXtxdwFRJtdUUiwn6q5KpOFf9K1KrUiN/djuYVRM8pC80e
         g2qMpl3A2FjdXx2pRVpwJx/w/s9VM7o2tnrM5hYuMb/CmbBHGGpjn1M9H2dtuJsuAi
         sheA83VVONlzJvUj7kdGfdSF36vI3rZ7bPjHXDdWEWfdONce6xDp3XxJCyvYNMWxyf
         ud7QhhCSM+waQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DEA1DE45227;
        Thu, 14 Jul 2022 21:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v4] bpf: Warn on non-preallocated case for
 BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165783241290.23397.11784407850612704539.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 21:00:12 +0000
References: <20220713160936.57488-1-laoar.shao@gmail.com>
In-Reply-To: <20220713160936.57488-1-laoar.shao@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 13 Jul 2022 16:09:36 +0000 you wrote:
> BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE is also tracing type, which may
> cause unexpected memory allocation if we set BPF_F_NO_PREALLOC.
> Let's also warn on it.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> 
> 
> [...]

Here is the summary with links:
  - [bpf-next,v4] bpf: Warn on non-preallocated case for BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE
    https://git.kernel.org/bpf/bpf-next/c/5002615a37b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


