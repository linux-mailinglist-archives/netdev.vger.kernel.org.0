Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB4056950B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 00:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbiGFWKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 18:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiGFWKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 18:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDE624097;
        Wed,  6 Jul 2022 15:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D188B81F23;
        Wed,  6 Jul 2022 22:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6D74C341CE;
        Wed,  6 Jul 2022 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657145414;
        bh=o70OK8TpjApBWZvELEJ8mjGNmmOJbY3r4/9javYZ2eg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sjlisyl+qtuCS8L+G+7ilrnsv5BamxF/pHORTG0+U9A4WDz8SySNDpRdQXLX4+L0v
         9J1HW7hEUV9kzXEyC8wZ6K8/fcmWk/Q6yhU3LNQPINSwGvlXpBchJfRqJ5JoBPJfi3
         EKVwJ6eQhoaOD6Vf5/pdqDSV2qZdccVWpRdShoMb+R5Cl6VTBlBBRCJh0AaTFhEF4z
         bHV4wEwpr6qsA6J2ZSqMjBc2fxyLjS42ys7X/FXYiUH1Zy3IsriORHKuJk2ccMDVLv
         tyIlVuzOHn4SmRUTeVhTdnXIRWq1ISsyAVOAZ0typzb7rDIJEGwmC2gqSQE/1oPo8N
         NTVRknIb4EDOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91316E45BD8;
        Wed,  6 Jul 2022 22:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] net: hinic: fix bugs about dev_get_stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165714541459.11403.18049389885434650887.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 22:10:14 +0000
References: <cover.1657019475.git.mqaio@linux.alibaba.com>
In-Reply-To: <cover.1657019475.git.mqaio@linux.alibaba.com>
To:     Qiao Ma <mqaio@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, gustavoars@kernel.org, cai.huoqing@linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  5 Jul 2022 19:22:21 +0800 you wrote:
> These patches fixes 2 bugs of hinic driver:
> - fix bug that ethtool get wrong stats because of hinic_{txq|rxq}_clean_stats() is called
> - avoid kernel hung in hinic_get_stats64()
> 
> See every patch for more information.
> 
> Changes in v4:
> - removed meaningless u64_stats_sync protection in hinic_{txq|rxq}_get_stats
> - merged the third patch in v2 into first one
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] net: hinic: fix bug that ethtool get wrong stats
    https://git.kernel.org/netdev/net-next/c/67dffd3db985
  - [net-next,v4,2/2] net: hinic: avoid kernel hung in hinic_get_stats64()
    https://git.kernel.org/netdev/net-next/c/98f9fcdee35a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


