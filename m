Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9C3655422
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 21:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiLWUKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 15:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiLWUKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 15:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3C622287
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 12:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20058B82141
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 20:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3147C433F0;
        Fri, 23 Dec 2022 20:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671826216;
        bh=pEmD2xhG4Ul2FY//aJRAYsIlQ5xv/kKB7yNiXxeuobY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=amLF8nYOSg9I7haAVKY04iZL3cOlFGFFJC2412VJlIYJLseY0ctAIloQzhjvH+S5u
         hMgLy4nPiIIS235DVPST3DU+/+pXPCZ+aSdPmwQKT8t2miU1h11Ls5f8lmxEvjjRrz
         lQl7ZpW8nPemNU6o8Ll490oNIZwFw144gwknOqwFMgy8wPYw3yz8vfvGTqbPkasbES
         YSwIKHkuX7iltq8+QDNN0VrirWwCDlhWJ9DDvwOsCH+AbT1vu9ewk6nva2rTXNktFQ
         ATFHrs2GG2MgDZBB/pu/75YL3rR53UrvZsc1ny87XR/bjojaP8Ecs0+ICKM5yA7CQm
         Bzp60dMICmlGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9163C395E0;
        Fri, 23 Dec 2022 20:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net: hns3: fix some bug for hns3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167182621668.5438.15923384969286109014.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Dec 2022 20:10:16 +0000
References: <20221222064343.61537-1-lanhao@huawei.com>
In-Reply-To: <20221222064343.61537-1-lanhao@huawei.com>
To:     Hao Lan <lanhao@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, huangguangbin2@huawei.com,
        wangjie125@huawei.com, shenjian15@huawei.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Dec 2022 14:43:40 +0800 you wrote:
> There are some bugfixes for the HNS3 ethernet driver. patch#1 fix miss
> checking for rx packet. patch#2 fixes VF promisc mode not update
> when mac table full bug, and patch#3 fixes a nterrupts not
> initialization in VF FLR bug.
> 
> Jian Shen (2):
>   net: hns3: fix miss L3E checking for rx packet
>   net: hns3: fix VF promisc mode not update when mac table full
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: hns3: add interrupts re-initialization while doing VF FLR
    https://git.kernel.org/netdev/net/c/09e6b30eeb25
  - [net,2/3] net: hns3: fix miss L3E checking for rx packet
    https://git.kernel.org/netdev/net/c/7d89b53cea1a
  - [net,3/3] net: hns3: fix VF promisc mode not update when mac table full
    https://git.kernel.org/netdev/net/c/8ee57c7b8406

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


