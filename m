Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6196E74DE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjDSIUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjDSIUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:20:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6889775;
        Wed, 19 Apr 2023 01:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A53C63C52;
        Wed, 19 Apr 2023 08:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF1F8C433D2;
        Wed, 19 Apr 2023 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681892418;
        bh=Mr0B9uCVD5trRbAKu1vsfRpRO8Am8uiDAmvqlfUo7ug=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fn/cE0TfqezwmgdpGOvFCZdbmVPGSRBKXZgdbqDq8HfGRLXL385u+Zvh5is1bAmiN
         dfLB/qd95MKh3JA7gXTTZLjFWQgfC3Oo+akkyuxCby0pAIe2/s+vqPi570vmooaNJf
         XXtk/AZUDd/nMDIe4hdqcxegJQzyq16SBxBsFaokFO6Lzp6s5LTmyr5PWQUz1d9wz1
         OVBwuX0WHqg9H+c8k00DO8R3GYH56TCQfrS/sqPs2T5UQi25bnmI7TvzMAFhz9C8Gg
         mQDZcO4IwkOhZsjLrpNwRxTsGHxqEfxagwAw3DnyNIVDNZ9i58j/LwZdZRt88q/0s2
         AYpymD7adsEiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEE16C561EE;
        Wed, 19 Apr 2023 08:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: fixes around listening sockets and the
 MPTCP worker
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168189241877.2626.11768515224982258773.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 08:20:18 +0000
References: <20230417-upstream-net-20230417-mptcp-worker-acceptw-v1-0-1d2ecf6d1ae4@tessares.net>
In-Reply-To: <20230417-upstream-net-20230417-mptcp-worker-acceptw-v1-0-1d2ecf6d1ae4@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpaasch@apple.com,
        stable@vger.kernel.org
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

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 16:00:39 +0200 you wrote:
> Christoph Paasch reported a couple of issues found by syzkaller and
> linked to operations done by the MPTCP worker on (un)accepted sockets.
> 
> Fixing these issues was not obvious and rather complex but Paolo Abeni
> nicely managed to propose these excellent patches that seem to satisfy
> syzkaller.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: stops worker on unaccepted sockets at listener close
    https://git.kernel.org/netdev/net/c/2a6a870e44dd
  - [net,2/2] mptcp: fix accept vs worker race
    https://git.kernel.org/netdev/net/c/63740448a32e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


