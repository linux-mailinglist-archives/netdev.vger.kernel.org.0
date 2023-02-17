Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A40869B490
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 22:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjBQVUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 16:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBQVUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 16:20:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D88363BC2;
        Fri, 17 Feb 2023 13:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBF83B82DE4;
        Fri, 17 Feb 2023 21:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DF30C4339B;
        Fri, 17 Feb 2023 21:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676668817;
        bh=SmFvlBCwqfxeA6O1c9SFZ+M5zYGCBj068RSzGRpd+8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h2HezGjNSwsRniBrHO6dWQEjU9KnsviU6gAWoYLbI2k0botsRyGU/RCEko+1O+CUa
         RKqruwD37WqGwDsat4XZo7VwpOfzzKceZ6RhCZb6xwcvPTj3Xr20dFavxihXME6CbL
         HxznyUTbn+qW3Ylau/nvjk9QGK9v75SJs+2Y+N/1p8WG1IHoX+NLKlbaxFhp5zn9Dz
         kpH2/IvUCqx766DuSCUO4SeNvHCjisBC+auyGauCAy+VECrhA/5GWDBfJO+UWlMYMn
         fF7YPNJXT20jKCi5+tZYdylBqiQVk/5pvEJlPHpZ+aXF1j7t7fpkg50AY87GbfiTj6
         wqiTIy4u/EhFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 827E3E21EC1;
        Fri, 17 Feb 2023 21:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for
 bpf_fib_lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167666881752.3071.14569849106230865281.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Feb 2023 21:20:17 +0000
References: <20230217205515.3583372-1-martin.lau@linux.dev>
In-Reply-To: <20230217205515.3583372-1-martin.lau@linux.dev>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, kernel-team@meta.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 17 Feb 2023 12:55:14 -0800 you wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> The bpf_fib_lookup() also looks up the neigh table.
> This was done before bpf_redirect_neigh() was added.
> 
> In the use case that does not manage the neigh table
> and requires bpf_fib_lookup() to lookup a fib to
> decide if it needs to redirect or not, the bpf prog can
> depend only on using bpf_redirect_neigh() to lookup the
> neigh. It also keeps the neigh entries fresh and connected.
> 
> [...]

Here is the summary with links:
  - [v3,bpf-next,1/2] bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for bpf_fib_lookup
    https://git.kernel.org/bpf/bpf-next/c/31de4105f00d
  - [v3,bpf-next,2/2] selftests/bpf: Add bpf_fib_lookup test
    https://git.kernel.org/bpf/bpf-next/c/168de0233586

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


