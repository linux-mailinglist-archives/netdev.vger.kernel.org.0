Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7252B65098A
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 10:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiLSJuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 04:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiLSJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 04:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA89D2E8
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 01:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9211EB80D3D
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A1CAC433F0;
        Mon, 19 Dec 2022 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671443416;
        bh=UsIgkDsssTu9kwSktrdzcCL5+559GttZBbuEJMkdAxY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q0I3Hc6/fs8Lx34vv4Krt+6jXHylvsFj+dJY369U4xDD/03SyUYAAAvYZIzWm+ejX
         HRFCVsiCr4gOHEccZ5hkgWu2urUSjsy/Xl0mlaPU0ILygR5zZxKCqpF3NEewBCi3Bp
         iyWMBTbDnMW/zqMcfMF1RBNe1DzWgC1hf6dnKh5pq5FcnvICqTkah2ARnRVIsy2DOE
         5FEbw66olszFqK5+h0DI0xsuj9t4Ihq7f8yvHynn2cDo06ILAyGAVkvje34nivERQV
         yQ4zOTs/rtq4v1Ndxep/M6yZr8t1NrlypIAYOzaSwrlQgJcpYjgwUcFOFVqJVqFDuY
         jSZiYVDo/kIZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E401E29F4C;
        Mon, 19 Dec 2022 09:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net] net_sched: reject TCF_EM_SIMPLE case for complex ematch
 module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167144341611.12312.13266065822266257610.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 09:50:16 +0000
References: <20221217221707.46010-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20221217221707.46010-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com,
        jun.nie@linaro.org, jhs@mojatatu.com, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 17 Dec 2022 14:17:07 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> When TCF_EM_SIMPLE was introduced, it is supposed to be convenient
> for ematch implementation:
> 
> https://lore.kernel.org/all/20050105110048.GO26856@postel.suug.ch/
> 
> [...]

Here is the summary with links:
  - [net] net_sched: reject TCF_EM_SIMPLE case for complex ematch module
    https://git.kernel.org/netdev/net/c/9cd3fd2054c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


