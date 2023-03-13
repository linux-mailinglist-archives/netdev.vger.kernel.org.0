Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237B56B85E8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCMXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCMXKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:10:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CC7132C0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 215F0B815E5
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6A97C433D2;
        Mon, 13 Mar 2023 23:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678749018;
        bh=bs989j2EVJUWwGxbc4NLIbRLwkDYUQ+OFfsLakuVsQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZNu3p2oOUodpf1d9JD2uFBKux8yxLWJUBgdyRR7pqp7I/22pHNreaE1hBUHenT9WH
         LOK+/5u/9WA8bbF0fQT6xWkbQRQS68MQmqFeNOR1y4qF3WFgNpzrOCzMoR0cqJyoMr
         juJFa92K+cx9W0QQAzKexZO93Eo5DYsp4vR7QZYUKn0xVH21ZUgAVLWmjFTUsy0BuZ
         pFjC7yr2K39wZL6tppTDaEIkB8Eg3cQyP7kZpuK/B4Rqrw+dYQEVtefQfujAyBsBjz
         VFgW8JzQovW6gCl6J7OHAxKX0/Hm3byglaRxgDrAoKL+ulRFUg23u+Cs1ydBCRdWz9
         4jHaHnMZEnDvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C399BE66CBA;
        Mon, 13 Mar 2023 23:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: socket: suppress unused warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167874901879.19822.785133284369487672.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 23:10:18 +0000
References: <20230310221851.304657-1-vincenzopalazzodev@gmail.com>
In-Reply-To: <20230310221851.304657-1-vincenzopalazzodev@gmail.com>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, kuniyu@amazon.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 23:18:51 +0100 you wrote:
> suppress unused warnings and fix the error that there is
> with the W=1 enabled.
> 
> Warning generated
> 
> net/socket.c: In function ‘__sys_getsockopt’:
> net/socket.c:2300:13: error: variable ‘max_optlen’ set but not used [-Werror=unused-but-set-variable]
>  2300 |         int max_optlen;
> 
> [...]

Here is the summary with links:
  - [v2] net: socket: suppress unused warning
    https://git.kernel.org/netdev/net-next/c/ad4bf5f2406f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


