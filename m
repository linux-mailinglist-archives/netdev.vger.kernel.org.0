Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB7152CB4B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiESEuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiESEuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3525D56437
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 21:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C946EB82349
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82925C34113;
        Thu, 19 May 2022 04:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652935813;
        bh=Y6vOaGh6qKqJFuFh70TmMAUo2kU4B76g9hdMFwDIlr0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XEmFpOAXxSaqKuKJelUho2birSTvFkaKeIE8mKMTGibrW25qVNCvoKytEm0tEYe1n
         cJhLXS7wBGgUPu+rVqLQbFeKZBcqT12N2KCnnaAU9RnMvGDZ1v2LbLgOnx/LcRg71Y
         IJEaiIK0Ul9IUjQkXC2TyZcvi/RhzhLBdPkuAY317AYX2lFO4PaGAvaxHsgpFSRBbt
         7gZ5alf9PMQ9l2RW1Hh6r6G01vsCC9BXLhvm9BHw5zzqc3rAS1L6laTNwcVa1mfiAQ
         GbPGq1WitjW2/fAB8M7LoH4/6vABXmYt0pXFar/CQa4Ogltcu3bQI5ThszFyDDeHnU
         uWI+tfhBmC8NA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66B94E8DBDA;
        Thu, 19 May 2022 04:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: ocp: change sysfs attr group handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165293581241.19199.7423610878730519306.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 04:50:12 +0000
References: <20220517214600.10606-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220517214600.10606-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     zheyuma97@gmail.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kernel-team@fb.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 May 2022 14:46:00 -0700 you wrote:
> In the detach path, the driver calls sysfs_remove_group() for the
> groups it believes has been registered.  However, if the group was
> never previously registered, then this causes a splat.
> 
> Instead, compute the groups that should be registered in advance,
> and then call sysfs_create_groups(), which registers them all at once.
> 
> [...]

Here is the summary with links:
  - [net] ptp: ocp: change sysfs attr group handling
    https://git.kernel.org/netdev/net/c/c2239294188f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


