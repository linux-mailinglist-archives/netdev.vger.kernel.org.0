Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8251596C10
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiHQJaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbiHQJaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AEB5A824;
        Wed, 17 Aug 2022 02:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3434BB81CC4;
        Wed, 17 Aug 2022 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAD81C433D6;
        Wed, 17 Aug 2022 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660728616;
        bh=B8VS54tKLrX3stD3bhnn4TqGV1Wdcx7AoiIZAovz54Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bAxkFF4RhDKXBryJgVqsIEtQiMzJtlD94PmEUtk1h3zeYzb8x35hfrOxKJvgub6xq
         IH8JiYq6838q259e/QXtrp6ghL5QXAxuOCXTEehtltFJtBsWEvl3NxlF6YaAByHfcm
         BrhnD20pfgoORLQ8RvTVQC0iYmdd9M/LsiRDNJvrHPQ4nOHyg2X8Ex6jdNvh97AzPc
         +HNWWLsqivh45u6R0tXf0wtesnWdrVy43ggF7Aqh30m+XmN0J4IoqGXbxItHWrdurF
         v09Tn38u2Y/2tFxZAbYgnLcNfE3GR7HCB/dtz5czhzxPnASb2VAqX4QkKv5T/drj81
         Rm9wvWJQ5Df+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7015E2A051;
        Wed, 17 Aug 2022 09:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: Make SYN ACK RTO tunable by BPF programs with
 TFO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166072861667.2597.15088483757225170077.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 09:30:16 +0000
References: <20220815202900.3961097-1-jmeng@fb.com>
In-Reply-To: <20220815202900.3961097-1-jmeng@fb.com>
To:     Jie Meng <jmeng@fb.com>
Cc:     netdev@vger.kernel.org, kafai@fb.com, kuba@kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Aug 2022 13:29:00 -0700 you wrote:
> Instead of the hardcoded TCP_TIMEOUT_INIT, this diff calls tcp_timeout_init
> to initiate req->timeout like the non TFO SYN ACK case.
> 
> Tested using the following packetdrill script, on a host with a BPF
> program that sets the initial connect timeout to 10ms.
> 
> `../../common/defaults.sh`
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: Make SYN ACK RTO tunable by BPF programs with TFO
    https://git.kernel.org/netdev/net-next/c/8ea731d4c2ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


