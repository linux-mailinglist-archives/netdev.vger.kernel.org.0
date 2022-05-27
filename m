Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CBE535896
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 06:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbiE0Esi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 00:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242397AbiE0Esg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 00:48:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613EF47ACD
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 21:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A32F60BD6
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 04:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A285BC34118;
        Fri, 27 May 2022 04:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653626913;
        bh=3hufhEU2WULw7u2UPm2WGlS6SM+3pDpsPeruJ+eNSrg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bpe1Q5a5+pIMNvMRUIUiSnqRg09845HoOc/Pi3s//oIvjszDltuRrkGZh+iYH66Cd
         U3hC/ltqs8OLy+tRft7eItSj8gSuKtPrn/2Cl6rwb8Vpzf6SdcSBu3karc9g5daZwt
         3LPUK4zwtF315Swp311Jgj8+FI2yHnAh9OCvTL0NKGa6knQWh78JGhTth4C/9+6F1/
         iN0dnYi5Dk55hMUXzndV6tPOJm29fj+qthXG++3sFLCoJmLhi7+bpm8F6HfSioL59t
         DJTO/Ae6uGMiV1lZ1vk1WpYdaMRombMV7jw7ckHOyPL4QW579a7M9tR72tYBbpwiwK
         Yl0FZFs58+PzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83E63EAC081;
        Fri, 27 May 2022 04:48:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net: sched: fixed barrier to prevent skbuff sticking
 in qdisc backlog
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165362691353.5864.10388871011458588553.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 04:48:33 +0000
References: <20220526001746.2437669-1-eric.dumazet@gmail.com>
In-Reply-To: <20220526001746.2437669-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, vray@kalrayinc.com
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

This patch was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 May 2022 17:17:46 -0700 you wrote:
> From: Vincent Ray <vray@kalrayinc.com>
> 
> In qdisc_run_begin(), smp_mb__before_atomic() used before test_bit()
> does not provide any ordering guarantee as test_bit() is not an atomic
> operation. This, added to the fact that the spin_trylock() call at
> the beginning of qdisc_run_begin() does not guarantee acquire
> semantics if it does not grab the lock, makes it possible for the
> following statement :
> 
> [...]

Here is the summary with links:
  - [v3,net] net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog
    https://git.kernel.org/bpf/bpf/c/a54ce3703613

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


