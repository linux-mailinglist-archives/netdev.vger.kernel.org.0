Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2CD590E73
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 11:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238117AbiHLJuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 05:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237014AbiHLJuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 05:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AD4101B;
        Fri, 12 Aug 2022 02:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF1A5B82388;
        Fri, 12 Aug 2022 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C8E5C433B5;
        Fri, 12 Aug 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660297814;
        bh=4xmUSnWbtlwB4j/CmfyVfPxefCxcgIliLxGjbbC9WA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SnZFMbrP2+obQZ/4KepTrPK5lj+TaRoQ4ZIrTiNX6BBg4lqgrbrTdOOruJLINwX0w
         blO9xgwRqR16D6wS4xLsNohlIlUsRcLMMe04LpzwlTNIpWcHiKj9rtCFp4i76xUGtB
         jXOPkpmX+TqceXx0hBP/WA2QAi8odF6AeP4V62wlDhGNCVZr2jchvBUZsjbxNDPPHP
         qgDNYg3NYGGrrUhKdsoKqHTUPj/N79COQLn5LXsof/svjn4qZiWNupsw49ZBPvOp7o
         vPtJTcz02/XQ8GDxccj7ZDopRqqR7YteQOqqafg99995pG9nCEOvNygAvrqbj9bmlz
         csKfNb0PrjDnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63C0AC43142;
        Fri, 12 Aug 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rds: add missing barrier to release_refill
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166029781440.21057.2862076834998387336.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Aug 2022 09:50:14 +0000
References: <alpine.LRH.2.02.2208100858130.19047@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2208100858130.19047@file01.intranet.prod.int.rdu2.redhat.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 Aug 2022 09:00:42 -0400 (EDT) you wrote:
> The functions clear_bit and set_bit do not imply a memory barrier, thus it
> may be possible that the waitqueue_active function (which does not take
> any locks) is moved before clear_bit and it could miss a wakeup event.
> 
> Fix this bug by adding a memory barrier after clear_bit.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Here is the summary with links:
  - rds: add missing barrier to release_refill
    https://git.kernel.org/netdev/net/c/9f414eb409da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


