Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAF362BF7F
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbiKPNaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiKPNaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C216DFD0;
        Wed, 16 Nov 2022 05:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 446A5B81D5A;
        Wed, 16 Nov 2022 13:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E54B2C433C1;
        Wed, 16 Nov 2022 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668605418;
        bh=bGIgDN/wI5fAzQjOOkc3yZKt/Z713qmp2KemjHT10+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SyJLPa+EDiIq8CBgUwQPN2FDEg379+LdySKPiqg2ay9ch5vz0TAdTCo5TsQE6k5w/
         tUscDLivkpQotgJg7Iv9BV5JZuOEDLYbkceirf+tb8Z5/5aqWbnVREm3kc1vsH+lJg
         dkammnxlqLfyb/b/9FNP3xwlYGiAD5EQelaBdC8YoIYigGU+jHXPZ4tyHRjcwOxOci
         Msi9t6eelj0k3+uhH1/7H3wtX0yTwlYWYWtI6s1eIcen7XgxES0QIZFOoHLhMA0Jx3
         O3jPGcpLuAPFz+veCiW7wKDMMnNh05uLOlTlJ9IxqGbhCHyoOPsZOBd1c2wCebHaRy
         eJHjP99exdlxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C463EE21EFA;
        Wed, 16 Nov 2022 13:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] tcp: configurable source port perturb table size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166860541779.25745.3784533755037839825.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 13:30:17 +0000
References: <20221114225616.16715-1-glex.spb@gmail.com>
In-Reply-To: <20221114225616.16715-1-glex.spb@gmail.com>
To:     Gleb Mazovetskiy <glex.spb@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        paul@crapouillou.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Nov 2022 22:56:16 +0000 you wrote:
> On embedded systems with little memory and no relevant
> security concerns, it is beneficial to reduce the size
> of the table.
> 
> Reducing the size from 2^16 to 2^8 saves 255 KiB
> of kernel RAM.
> 
> [...]

Here is the summary with links:
  - [1/1] tcp: configurable source port perturb table size
    https://git.kernel.org/netdev/net/c/aeac4ec8f46d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


