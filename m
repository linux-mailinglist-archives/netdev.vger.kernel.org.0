Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06302610070
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiJ0Sk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbiJ0SkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:40:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B92419BB
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E749B82764
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 000D8C43470;
        Thu, 27 Oct 2022 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666896018;
        bh=FR51L+VVgPOCFC1/vvnFi5R/DhQ+aJ1PuH4+LwfKAXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=orLoucXEz+plaPIChJmGstQyKTV45YNmgfEESamNsuJFUA5tVw3CQTDgEQdhoIBV3
         7qFXbBgI7wddJ8PZMJfqrk8d2N3H82c83qDpkR9T4bvD2hgXpgEkJF0fjriQeyLE8j
         jdiWimqAobImUaT2APE81nX6sTdqiD6kvmD5cRxshFWA36iU1Myoi7aD+tC4AL5WVU
         9Y/wHH1B5XynoAQjfPRDwMdKrgcIiHQkSdO18+dVaV47dJJ/l2kvc86beVkLhliC0W
         oL4XAuUzXwqvQyQBnEXREAmKrq7fryafSncSjRTQJ9rje2oh1DQviyOVon4e2Xw250
         CacHgUERLvyVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7C05E451B0;
        Thu, 27 Oct 2022 18:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: do not sense pfmemalloc status in
 skb_append_pagefrags()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689601787.10145.8906084901769694533.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 18:40:17 +0000
References: <20221027040346.1104204-1-edumazet@google.com>
In-Reply-To: <20221027040346.1104204-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 04:03:46 +0000 you wrote:
> skb_append_pagefrags() is used by af_unix and udp sendpage()
> implementation so far.
> 
> In commit 326140063946 ("tcp: TX zerocopy should not sense
> pfmemalloc status") we explained why we should not sense
> pfmemalloc status for pages owned by user space.
> 
> [...]

Here is the summary with links:
  - [net] net: do not sense pfmemalloc status in skb_append_pagefrags()
    https://git.kernel.org/netdev/net/c/228ebc41dfab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


