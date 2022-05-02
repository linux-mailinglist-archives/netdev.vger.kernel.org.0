Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2226516C7C
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383893AbiEBIxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352476AbiEBIxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:53:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9273D9A;
        Mon,  2 May 2022 01:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62748CE18D7;
        Mon,  2 May 2022 08:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A021C385AF;
        Mon,  2 May 2022 08:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651481411;
        bh=Xs/LFJlSGdNTmYB7nGkFdEiMFaXvAQWudWEdieeb5Xs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fdc/x63vU7sMWfsvyJyC6xIqBJYWcLpgZw4Tn7z+UPqoxMSBBtRWggZrSVH5FI0n4
         U0VI0v5vsB4wk07BfT8aPfQkgK8S0puOMtP5fuWlKgzQk/+Ijpp2aejpDykmp3JuAK
         XAtKRAkYfkzdg0vvZsej6g1VIx7rLoHqeDvdaCTOwrIwKXu0ZgLu0U7IoHqVD3JK7t
         aUSUnRjubiGvEheOPmIXrvKPaw4eIUGpi64wncwV25dxEKbhEcGzTGkhRntbBkVsvm
         gXhsWJ/TWvI+t/H4uaSsFqRozMxoczlDn4i41wlqPRF0pyHLcw/1J0lupZLq/iTNmr
         Lf5SNPq/9s+tA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D5EAF0383D;
        Mon,  2 May 2022 08:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] ip_gre,
 ip6_gre: Make [IP6]GRE[TAP] devices always NETIF_F_LLTX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165148141150.15603.6013828424005630453.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 08:50:11 +0000
References: <cover.1651207788.git.peilin.ye@bytedance.com>
In-Reply-To: <cover.1651207788.git.peilin.ye@bytedance.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, eric.dumazet@gmail.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        peilin.ye@bytedance.com, u9012063@gmail.com,
        cong.wang@bytedance.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 28 Apr 2022 22:24:17 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> v1: https://lore.kernel.org/netdev/cover.1650580763.git.peilin.ye@bytedance.com/
> 
> change since v1:
>   - deleted "depends on patch..." in [1/2]'s commit message
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] ip_gre: Make GRE and GRETAP devices always NETIF_F_LLTX
    https://git.kernel.org/netdev/net-next/c/020e8f60aa8b
  - [v2,net-next,2/2] ip6_gre: Make IP6GRE and IP6GRETAP devices always NETIF_F_LLTX
    https://git.kernel.org/netdev/net-next/c/b11ebf2ca2c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


