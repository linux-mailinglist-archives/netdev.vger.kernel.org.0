Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B79E597DE9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242996AbiHRFKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243309AbiHRFKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:10:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB81AB1A2;
        Wed, 17 Aug 2022 22:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2506BB81FFF;
        Thu, 18 Aug 2022 05:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B338FC433B5;
        Thu, 18 Aug 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660799420;
        bh=4ae3i0q5b5HwJXNLQUUBhZ5ijQQtlV0e8gvuMz1tkNk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W36wGlzWU+L7zl9YKmEyIm7udqKJ+HLMLtFMcmd714sOMT9yrFeeIOOLTnbABEWz3
         JeaJ6XIRtP9hR5TWx9GzGZboxpstfvi2M7hpheJ62F6JB/WIH5c83Tr8LmcN1klYlF
         XoVK9HU/iZr14enubPCcitBukFcU/l4VERn1ejlOy3MM8NQK4bX6rn+w6P3gIzzGfa
         mW0Yh7RnzkOOPOmqdi+Xiorlb/xKDd6Tu+TvvaKUPTCiXK3OK9Jy+QKpGR3/RGAwml
         9t6IyHB6bXRU+i+6vk/dqZrAuT0MuiNKj1kV9oYno5r9nEE0MebHdF4MZkwPJrbjmC
         mWuNm9mr7v8zA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97C27E2A04D;
        Thu, 18 Aug 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-08-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166079942061.2023.10562666009950418218.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 05:10:20 +0000
References: <20220817215656.1180215-1-andrii@kernel.org>
In-Reply-To: <20220817215656.1180215-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
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

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 14:56:56 -0700 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 45 non-merge commits during the last 14 day(s) which contain
> a total of 61 files changed, 986 insertions(+), 372 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-08-17
    https://git.kernel.org/netdev/net-next/c/3f5f728a7296

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


