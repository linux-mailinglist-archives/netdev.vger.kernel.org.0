Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5574D6A06
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiCKWxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiCKWx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:53:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C7C2A2D29;
        Fri, 11 Mar 2022 14:27:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98AB260EDF;
        Fri, 11 Mar 2022 21:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 027D9C340EC;
        Fri, 11 Mar 2022 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647033010;
        bh=61Xxy7fRTLYTj8A4CEx5xGaKDEr6+LlKepnbpX8kW6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XpuvEQPzr1Kpt4+5y5kRPQIrB53DysoCiJ3AcwECWPWSJ1k10xSltMRQbBjvJfmeu
         aKuHhuQBEzfWzDz3cOl2TRAuj5aMrf7A7P9Zg1eZIU1wK5Glfd0pq49nOj8o7TKp3w
         QwYaBvGLt1d+YbEPnholsFk/oaviazdFWndlFAhMkjyL3swaYsnX7H2s8Ov4MC+7RE
         ZlLUxS3injPFQwOF9zWx0vtkhJKerCVefa+K5xTgieFMRvsGXbeB3TN+dYwFz25t0E
         EoNoW8jrgcALafo0fKpGq/ErKBCn7G+NVj84A6edWHfrdcl6cNJrA1HtgEjh03kcI9
         g1NzaKEgig3Ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAEA6E8DD5B;
        Fri, 11 Mar 2022 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 1/2] bpf,
 test_run: Fix packet size check for live packet mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164703300989.26095.18212474165043880639.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 21:10:09 +0000
References: <20220310225621.53374-1-toke@redhat.com>
In-Reply-To: <20220310225621.53374-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org,
        syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 10 Mar 2022 23:56:20 +0100 you wrote:
> The live packet mode uses some extra space at the start of each page to
> cache data structures so they don't have to be rebuilt at every repetition.
> This space wasn't correctly accounted for in the size checking of the
> arguments supplied to userspace. In addition, the definition of the frame
> size should include the size of the skb_shared_info (as there is other
> logic that subtracts the size of this).
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf, test_run: Fix packet size check for live packet mode
    https://git.kernel.org/bpf/bpf-next/c/b6f1f780b393
  - [bpf-next,2/2] selftests/bpf: Add a test for maximum packet size in xdp_do_redirect
    https://git.kernel.org/bpf/bpf-next/c/c09df4bd3a91

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


