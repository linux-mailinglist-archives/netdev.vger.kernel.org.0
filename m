Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E424BA7C5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244051AbiBQSK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:10:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbiBQSK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:10:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B640B175C52;
        Thu, 17 Feb 2022 10:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54A3261A09;
        Thu, 17 Feb 2022 18:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE4EAC340F3;
        Thu, 17 Feb 2022 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645121411;
        bh=sCJkcAqcjN2K0I6iLFwlPC8Lb0pYxtpyAi1W9fm50t4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pxfM/X9C+3SMBgBLK5Kk/hoynM2ladV6nNXA6wcga/HR+62H7KijNZvAm/a6tA8yN
         8+KVkW+RFjGdg3s6ZuC2QHRF1X18dqmcavoyZYReKm4wHr9f2DTyHRRLk09Y8oX3OV
         zE0aBfVMetKToZdaB0QL9lzsEQvnjbazzSAPi9D+jRWMt2RKIzY4oNN/lqCj7W7By0
         FUDWdpqxpyOkqL5EQmYGKZIDfBOLFm7bLS2evCOBxvcQ+WRJyy6NMl6W35bERmmPB2
         d2g0Qr8lJjMo3d3yrnzfhvhy/KIRnLNGFf/2+GhbYdA9zMpuglWH4KHv1tflJJC6KU
         l5esLJWI1KEAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A7BEE7BB0B;
        Thu, 17 Feb 2022 18:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: lan9303: handle hwaccel VLAN tags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164512141162.19163.18102808709571899496.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 18:10:11 +0000
References: <20220216124634.23123-1-mans@mansr.com>
In-Reply-To: <20220216124634.23123-1-mans@mansr.com>
To:     Mans Rullgard <mans@mansr.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jbe@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Feb 2022 12:46:34 +0000 you wrote:
> Check for a hwaccel VLAN tag on rx and use it if present.  Otherwise,
> use __skb_vlan_pop() like the other tag parsers do.  This fixes the case
> where the VLAN tag has already been consumed by the master.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---
> Changes:
> - call skb_push/pull only where actually needed
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: lan9303: handle hwaccel VLAN tags
    https://git.kernel.org/netdev/net/c/017b355bbdc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


