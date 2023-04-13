Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7F06E135F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjDMRUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDMRUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ED67EE8
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9348164070
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD531C433D2;
        Thu, 13 Apr 2023 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681406417;
        bh=F6bc+Tug3Le6T5+g6Mkydf9DLHU0Ke6M6oiJpiBEEK4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zf4gYOS0L8gJbaCcjHhmq4krfhBfoOlOT6phc+mSFUUK2Q+BpssW/aBLeg0I1aBdC
         7Me84a/XPfPEvrSvLkzUslzhMCLazN+M6b6mAEBoBYlYkIGOX9fVYVhkilZe6IzLT6
         Xd2AA/VoUFc9VP0ebL4ybqEo0b48qiK6gixTCDZa2z9s6VEPQ6eUUhOS6RhjbQvl9F
         0IKljVTIeFSwp5lVD4iM9DN09qzFoCR/aDnll7uDqS6L0+K3ZkI7iGaLwwvzikc+gG
         n3f7MosxjHGOLRd2C0gw4O7fn1e2XuNe4rk316P7mk33hbLgAtb+anlhuw1zfaFwfB
         lWyulfKQ3bAxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2315E4508E;
        Thu, 13 Apr 2023 17:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] skbuff: Fix a race between coalescing and releasing SKBs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168140641766.8255.16126059065302939262.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 17:20:17 +0000
References: <20230413090353.14448-1-liangchen.linux@gmail.com>
In-Reply-To: <20230413090353.14448-1-liangchen.linux@gmail.com>
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     kuba@kernel.org, ilias.apalodimas@linaro.org, edumazet@google.com,
        hawk@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, alexander.duyck@gmail.com,
        linyunsheng@huawei.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 13 Apr 2023 17:03:53 +0800 you wrote:
> Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
> recycling") allowed coalescing to proceed with non page pool page and page
> pool page when @from is cloned, i.e.
> 
> to->pp_recycle    --> false
> from->pp_recycle  --> true
> skb_cloned(from)  --> true
> 
> [...]

Here is the summary with links:
  - [v5] skbuff: Fix a race between coalescing and releasing SKBs
    https://git.kernel.org/netdev/net/c/0646dc31ca88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


