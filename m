Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0F5525FBB
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379399AbiEMKaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377246AbiEMKaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2325E506EC;
        Fri, 13 May 2022 03:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFCCDB82BCC;
        Fri, 13 May 2022 10:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 918C2C34114;
        Fri, 13 May 2022 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652437813;
        bh=No+Dsk1Kq3rW4PvecTqOfZMyLrB+e5h4qRQTpX2hecY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=plhPWaSVQbEHrI40GDh/TfpNPmP4a/TAFWUP54QtKxSdd5GxeskIbVPqa+Oo/t315
         aiI6qbt2t0Vm8j3vQ/Hx2H+KLE7U0KcIuguyF19RX1vbd0WdG73wVWDOE+NGumSNeg
         3DDTCmstDfyT67U9KZerg4x3q6lBVzM0cfuMyNBC4NTSqBb32uHr/jeaFHtR3KExfC
         r3rynYWBOBnS+48msaBddzkRsI77/mIXGrkEXSARNYBw75mTi8uWWas0tOTMHZjaw8
         Ujbp6RlrgqObQSVq1KkXJRMVaNDi/URxbdqzmsGUMTyl5H4kv5ZKAFQ6E7qrMd9N4Q
         aMbd+AxpOThLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7575FE8DBDA;
        Fri, 13 May 2022 10:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: Use swap() instead of open coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165243781346.13899.7526445245904168744.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 10:30:13 +0000
References: <20220512060905.33744-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220512060905.33744-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     wellslutw@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 12 May 2022 14:09:05 +0800 you wrote:
> Clean the following coccicheck warning:
> 
> ./drivers/net/ethernet/sunplus/spl2sw_driver.c:217:27-28: WARNING
> opportunity for swap().
> 
> ./drivers/net/ethernet/sunplus/spl2sw_driver.c:222:27-28: WARNING
> opportunity for swap().
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: Use swap() instead of open coding it
    https://git.kernel.org/netdev/net-next/c/a19cef450bb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


