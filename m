Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6267A4A570E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiBAFuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:50:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50316 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBAFuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D1F5B82D07;
        Tue,  1 Feb 2022 05:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57745C340ED;
        Tue,  1 Feb 2022 05:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643694609;
        bh=pQPHU5fxPMOAOOTaPZAnrF/8lg7d1q5Ch6hn8OyX1iY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KJQb78EvjJ1wJAB5kjtaP6zJ4XJXkV7hG7x4YB9/0hcJ7hsq/Qw6CJCeJoLHMSwn9
         2K213a5lDxKXtYCOqECx5mcRvnnqs+HICUrB90jwsIPqf2UN0FuXmezBIOT3CigqIv
         6UrAml1/mCj1m5d9RsnscQoeWhwWhTZEWND9xjRiENZKXL83P/gcebKlPuiT18YqSF
         X1Ut1Zxx4VyXnVM2jHpetyGXXCh+7xV4VlXR4xmA0wayc51qpskU17e3C3CeGR7sVS
         hsB1dC/FKIYAuwb2+y+4fLmMXtCr51aKZKanLAnVjsXSdo/Z+1HLIS1KNZZIwb2nWY
         g/tcoJOAWIUMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F973E5D08C;
        Tue,  1 Feb 2022 05:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ena: Do not waste napi skb cache
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164369460925.12551.2952215902913305415.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 05:50:09 +0000
References: <YfUAkA9BhyOJRT4B@ip-172-31-19-208.ap-northeast-1.compute.internal>
In-Reply-To: <YfUAkA9BhyOJRT4B@ip-172-31-19-208.ap-northeast-1.compute.internal>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     netdev@vger.kernel.org, jwiedmann.dev@gmail.com,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        ndagan@amazon.com, saeedb@amazon.com, davem@davemloft.net,
        daniel@iogearbox.net, sameehj@amazon.com, weiyongjun1@huawei.com,
        lorenzo@kernel.org, linux-kernel@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 29 Jan 2022 08:53:36 +0000 you wrote:
> By profiling, discovered that ena device driver allocates skb by
> build_skb() and frees by napi_skb_cache_put(). Because the driver
> does not use napi skb cache in allocation path, napi skb cache is
> periodically filled and flushed. This is waste of napi skb cache.
> 
> As ena_alloc_skb() is called only in napi, Use napi_build_skb()
> and napi_alloc_skb() when allocating skb.
> 
> [...]

Here is the summary with links:
  - [v2] net: ena: Do not waste napi skb cache
    https://git.kernel.org/netdev/net-next/c/7354a426e063

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


