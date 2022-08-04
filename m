Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB41589632
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiHDCkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 22:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiHDCkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B014D140AA
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 19:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 549C76174E
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 02:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7760C433D7;
        Thu,  4 Aug 2022 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659580814;
        bh=XvWYZFRfuRxvshAnBzoZNrOLSdesRYyIHveZZ6WCmsg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nYxWsbWWTkqBVTe2EU5hT2a1dUIuhNg/FRC3ZFbrPbcS7pIdjUFhaPDCHZDW4Wga6
         q5KICJ/bneZfr6dZNhcLJytDM304n08l+7gJ/65j7GKmcuToc5qu0G0Mql3rrtbGZd
         amVca77xDjfhjQYyY4w62mwiVgN1/4Md5p2gjRH5yiNw3iZhP0ddkX+OVpR8miJJzu
         iJkiyUNLVsSgeMVrwaonRIbFOS+PtBM9j6ngi3ilbk5KtePeGF2XqTkcnMXCPKe/0w
         /lIQPC2fT3+sZ/1HQjIC1BhPj5FtBEJ1/VwrXpHqjy64JrTyKYibk5kPe33bz8hrEA
         dA0TFqjI8t/wA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8CCEAC43140;
        Thu,  4 Aug 2022 02:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 0/4] Make DSA work with bonding's ARP monitor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165958081457.15999.8309181158403330653.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Aug 2022 02:40:14 +0000
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        jtoppins@redhat.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, liuhangbin@gmail.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, razor@blackwall.org,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 31 Jul 2022 15:41:04 +0300 you wrote:
> Since commit 2b86cb829976 ("net: dsa: declare lockless TX feature for
> slave ports") in v5.7, DSA breaks the ARP monitoring logic from the
> bonding driver, fact which was pointed out by Brian Hutchinson who uses
> a linux-5.10.y stable kernel.
> 
> Initially I got lured by other similar hacks introduced for other
> NETIF_F_LLTX drivers, which, inspired by the bonding documentation,
> update the trans_start of their TX queues by hand.
> 
> [...]

Here is the summary with links:
  - [v3,net,1/4] net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS
    https://git.kernel.org/netdev/net/c/06799a9085e1
  - [v3,net,2/4] net/sched: remove hacks added to dev_trans_start() for bonding to work
    https://git.kernel.org/netdev/net/c/4873a1b2024d
  - [v3,net,3/4] Revert "veth: Add updating of trans_start"
    https://git.kernel.org/netdev/net/c/08b403d5bf07
  - [v3,net,4/4] docs: net: bonding: remove mentions of trans_start
    https://git.kernel.org/netdev/net/c/cba8d8f57dfb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


