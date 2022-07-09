Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB31156C63F
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiGIDUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiGIDU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:20:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EDF66B84
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27DB2B82A1D
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A454BC341C0;
        Sat,  9 Jul 2022 03:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657336813;
        bh=oauOv3MeyRe4k/3gdp5W8Zl5lQAw1rQyIVWOdtJTnSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hXeDfo8ZzdYxxAXuK6CximgQUlvjj7qIWFAslHqGxGsDjr4bCJZbg/YdCcS+Iq6Se
         4/Y7X4T/YTEVFX3dVad0oi7ELlNh/2SWcs5rVRi+8GVJzrLoE07KrfFtLQqGy04oyC
         ZLgo4tDpDEv1XOrxNNG1TYLzyfUmjdFiscJbXiD3I3KLffr9iV01FimDqO0DdggDX9
         zCGOnzf/vH0oYtQ5Bl38cOxYLdXvoTMtgC4v1WQga3h2mohoBZve5hwZFbJY4j12mN
         n8FlWx5+Ymqhmq1JHtAVt9SceWLv+b0W+gH4ao1MknFhhl/u4ervJz7i0Pp54DbTHI
         QZd7huwEVmCzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89639E45BDB;
        Sat,  9 Jul 2022 03:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] Documentation: add a description for
 net.core.high_order_alloc_disable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165733681355.2987.14809070979721350364.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 03:20:13 +0000
References: <20220707080245.180525-1-atenart@kernel.org>
In-Reply-To: <20220707080245.180525-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Jul 2022 10:02:45 +0200 you wrote:
> A description is missing for the net.core.high_order_alloc_disable
> option in admin-guide/sysctl/net.rst ; add it. The above sysctl option
> was introduced by commit ce27ec60648d ("net: add high_order_alloc_disable
> sysctl/static key").
> 
> Thanks to Eric for running again the benchmark cited in the above
> commit, showing this knob is now mostly of historical importance.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] Documentation: add a description for net.core.high_order_alloc_disable
    https://git.kernel.org/netdev/net-next/c/40ad0a52ef5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


