Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FCE687220
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjBBAAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjBBAAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77A54CE65;
        Wed,  1 Feb 2023 16:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A09DD61994;
        Thu,  2 Feb 2023 00:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A948C4339B;
        Thu,  2 Feb 2023 00:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675296019;
        bh=oNgquPxvzarAxvamPYZk3VyyfX1RbWV59kRUH7Lpp50=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OuyAWwYtNcB4eNLzqvf+Bsznnf3L0oIEecwgoNGj0QfyGNpdnE2/ctgj2rZxW/Wpr
         TZZHmXUdwsS46gzrIPNuwmjNi4QurExHPIYlk3Wy1rtt+8iolcxkAZFxdbJ+EWUzuP
         OhEQT/M6YPyoHh5ma+0T17JtvPTAGNd+/2fbZglDtLTgWX54wqsZUOhKHMVqv5Qk0V
         A8TrbqLBwgZFaUcs9gcoT8xJCSWC8OY37x6opFdcL3XXtwY3Pbia3sW/NWewUKzxj8
         4hTbn6N86GTgLT+Vl9zxk7a1plYk7YRx8rZpB0GxTKnmobJ7GbnzCpPO8YtybU08Lp
         /F7J+oXgFNdnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9C7BC4314C;
        Thu,  2 Feb 2023 00:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next V2 0/4] selftests/bpf: xdp_hw_metadata fixes series
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167529601888.4665.18238879247975199342.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 00:00:18 +0000
References: <167527267453.937063.6000918625343592629.stgit@firesoul>
In-Reply-To: <167527267453.937063.6000918625343592629.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, sdf@google.com, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 01 Feb 2023 18:31:45 +0100 you wrote:
> This series contains a number of small fixes to the BPF selftest
> xdp_hw_metadata that I've run into when using it for testing XDP
> hardware hints on different NIC hardware.
> 
> Fixes: 297a3f124155 ("selftests/bpf: Simple program to dump XDP RX metadata")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next,V2,1/4] selftests/bpf: xdp_hw_metadata clear metadata when -EOPNOTSUPP
    https://git.kernel.org/bpf/bpf-next/c/3fd9dcd689a5
  - [bpf-next,V2,2/4] selftests/bpf: xdp_hw_metadata cleanup cause segfault
    https://git.kernel.org/bpf/bpf-next/c/a19a62e56478
  - [bpf-next,V2,3/4] selftests/bpf: xdp_hw_metadata correct status value in error(3)
    https://git.kernel.org/bpf/bpf-next/c/7bd4224deecd
  - [bpf-next,V2,4/4] selftests/bpf: xdp_hw_metadata use strncpy for ifname
    https://git.kernel.org/bpf/bpf-next/c/e8a3c8bd6870

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


