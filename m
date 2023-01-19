Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7E673102
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 06:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjASFMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 00:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjASFMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 00:12:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F04C164
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 21:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A43661B19
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 815A0C433F0;
        Thu, 19 Jan 2023 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674105017;
        bh=LFhIx8l/yB8AwbGvYqKNxO/PgQ0NQ7jQ3YQOSrb0egY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=opy1w+kBalIeGZVEj7eKhuVheItvjKTD/xIhiSROsTmcwR8rmTFk5V7CFvTZO4LT9
         PQGifLX+zIw3uX4wEobhnBjOA9H+fbg9saPd/85ulA5XaHUkC3TuNJilh+ey8u2IP+
         oHFlKx2F8E3k2J4oy6EN7ux+f88ujblGlaD0VAwk5KyASVPh/oPK/vGaMIWXaZIqx6
         4jjAvnwmlGx0M3Vw6Vw8oMDs+W50+Pd7BFENwBG/VXrjcGmQ3i2u45xbArExpudbN/
         61iv3AEtvbKlwgBhLR1gEHfvW6fxfKsy2GwJVDWYHbbO7cERpYiRBf3ponL0QkG9yh
         Rj23RzGG8wfSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5FF25E54D27;
        Thu, 19 Jan 2023 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: gred: prevent races when adding offloads to
 stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167410501738.20849.5606819559476098583.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 05:10:17 +0000
References: <20230113044137.1383067-1-kuba@kernel.org>
In-Reply-To: <20230113044137.1383067-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, lkft@linaro.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        john.hurley@netronome.com
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

On Thu, 12 Jan 2023 20:41:37 -0800 you wrote:
> Naresh reports seeing a warning that gred is calling
> u64_stats_update_begin() with preemption enabled.
> Arnd points out it's coming from _bstats_update().
> 
> We should be holding the qdisc lock when writing
> to stats, they are also updated from the datapath.
> 
> [...]

Here is the summary with links:
  - [net] net: sched: gred: prevent races when adding offloads to stats
    https://git.kernel.org/netdev/net/c/339346d49ae0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


