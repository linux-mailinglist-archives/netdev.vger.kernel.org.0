Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD6968B938
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjBFKBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjBFKAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:00:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70E4126D1
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21446B80E00
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8E48C433A7;
        Mon,  6 Feb 2023 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675677616;
        bh=7/vdywagOUFq6yi2/yOVr6zsLq4rg2xhe3e0iyrgh3k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YHkFTKYyFzQmb9tASqWhU6m5uj6sR4a/ckyaEdEdynD1kqJtc8kMhVzA2ppIDOlQ6
         pbyTEmtqtNUvq1lvdJYnledqHL6Frp1Sn46EVSbboqaAEYg/YWm4XvOTwKdUfHQXiq
         PlzZFc/ksC9ej3JciAueBH5weHOmbLsEMGWswXf0WumtRxAlocJqbs/JhWuXuLnAgt
         1kq1d/HGoTm3ug/5ZxmFbdr6cOk3Dto+c9SNPVMJL8tLY/cCW2DzlN0V6vjmUTy2qJ
         NZfBgRVeagQP88BgsIKsM09K+uXDJBx6fVy/i5MNZABNDGByOpG+8gbWg/Ec77liV9
         oYGqy1Vs4vwVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89E36E55EFD;
        Mon,  6 Feb 2023 10:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2] net: introduce skb_poison_list and use in
 kfree_skb_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567761656.25195.16301728164675048555.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 10:00:16 +0000
References: <167542916933.1167230.1244118780145312645.stgit@firesoul>
In-Reply-To: <167542916933.1167230.1244118780145312645.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
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

On Fri, 03 Feb 2023 13:59:29 +0100 you wrote:
> First user of skb_poison_list is in kfree_skb_list_reason, to catch bugs
> earlier like introduced in commit eedade12f4cb ("net: kfree_skb_list use
> kmem_cache_free_bulk"). For completeness mentioned bug have been fixed in
> commit f72ff8b81ebc ("net: fix kfree_skb_list use of skb_mark_not_on_list").
> 
> In case of a bug like mentioned commit we would have seen OOPS with:
>  general protection fault, probably for non-canonical address 0xdead000000000870
> And content of one the registers e.g. R13: dead000000000800
> 
> [...]

Here is the summary with links:
  - [net-next,V2] net: introduce skb_poison_list and use in kfree_skb_list
    https://git.kernel.org/netdev/net-next/c/9dde0cd3b10f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


