Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D8C68E7CF
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjBHFlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBHFlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:41:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCD94520C;
        Tue,  7 Feb 2023 21:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 965CFB81B08;
        Wed,  8 Feb 2023 05:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D658C433EF;
        Wed,  8 Feb 2023 05:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675834817;
        bh=Us4FadwYlrbrvyXs3zvgd51vNEkanvdqeJ0tRGQNJYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kPQCGghbtktK+QepQJdWG46J4dKyw93WBEU8Rs/O9E+a9t7bmRH8HTtlV7WQJ+Nlo
         6SdwZmWOTMrLl9MlxhFlQURSWgGsTgnIlAHW/OXFDf3fVxDkY1aNjh+KrShfjhrXC2
         42DbxAdzjhUoJIqp7XcsI2+LjNRWLqplYwc7HmJvIu6zZyh4gJxCZs8VPV/SulFdqd
         v9QnSRlMVpjxuFaUOMtYYfVmuUuHdWT/029OAq9bwhmyFJ1517NBNMrSi6XFHJj2cs
         MMdP0kR9FepiabxUeRwIisS+2LctWDu5nS1Vq+6L2fG391yn37DAwhAvcfoZbJX/zR
         ltxozN5fHubUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AF8AE4D032;
        Wed,  8 Feb 2023 05:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v3] net: mana: Fix accessing freed irq affinity_hint
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167583481717.22246.14172686294681765348.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 05:40:17 +0000
References: <1675718929-19565-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1675718929-19565-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, leon@kernel.org, longli@microsoft.com,
        ssengar@linux.microsoft.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
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

On Mon,  6 Feb 2023 13:28:49 -0800 you wrote:
> After calling irq_set_affinity_and_hint(), the cpumask pointer is
> saved in desc->affinity_hint, and will be used later when reading
> /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> persistent. Otherwise, we are accessing freed memory when reading
> the affinity_hint file.
> 
> Also, need to clear affinity_hint before free_irq(), otherwise there
> is a one-time warning and stack trace during module unloading:
> 
> [...]

Here is the summary with links:
  - [net,v3] net: mana: Fix accessing freed irq affinity_hint
    https://git.kernel.org/netdev/net/c/18a048370b06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


