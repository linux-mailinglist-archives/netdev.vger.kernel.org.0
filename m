Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D633D692E00
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBKDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBKDkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DA73644A;
        Fri, 10 Feb 2023 19:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30A4661F17;
        Sat, 11 Feb 2023 03:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D1D4C433A4;
        Sat, 11 Feb 2023 03:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676086818;
        bh=lXYofAqTFUqqqeC5+WMCdiZd7ho/+tOiS9hr6/ItLmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VcKML1MiPT14iaCXG8d2dDwRyw6oGstBqV7jXCrnoXShDWSsTHQxea90rHllVjDM8
         OFP3/y8RI5xhKgYHVljtsjlsaNvPft8SF/2uzEM+px1pPukvajIFBCEf8wQRK9w3Ts
         x/vL1+iopx68ZT3YMjyYyx5TwRxxVg789dD7BokKI8t0ZhYBMqDdrTfWZ0XaIJo+N/
         WKu/82cZwZee142+p6DmsPU6MXswNsiqdOyFrZ5YiO7Wmtqwq/BUJrhm9GSB14wwWg
         MSDEnYL1ZUy056buQwg1p9luq5sTDvymS5q5C2j+vc/42yuo2PhnIdFbnHgKozq8un
         J6mrJZprwd3og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72326E21ECB;
        Sat, 11 Feb 2023 03:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] sctp: sctp_sock_filter(): avoid list_entry()
 on possibly empty list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608681846.24732.9268421682221173439.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 03:40:18 +0000
References: <20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it>
In-Reply-To: <20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, c.giuffrida@vu.nl,
        h.j.bos@vu.nl, jkl820.git@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 09 Feb 2023 12:13:05 +0000 you wrote:
> Use list_is_first() to check whether tsp->asoc matches the first
> element of ep->asocs, as the list is not guaranteed to have an entry.
> 
> Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---
> Changes in v2:
> - Use list_is_first()
> - Link to v1: https://lore.kernel.org/r/20230208-sctp-filter-v1-1-84ae70d90091@diag.uniroma1.it
> 
> [...]

Here is the summary with links:
  - [net-next,v2] sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list
    https://git.kernel.org/netdev/net/c/a1221703a0f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


