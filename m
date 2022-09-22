Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5865E64C0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiIVOKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiIVOK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:10:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472826DFB0;
        Thu, 22 Sep 2022 07:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93DAFB83729;
        Thu, 22 Sep 2022 14:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33807C433C1;
        Thu, 22 Sep 2022 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663855816;
        bh=TzvR0POpCaJRrnTgwnJ2GPn3jJmBUHGSUIQxgtzE2mE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RmEH2QkTIYIuCUof0k1xyeEmrkPPgyQyuQi6aAZ91QYVVnvyKTPS+TvA+AMbKiCpD
         zcAjPD8bsKef2qxG9vBf+jR8JTUT2su7uc/uNUQ5MpM0GFnzt56/1dk3Z2W6ag2uu0
         /ROR/VwxJ32TajACzPEHFlYGyIoyha91RCnt+6Mb+bW8pFSIOOrwGWgGnf2ypd4I5R
         vAQOmxkbnmN5JvEXYYOaVJiflHweGBNzNYDPG49/iH/CfmaZ/kT+BDvBEez5/Chu5H
         b2O/laBPdDlNSOfMMnR1Sc7jbUoFdh1TMkML32Y6tVF6AIahF9GciQvwo4Uxtk68bq
         bOS+X28VRHCQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15AA1E4D03D;
        Thu, 22 Sep 2022 14:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] udp: Use WARN_ON_ONCE() in udp_read_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385581608.2095.10177903030009294080.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 14:10:16 +0000
References: <20220921005915.2697-1-yepeilin.cs@gmail.com>
In-Reply-To: <20220921005915.2697-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        peilin.ye@bytedance.com, cong.wang@bytedance.com,
        kuniyu@amazon.com, ast@kernel.org, netdev@vger.kernel.org,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Sep 2022 17:59:15 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Prevent udp_read_skb() from flooding the syslog.
> 
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [net] udp: Use WARN_ON_ONCE() in udp_read_skb()
    https://git.kernel.org/netdev/net/c/db39dfdc1c3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


