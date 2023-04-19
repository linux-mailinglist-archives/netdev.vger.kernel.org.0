Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C467F6E7230
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjDSEUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbjDSEUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DF144B3
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 21:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33E4E63AEF
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C9E7C4339B;
        Wed, 19 Apr 2023 04:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681878018;
        bh=tpFcUjVuxRuRcBQkp+mSsmyypZfeMIisbHnQItzCWVw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rNmXpOKFMDkYn7jPuwFKjdhnoHRUq+Styg9c+fHO66YU/S15wP8jagAVcUWyK43ag
         vzDk8W6GFd2JiEeoCM/cpnbVZZPzP0UYwPSwhkHgAGUp6cs8qV/DMaG1E/41Z2eiL4
         joh3Y9HiW6wtVyRtgVAmbfg6pB41/zYSE5TMPqlet6LCbdquBCMB+1zuzwWY507u+i
         X93DLHBFNLFIM+IlWUJVmlMwvdpD9+856gmDf5/5F+qhJYSUxeooTg6qpoa821UPt9
         qmcARj5EL+4ijFM+U+5e/mWyGqB7yF/wAozs1V2HG8AJiCo+mzcIi8o6bJjX4XOSE0
         Xl9CxC+XL3bJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6B3C6E3309C;
        Wed, 19 Apr 2023 04:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv5 net-next] bonding: add software tx timestamping support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168187801843.17957.751284024402477787.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 04:20:18 +0000
References: <20230418034841.2566262-1-liuhangbin@gmail.com>
In-Reply-To: <20230418034841.2566262-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        liali@redhat.com, simon.horman@corigine.com, mlichvar@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 11:48:41 +0800 you wrote:
> Currently, bonding only obtain the timestamp (ts) information of
> the active slave, which is available only for modes 1, 5, and 6.
> For other modes, bonding only has software rx timestamping support.
> 
> However, some users who use modes such as LACP also want tx timestamp
> support. To address this issue, let's check the ts information of each
> slave. If all slaves support tx timestamping, we can enable tx
> timestamping support for the bond.
> 
> [...]

Here is the summary with links:
  - [PATCHv5,net-next] bonding: add software tx timestamping support
    https://git.kernel.org/netdev/net-next/c/980f0799a15c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


