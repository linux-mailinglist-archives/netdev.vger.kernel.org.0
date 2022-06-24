Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E8B55A4D6
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 01:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiFXXaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 19:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiFXXaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 19:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C88289D1F
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 16:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE6B7B82CF7
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 23:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BD3DC341C0;
        Fri, 24 Jun 2022 23:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656113413;
        bh=z2QHS7BQxIdQ8CzMop1zvByQ1Hb90mhgv6kU8xAf8mo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jDb4swzAmPwCUAcMJc8VeRN1m7+4lfdCmYbUfWj7ZslN2S5gEID9Sc3yPju72OuyA
         EHExbHa8bdM3MPOGKpkfr8759yC6kh7h60fD2moHAyZlG6I8uWfg76yYxrBeMgAV5b
         cKLgZzJfM4Vi5jh/SSMFggsTc40S9OnMTzhQ/bKwXCzcXrNPIc0eAMMrE4SVBv6FqI
         +Q45l+tBTVSKh4OV0cmMkGBoV/EZy3ljkj5E72vfFzOZeezjYpjjXsCtrAKvVVns4C
         myCC9wOYO0vvXZeSZLg9OMGvB1eHZNfrAQkBxaehUtxz6VW7s1Al8LAJP87AZrp0hO
         61VU2UFDWwqxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C122E737F0;
        Fri, 24 Jun 2022 23:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/funeth: Support UDP segmentation offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165611341330.10990.9639035161147076563.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 23:30:13 +0000
References: <20220622223703.59886-1-dmichail@fungible.com>
In-Reply-To: <20220622223703.59886-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 15:37:03 -0700 you wrote:
> Handle skbs with SKB_GSO_UDP_L4, advertise the offload in features, and
> add an ethtool counter for it. Small change to existing TSO code due to
> UDP's different header length.
> 
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> ---
>  .../ethernet/fungible/funeth/funeth_ethtool.c |  2 ++
>  .../ethernet/fungible/funeth/funeth_main.c    |  3 ++-
>  .../net/ethernet/fungible/funeth/funeth_tx.c  | 23 ++++++++++++++++++-
>  .../ethernet/fungible/funeth/funeth_txrx.h    |  1 +
>  4 files changed, 27 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net/funeth: Support UDP segmentation offload
    https://git.kernel.org/netdev/net-next/c/6ce1df88b1f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


