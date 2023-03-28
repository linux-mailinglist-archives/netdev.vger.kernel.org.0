Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4376CC0E7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjC1NbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbjC1NbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:31:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E45CC0C;
        Tue, 28 Mar 2023 06:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B782617C1;
        Tue, 28 Mar 2023 13:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6ACEC4339E;
        Tue, 28 Mar 2023 13:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680010218;
        bh=e+sEc22DlWRxqg+rsXUSntwCJEqVWE0Lzu3VVQAVOlE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JxUuyTD6iz2hgt6jWbY8X6dfypCFSKDuEv1BeBG7fatdm6LYXEziWvSEXEA22zuLt
         l1NnqeHVoI0DdXmlem7pU6Ale7Q65MvIQy4QbFd9XTaUfli4N/69HOF8eJkEByfy8c
         jzFws96gci0OWwa+tUEpWlMWfDIjVOACkZcTy6O1G5EyHKeJghlMlJE4G/CMhjy3C8
         q6HPgyOKI+O6CPSlXICgC+nF08nvLYHpyc6WACXSXatNGqCP3oZJDXu9/5iXLMDG2w
         r/cmnZ8gfgoUpkf/G/1QGejWmr/dcx2ErsiTBArxc8F3CR4SPUubvtacWj/4OZ3Eg6
         a9KHQvnw++WQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B33B6E4D01A;
        Tue, 28 Mar 2023 13:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] xen/netback: fix issue introduced recently
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168001021872.12098.12374211537916209882.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 13:30:18 +0000
References: <20230327083646.18690-1-jgross@suse.com>
In-Reply-To: <20230327083646.18690-1-jgross@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 27 Mar 2023 10:36:44 +0200 you wrote:
> The fix for XSA-423 introduced a bug which resulted in loss of network
> connection in some configurations.
> 
> The first patch is fixing the issue, while the second one is removing
> a test which isn't needed.
> 
> Juergen Gross (2):
>   xen/netback: don't do grant copy across page boundary
>   xen/netback: remove not needed test in xenvif_tx_build_gops()
> 
> [...]

Here is the summary with links:
  - [1/2] xen/netback: don't do grant copy across page boundary
    https://git.kernel.org/netdev/net/c/05310f31ca74
  - [2/2] xen/netback: remove not needed test in xenvif_tx_build_gops()
    https://git.kernel.org/netdev/net/c/8fb8ebf94877

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


