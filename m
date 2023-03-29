Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024A36CD3DB
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjC2IAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjC2IA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEE72114
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 01:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2980B820F8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B760AC433A0;
        Wed, 29 Mar 2023 08:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680076825;
        bh=vYj10jCTmeI1gZxIJdCWe+BulBqF+5oEYXhTIRl55qQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z3J5fRV5SQI+nDQMRXgDxhKrHHLKlY/YAl/P1WRlDhBcx9wOh2yGBmvalr3XHODJO
         Tz3Aekef5WtkhqHH9Ge/jhRJMo4WGLHEdeYt90ikVud03JKcmruBKaEr687eY5ZV57
         F2iw74kjN+JVLpegbmQXBzAi+n1psGoBXBPfICsQ5yT1fag+UytPqgM0OD5WjOjXjg
         yXegGspHy8QNFndyoGd4B2PJcY8kuLSEpPa8JeV0v4M4QBiX2l7X3mXLwpW9rQ2AC0
         LKKm2Nm4jdoYc565H9jXoc3sQ5d8KGi85UKlzHLxTaVb7FFQaB7qSyBhfeN2GeDD5z
         umbp20F3SfkEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9BFEAE21EE4;
        Wed, 29 Mar 2023 08:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] ipv6: Random cleanup for in6addr_any.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007682563.9659.522742483015153716.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 08:00:25 +0000
References: <20230327235455.52990-1-kuniyu@amazon.com>
In-Reply-To: <20230327235455.52990-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Mar 2023 16:54:53 -0700 you wrote:
> The first patch removes in6addr_any alternatives and the second
> removes redundant initialisation of a local variable.
> 
> 
> Changes:
>   v2: Use ipv6_addr_any() in patch 1. (David Ahern)
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] ipv6: Remove in6addr_any alternatives.
    https://git.kernel.org/netdev/net-next/c/8cdc3223e78c
  - [v2,net-next,2/2] 6lowpan: Remove redundant initialisation.
    https://git.kernel.org/netdev/net-next/c/be689c719eb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


