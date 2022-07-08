Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F9856C370
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbiGHXKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiGHXKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98C63F33E;
        Fri,  8 Jul 2022 16:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76874622A2;
        Fri,  8 Jul 2022 23:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C109CC341C7;
        Fri,  8 Jul 2022 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657321813;
        bh=LZtnCM0f0jpHeCff8j2WnOJVIdYDUiM2+msLec9AK3w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FHSvParJZpraceVFAoLBJGCrTE+s1804Zy0TUGuI/7FbQojwAtrY/PT9jUHSSKm/1
         zlkcKXWYtp9EkkCL8aPMaox09XerOb3aLutMv0nNueRvCSfrpsQ5mTkNWyUhYqLAov
         uYTf5hCSf295YemNjNqIqTDV/ilIoOr87agZfTG89e+2cDdJXBclWLZQCnuO+qgdA1
         Hqb0t8n3QKRsFYHgoptPdujxqa79SOhbjbsLTgUYzOB7y+PkbVq3Ln84WLwyrVbHMR
         W/Ha2tZ3IyT9tBH7UZc8adgNWdkOyQdpufwo60m8wcpwrE6U1qBNQvFSjRVrDkDkd6
         Rzc7JPJ6PwDRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A29DDE45BDD;
        Fri,  8 Jul 2022 23:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selftests/bpf: Fix xdp_synproxy build failure if
 CONFIG_NF_CONNTRACK=m/n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165732181366.25817.230995247723238716.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 23:10:13 +0000
References: <20220708130319.1016294-1-maximmi@nvidia.com>
In-Reply-To: <20220708130319.1016294-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ykaliuta@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
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
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 8 Jul 2022 16:03:19 +0300 you wrote:
> When CONFIG_NF_CONNTRACK=m, struct bpf_ct_opts and enum member
> BPF_F_CURRENT_NETNS are not exposed. This commit allows building the
> xdp_synproxy selftest in such cases. Note that nf_conntrack must be
> loaded before running the test if it's compiled as a module.
> 
> This commit also allows this selftest to be successfully compiled when
> CONFIG_NF_CONNTRACK is disabled.
> 
> [...]

Here is the summary with links:
  - [bpf] selftests/bpf: Fix xdp_synproxy build failure if CONFIG_NF_CONNTRACK=m/n
    https://git.kernel.org/bpf/bpf-next/c/24bdfdd2ec34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


