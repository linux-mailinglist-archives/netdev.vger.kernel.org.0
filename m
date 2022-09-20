Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C99A5BD911
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiITBKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiITBKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9553DFB3;
        Mon, 19 Sep 2022 18:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6954EB822B3;
        Tue, 20 Sep 2022 01:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14FAFC433D7;
        Tue, 20 Sep 2022 01:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636215;
        bh=6K9Pj80NBbnsBYc1uybowGtbkoVYJg2FRZWSfPmHvK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k81MmSjjzaim3l4IaH5bxMQG53m3AmrV4/LdhzKlLelyGnmCi5S4yjvwGck7E4++5
         JvZqjYqLm03pMx+oz6DiQvrz5LwoUNxhNokm9wJlNtcJ1v9uChOFJzenPSh6WaiLg6
         l/7A2M6cW73OdmXNjeNvzX0dwxnxbgMsWjJZvtntwB0EfIfpy7fue7BKBp8sAKAEdn
         fKrU0qu49h6Z535sIA5P5WjFu4zaZevV19oJ81mF/JJ7OtE9LzkKVyYnsnlQx9XLBu
         epEQBD/KRiWoIym95Rj1QnYPhVWFktXvt5e6u7gcxbsceEfrqfUKbYz4lH2d5d0ORg
         0j4pXD01trk8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC475E52536;
        Tue, 20 Sep 2022 01:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-09-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363621496.23429.3993098140075732583.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:14 +0000
References: <20220909201642.3810565-1-luiz.dentz@gmail.com>
In-Reply-To: <20220909201642.3810565-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Sep 2022 13:16:42 -0700 you wrote:
> The following changes since commit 64ae13ed478428135cddc2f1113dff162d8112d4:
> 
>   net: core: fix flow symmetric hash (2022-09-09 12:48:00 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-09-09
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-09-09
    https://git.kernel.org/netdev/net/c/95b9fd760b7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


