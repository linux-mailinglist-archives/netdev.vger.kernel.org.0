Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F59569C6AB
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBTIad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjBTIab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:30:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDE413D4F;
        Mon, 20 Feb 2023 00:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E43960D2E;
        Mon, 20 Feb 2023 08:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D05DC433AC;
        Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676881818;
        bh=e01YI7N/r3s0VwjNHm/P6Ffry1BI3ltR4Mc2KzhnFic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rymWW9kh+z/ZUIL0WWKYna6DfZGesnqJ2vPPZDteHdxO1sGm6PZ11Ui5GqB5tgnRI
         VqzcAAdx7L653gT+ALXO2Ieh5ubtZ9kvmZ0WJoty4GvQ3DT/w0S6l7XPQOR3riMGHZ
         L9tZl4OrTzA33+73Hji6jtKUlpwWXya4+iK/FB/ah1LL4FcN0xBlGoZJ0zcJhT7rhv
         pmhn/kw1nf3TblB+Kzgx5Vx+R4BXP7xelWQFBydBVDYQEAetR7r2ENNedKSPYCTGkj
         oT19GacAL4n7TU48ayNipH3ZJ0kk2d3qcnys0aLBXZKRlHyRVOzc+6zNWBqddCLWEz
         oqVgGzH9RbuhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7531FE68D20;
        Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] xsk: support use vaddr as ring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688181847.23180.1453814070713890770.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 08:30:18 +0000
References: <20230216083047.93525-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230216083047.93525-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Feb 2023 16:30:47 +0800 you wrote:
> When we try to start AF_XDP on some machines with long running time, due
> to the machine's memory fragmentation problem, there is no sufficient
> contiguous physical memory that will cause the start failure.
> 
> If the size of the queue is 8 * 1024, then the size of the desc[] is
> 8 * 1024 * 8 = 16 * PAGE, but we also add struct xdp_ring size, so it is
> 16page+. This is necessary to apply for a 4-order memory. If there are a
> lot of queues, it is difficult to these machine with long running time.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] xsk: support use vaddr as ring
    https://git.kernel.org/netdev/net-next/c/9f78bf330a66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


