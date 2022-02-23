Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266804C133C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240631AbiBWMun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240593AbiBWMul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:50:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01445A8EC6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E2C5614A5
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 12:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA10FC340F1;
        Wed, 23 Feb 2022 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645620613;
        bh=/Ilt8V8m5wYGN1C7MXgYEYDmg57TZzCwmhsN740jyqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BJ3YTpNGg4zH1fcuYwEUOVadwA20IqmJReH1BN8jeuhlna9S0PE3t9ZpJvNg9sZrV
         ddYNhccHbPXg1lv5SaxNi6v3+v911YmFjndCiGuAAiPqqQtzIgc5S9owCN/P+EiSYm
         6avstn/rxGMCQ+Oyc5FkNM4hXHMGOe8zoiz7/s9bifvO3VsKy4dX+QS9QBA4cwJQ1B
         qiEdJxKKzMNWzZhDVTtUgIOgoTnuDg6FgAeWZaAim+h3l58dPXeIpXbBV5O7qNQW+0
         v3JWEpnexcXpzCktSDmH3RORzbHclZHCUfep2roo/LN3vrOocgx4G5+bxbqsE6A2ZZ
         yXyS/M8BwxJRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4086E6D544;
        Wed, 23 Feb 2022 12:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] drop_monitor: remove quadratic behavior
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562061286.32023.9383932537071498389.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:50:12 +0000
References: <20220222220450.1154948-1-eric.dumazet@gmail.com>
In-Reply-To: <20220222220450.1154948-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, nhorman@tuxdriver.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 22 Feb 2022 14:04:50 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> drop_monitor is using an unique list on which all netdevices in
> the host have an element, regardless of their netns.
> 
> This scales poorly, not only at device unregister time (what I
> caught during my netns dismantle stress tests), but also at packet
> processing time whenever trace_napi_poll_hit() is called.
> 
> [...]

Here is the summary with links:
  - [net-next] drop_monitor: remove quadratic behavior
    https://git.kernel.org/netdev/net-next/c/b26ef81c46ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


