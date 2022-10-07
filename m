Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3885F74E1
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiJGHu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJGHuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D575465800;
        Fri,  7 Oct 2022 00:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73AA3B8227C;
        Fri,  7 Oct 2022 07:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12243C433B5;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665129016;
        bh=Bm56kxZ27RQcBV4DYK1HN3UysfXiivTacJ96G6koVj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s4kIW3GGCZa48N9n1MGqiGdXcmexk7wlvYwEIAHbjNyYW7AB8fX3WScyHTTQVXJSW
         nY8O+6MT+M/tLu5XhqPWOPFEorvkaWdfthj136SZi0M2L/nGyO0k0YkCybLweGp8s4
         /ejlWxdkYuoLa55u8J+xYwc6R7xiFU9UF7GsqGCjlauMnxWffSPQqO4BOKmzDn8TqN
         TQg/v9zQfnPNUN9uetAZb5cEu6ITMyAYhR50R66vqAVavqwCBZWD/dBbNStvSvlz9i
         KQtJXmhRRJ1hTqBvq68IPWxinu4qmtgw1KC/Ax5NIcxPYvJrbwGlrUpDCdHnqQTv9u
         oxidpr8vSl45Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E873AE21ED6;
        Fri,  7 Oct 2022 07:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: enetc: Remove duplicated include in enetc_qos.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166512901594.847.4665975253807189579.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 07:50:15 +0000
References: <20221006120136.27020-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20221006120136.27020-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
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
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Oct 2022 20:01:36 +0800 you wrote:
> net/pkt_sched.h is included twice in enetc_qos.c,
> remove one of them.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2334
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: enetc: Remove duplicated include in enetc_qos.c
    https://git.kernel.org/netdev/net/c/3030cbff67a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


