Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD044DE60E
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 06:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242149AbiCSFBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 01:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241075AbiCSFBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 01:01:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682FBDE900
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 22:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB2460C1C
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 05:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 458E1C340EF;
        Sat, 19 Mar 2022 05:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647666015;
        bh=8tu/EkPx/ofd/bHdS0bdO/g5rOvZoBx/558MOghZIY0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ue08Te2m8LyRpSrLX5iB+f05HbbtxCaSApl+x+Ph27K2lnmIJU8izRVXACmKYPduE
         NhP4bJw9JrB31kzuIVLR23xavukaNIPPJej0K30NdeEstURneGeLWwC4ok4sGtDniQ
         pT+TyZ52v8zGTTwTmZaATaHsjDyoVcPeDoRRZ+1MZCC27UxpYhwHcoFUWU3BcQ16nB
         LRXIPzNK4vUCMAVojV5RO17Cp6FyVtgg6SC2E4CpnX8CLkHcjigFDJT/0hQvVTYi35
         6QALT+CihBXKLWkbXrNc1Zqc3G8yfGnEcmLKo7FOZ+zOTPPaBreWxX+oyMAofvE9QN
         kkZ0rHc6u6MFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 226A6F0383F;
        Sat, 19 Mar 2022 05:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_netlink: Fix shift out of bounds in group mask
 calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164766601513.31878.9967972263971698596.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Mar 2022 05:00:15 +0000
References: <2bef6aabf201d1fc16cca139a744700cff9dcb04.1647527635.git.petrm@nvidia.com>
In-Reply-To: <2bef6aabf201d1fc16cca139a744700cff9dcb04.1647527635.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Mar 2022 15:53:06 +0100 you wrote:
> When a netlink message is received, netlink_recvmsg() fills in the address
> of the sender. One of the fields is the 32-bit bitfield nl_groups, which
> carries the multicast group on which the message was received. The least
> significant bit corresponds to group 1, and therefore the highest group
> that the field can represent is 32. Above that, the UB sanitizer flags the
> out-of-bounds shift attempts.
> 
> [...]

Here is the summary with links:
  - [net] af_netlink: Fix shift out of bounds in group mask calculation
    https://git.kernel.org/netdev/net/c/0caf6d992219

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


