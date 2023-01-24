Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1AE6790A9
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjAXGKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjAXGKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA76F2BF3C;
        Mon, 23 Jan 2023 22:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BDBD611D3;
        Tue, 24 Jan 2023 06:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FBC8C433D2;
        Tue, 24 Jan 2023 06:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674540617;
        bh=4f2GN15RjnxK5pNmlmaG3ldBSlndSPdrc1MNKXB/nc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qwh/zjQA0IsEEaWIHp8Tl5Bo4Rr8jueaxd0QVMajLgURk+53ia5POJNNHX5l3GqKB
         t0pd+mrP7m2oWYMCGWLiepvSRzJMwgrmFep8qocnPrzlneoapZrzBxrWpxe3iEd7u0
         om/9YrVE3G/TNhWWZo0yX3pPRKCGfEjlB5NtVV27OYbKB1lOoZL61Tykd66uMVtIG3
         224mgJHM3E/y6xjif2boIjGzY/n8GFBseG12hgkBl491WBXKLOJ96DjWeedDq6Ayju
         t3U9b7Z7DjYIsi145gl2jcnNWF9qtGHJL8dDpdWlPC1jaAC01VtSWCwI7XdXj80vW7
         ar8f1MzCQ1+Wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E1D8E52508;
        Tue, 24 Jan 2023 06:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v4] ipv6: Document that max_size sysctl is deprecated
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167454061744.14000.1130341385748626372.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 06:10:17 +0000
References: <20230120232331.1273881-1-jmaxwell37@gmail.com>
In-Reply-To: <20230120232331.1273881-1-jmaxwell37@gmail.com>
To:     Jon Maxwell <jmaxwell37@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        martin.lau@kernel.org, joel@joelfernandes.org, paulmck@kernel.org,
        eyal.birger@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrea.mayer@uniroma2.it
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 21 Jan 2023 10:23:31 +1100 you wrote:
> v4: fix deprecated typo.
> 
> Document that max_size is deprecated due to:
> 
> commit af6d10345ca7 ("ipv6: remove max_size check inline with ipv4")
> 
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v4] ipv6: Document that max_size sysctl is deprecated
    https://git.kernel.org/netdev/net-next/c/695a376b59f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


