Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA0252615D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380058AbiEMLuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380043AbiEMLuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F821F97AA
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 788C0B82EA4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34992C34117;
        Fri, 13 May 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652442614;
        bh=2MKe5L6EEAsrqD/S8Bez7vaZzh0i4tXVgfdqr4GVpPE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=riCUIr2C1YPbpafAetPxaV/Q1DqmzaqH9vGnKXz6uSu48Alh9w/tj3QTpTBvuMl09
         UJVDKC5BOWKMEt3weko8bUOpnAEXxBRR8VrsUS2LwiVvJlL/pOsJh6juJiHbd7hkbN
         lF9T+rfFJ99iXSM787IaZL1yPEmUfErRrD3Fc8ZLejch+JFwwd6WlUmEXT3iq+B/WC
         uE2cxKqmScc0Shsu905gRLpWdWuAGw2EsIynojg8fSkZe9vW8w25PkYo+u08J7muHi
         s+rkMVOFWq8D74qGGSwswsWkwg9YzkOEtYKkyI8aKaz7zHuZRXJYEcy8IiDcLRCjg9
         EtkklmMy2xJhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18C69F03934;
        Fri, 13 May 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "tcp/dccp: get rid of inet_twsk_purge()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165244261409.26306.10891590325556196939.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 11:50:14 +0000
References: <20220512211456.2680273-1-eric.dumazet@gmail.com>
In-Reply-To: <20220512211456.2680273-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, cdleonard@gmail.com
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

On Thu, 12 May 2022 14:14:56 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts commits:
> 
> 0dad4087a86a2cbe177404dc73f18ada26a2c390 ("tcp/dccp: get rid of inet_twsk_purge()")
> d507204d3c5cc57d9a8bdf0a477615bb59ea1611 ("tcp/dccp: add tw->tw_bslot")
> 
> [...]

Here is the summary with links:
  - [net] Revert "tcp/dccp: get rid of inet_twsk_purge()"
    https://git.kernel.org/netdev/net/c/04c494e68a13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


