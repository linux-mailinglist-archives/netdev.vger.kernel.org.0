Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F16355F4E2
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiF2EKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiF2EKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:10:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9EF220C5;
        Tue, 28 Jun 2022 21:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A91A8CE220D;
        Wed, 29 Jun 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7582C341CD;
        Wed, 29 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656475813;
        bh=+lrPPePihGOQSBmRtOjtdtauhhMK3bc2RbQmmsKN20A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RfEcZGJm/n1H3whit5kajmz4nGPVQFR+zAbnjtNlh0PuKvYDy1ssmTfeP/okKExlt
         mUz4XE2Z3ox+SHokqbTbmuLwLQeBZs5qV+0wKHgYG4/wmwclSRTK2zi6ZNUUCD8Dif
         bpt9o2bq9cM7rwBfiTksnWQ3ucFgg1DPv6jdwYU5VR2I3SFow2ZKG/RIycNHSCHEWk
         fc7okke3bX70WBMkZUQs1b36RMRL9/KajTyxZ/HUQmWKtAoIYDMyGtuC65W5bmwFXt
         Iru5oSKNLk4scO66nbWwndITzDgn+U2b3RSsPjgpIsivpXqr+mmnNzzO01huy0gwBv
         E/sZQhJXpV1Ig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 908E4E49BBA;
        Wed, 29 Jun 2022 04:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] ipv6/sit: fix ipip6_tunnel_get_prl return value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165647581358.19740.5854557950098797693.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 04:10:13 +0000
References: <20220628035030.1039171-1-zys.zljxml@gmail.com>
In-Reply-To: <20220628035030.1039171-1-zys.zljxml@gmail.com>
To:     Katrin Jo <zys.zljxml@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com,
        pabeni@redhat.com, katrinzhou@tencent.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 28 Jun 2022 11:50:30 +0800 you wrote:
> From: katrinzhou <katrinzhou@tencent.com>
> 
> When kcalloc fails, ipip6_tunnel_get_prl() should return -ENOMEM.
> Move the position of label "out" to return correctly.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
> Signed-off-by: katrinzhou <katrinzhou@tencent.com>
> 
> [...]

Here is the summary with links:
  - [v3] ipv6/sit: fix ipip6_tunnel_get_prl return value
    https://git.kernel.org/netdev/net/c/adabdd8f6aca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


