Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6875369B2
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355482AbiE1Bag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355541AbiE1BaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67CB132763;
        Fri, 27 May 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CAF0B8266C;
        Sat, 28 May 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AB48C34118;
        Sat, 28 May 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653701413;
        bh=AeiVdeemn2VoJJ5oKgiWG1CbPKXwsJzZe2l4g528u9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dct8lGSPLdpaDdWk6DtcHuXhxMoJqUwfjV8UKn1xc2hkaU2dD1CjGxETTY26WQTRQ
         blLoPR92TdYVuB/AHr675049CjINcT5J4zToboNADaWQJb6/R2RRv7BechpecgMg1e
         ezBB3yBny17xt4rDZ/8wAVipjgOnn5Hse3eYak1byhjvTyfhjpdvit0/LHTVX20y65
         sFi3cGN4geTjn/3ImJGkQ2ZQ4v6jvSENe7XAGVFiiAW5Ui8+xaOd3UKvnRpZZBFQVT
         UuesEQKTLcQRdYaJhZR9Q5E6Fe18YyVpTouc1NFa1E0apqPQjOuVfh2ML79dldcMS9
         QWXv4lBZkWLWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD320F0394D;
        Sat, 28 May 2022 01:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-05-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165370141290.14527.2591249078702010731.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 01:30:12 +0000
References: <20220527235042.8526-1-daniel@iogearbox.net>
In-Reply-To: <20220527235042.8526-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 28 May 2022 01:50:42 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 2 non-merge commits during the last 1 day(s) which contain
> a total of 2 files changed, 6 insertions(+), 10 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-05-28
    https://git.kernel.org/netdev/net/c/6b51935a2651

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


