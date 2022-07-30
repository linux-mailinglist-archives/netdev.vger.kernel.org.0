Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D871058580C
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 04:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbiG3CkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 22:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiG3CkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 22:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7A9E022;
        Fri, 29 Jul 2022 19:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A19B82927;
        Sat, 30 Jul 2022 02:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE971C433D6;
        Sat, 30 Jul 2022 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659148814;
        bh=dnQIMGsMIRGkHbMR9DlZwpffn+poUHwnXcvB4Nn5NH0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GWj+nHMn2mahRxmqTpFuCBRYVUu8YnOzauHelGUHV3jGFF7wbKU4FWkvvAqIVaDKw
         mF8Jk6OjqDFb06LKbU3XK2EtZz2QQF6MwHZVCSGo5hHYwhs3WSlgDZ3FAe2FVGzEl9
         M6FHJSBNscs1meSp6DVDlzzSCvm8sjr7ckBjWI5p1D/yfjZbMrFoRb/v2528w6Tx25
         sm8DOY7ksNf+SL4fGVtqmzxPN64H+O1Qpz/iseFiO+vrl9VH4fdbOyWMd7WIGuHayH
         A6ZUInDI8Ejp+7WQQm7Oeasz6ossKQnMUmgH9f8BR2fV0Fsv7VYjrAM6Cee8elXiXb
         VzHsY/ydnV+Dg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8933C43143;
        Sat, 30 Jul 2022 02:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-07-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165914881481.11123.5407560688953471121.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jul 2022 02:40:14 +0000
References: <20220729230948.1313527-1-andrii@kernel.org>
In-Reply-To: <20220729230948.1313527-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Jul 2022 16:09:48 -0700 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 22 non-merge commits during the last 4 day(s) which contain
> a total of 27 files changed, 763 insertions(+), 120 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-07-29
    https://git.kernel.org/netdev/net-next/c/5fc7c5887c62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


