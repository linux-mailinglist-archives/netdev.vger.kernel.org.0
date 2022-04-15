Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E4D502798
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 11:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiDOJxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 05:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351900AbiDOJwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 05:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99316972D7
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 02:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0329620C1
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D080C385A6;
        Fri, 15 Apr 2022 09:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650016211;
        bh=aTMZVGV2I5Eqv0tyzqX7lf4UMX4aqx7CTFCoWDh+3cQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OKceTvWotEkQldhlTiJYBTfjh4wQAFJxUuhtota0qHGfiTNC0qHk2zZroWHA8i+2Y
         u5njY8eP/XH/VvG+zWbsGkIDLL/VqkGWDFHSi6TskZ6loTWbqz8XrRLDv9U8U9zWPg
         YUW+ipbO5+Pe5NOGhHULMTiqP6pMx+9+BsqLxf5idKHyOJaQ5VlRRvraHCBIO9iPrG
         4s/2ZUoo69BlzBlg+sNYSV/SBD59rNGmmEv52o2tB8jIcoPlM8IsRweMxxdeNNklMs
         XYbs1du5mUITsfnlt33de3Uz+XV26z+vwvkZ5NHkiOlTvxOfc4JskXxV3pj0NH0taK
         jROpGFRcu/ltw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EEE2E8DD6A;
        Fri, 15 Apr 2022 09:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/2] net: mvneta: add support for
 page_pool_get_stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001621118.31041.3013313309484609030.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 09:50:11 +0000
References: <cover.1649780789.git.lorenzo@kernel.org>
In-Reply-To: <cover.1649780789.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, andrew@lunn.ch, jdamato@fastly.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Apr 2022 18:31:57 +0200 you wrote:
> Introduce page_pool stats ethtool APIs in order to avoid driver duplicated
> code.
> 
> Changes since v4:
> - rebase on top of net-next
> 
> Changes since v3:
> - get rid of wrong for loop in page_pool_ethtool_stats_get()
> - add API stubs when page_pool_stats are not compiled in
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/2] net: page_pool: introduce ethtool stats
    https://git.kernel.org/netdev/net-next/c/f3c5264f452a
  - [v5,net-next,2/2] net: mvneta: add support for page_pool_get_stats
    https://git.kernel.org/netdev/net-next/c/b3fc79225f05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


