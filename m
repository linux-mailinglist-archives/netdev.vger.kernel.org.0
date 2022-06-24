Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11502559832
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 12:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiFXKuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 06:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXKuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 06:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC35677053
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 03:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89D94B827FF
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BEAFC341CE;
        Fri, 24 Jun 2022 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656067820;
        bh=0sbYo8VY8kZdyvn0JbwbqWfvi2W/irz3HESvEmDA7rc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TkLAm7CCvOp1FWSOULaT8/JkpvNVkd2JbQzk1KVituJmVo3YtLihz8vBmrZVGT+Wt
         SbmTxUJFlGbztmtOMY7WHeXSSMn2bszDxvwDQw+N2+CegG3ET/P5hyOeJriizwePb6
         RogREdgbcXp6o+13QROpjlX6Ozb64Kjbo1meI4Vn83pTY/wW94uT+6NknWQMiWNY5Z
         ++g0ejaF2oeEEGQMR7AFizzN7rrCz7iJBAwNB7j4gerI+zx9RGij/76GMAAYd2n6kA
         dPdeClEGBehO0IK7I7Ncb2SS3QZtNI+dP1fxnn3GrP/UdjgQMeMWjxdNw5grE3cjx/
         FpvwOgQPUqQCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30F55E8DBDA;
        Fri, 24 Jun 2022 10:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net-next 0/2] Bonding: add per-port priority support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165606782019.15655.15447967896338284112.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 10:50:20 +0000
References: <20220621074919.2636622-1-liuhangbin@gmail.com>
In-Reply-To: <20220621074919.2636622-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        jtoppins@redhat.com, pabeni@redhat.com, dsahern@gmail.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 21 Jun 2022 15:49:17 +0800 you wrote:
> This patch set add per-port priority for bonding failover re-selection.
> 
> The first patch add a new filed for bond_opt_value so we can set slave
> value easier. I will update the bond_option_queue_id_set() setting
> in later patch.
> 
> The second patch add the per-port priority for bonding. I defined
> it as s32 to compatible with team prio option, which also use a s32
> value.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net-next,1/2] bonding: add slave_dev field for bond_opt_value
    https://git.kernel.org/netdev/net-next/c/f2b3b28ce523
  - [PATCHv3,net-next,2/2] Bonding: add per-port priority for failover re-selection
    https://git.kernel.org/netdev/net-next/c/0a2ff7cc8ad4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


