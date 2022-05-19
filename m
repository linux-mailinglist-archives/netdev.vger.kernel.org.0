Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6318852CB30
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiESEkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiESEkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ABF5DA45;
        Wed, 18 May 2022 21:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 684F3B8232A;
        Thu, 19 May 2022 04:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F71CC385B8;
        Thu, 19 May 2022 04:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652935213;
        bh=2bfPM7jf63D3vFBeStC68/NjjZm1m70e90SjaOf0eU4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ac9cgyXWhW35D4Yq5ly6f1wKVjYYHMqnkDv5bnclgOM3ZUH5nJRAjDLGe21ow155B
         IhsauMOeCUlorcOB+m0bfm9184I/bbUZEMrow7+1dxHxNnrOqde4ySW/QR4bY3G9O6
         K62dtyrWm3HzkT8NZpawv+6NhxYyvs2h5NyPGhkNsI2qri75U26hzSGcMRrixomrUY
         XTm7ClZ/2hTxFrnGukxJhMmADIWYaloi4o7Z8KPdQDZ9YKuZoA3x1+GrEp0ETizT+v
         HYPWkFLjHur9NiMiX+6A09vtr1cXbQXanuqwKoAe+KOenCHs45jYxhycnkdq9FisZa
         hLCV2Vc/onpeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA8F4E8DBDA;
        Thu, 19 May 2022 04:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: flowtable: fix excessive hw offload
 attempts after failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165293521295.13143.12085724006863239596.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 04:40:12 +0000
References: <20220518213841.359653-2-pablo@netfilter.org>
In-Reply-To: <20220518213841.359653-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 18 May 2022 23:38:35 +0200 you wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> If a flow cannot be offloaded, the code currently repeatedly tries again as
> quickly as possible, which can significantly increase system load.
> Fix this by limiting flow timeout update and hardware offload retry to once
> per second.
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: flowtable: fix excessive hw offload attempts after failure
    https://git.kernel.org/netdev/net/c/396ef64113a8
  - [net,2/7] netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices
    https://git.kernel.org/netdev/net/c/45ca3e61999e
  - [net,3/7] net: fix dev_fill_forward_path with pppoe + bridge
    https://git.kernel.org/netdev/net/c/cf2df74e202d
  - [net,4/7] netfilter: nft_flow_offload: fix offload with pppoe + vlan
    https://git.kernel.org/netdev/net/c/245607493500
  - [net,5/7] netfilter: flowtable: fix TCP flow teardown
    https://git.kernel.org/netdev/net/c/e5eaac2beb54
  - [net,6/7] netfilter: flowtable: move dst_check to packet path
    https://git.kernel.org/netdev/net/c/2738d9d963bd
  - [net,7/7] netfilter: nf_tables: disable expression reduction infra
    https://git.kernel.org/netdev/net/c/9e539c5b6d9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


