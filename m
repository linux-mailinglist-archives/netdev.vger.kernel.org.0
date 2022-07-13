Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B61573834
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbiGMOAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbiGMOAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75902D1CB;
        Wed, 13 Jul 2022 07:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74DB461D96;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF2AAC341C0;
        Wed, 13 Jul 2022 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657720814;
        bh=nqRDKZknBDuKW18REhA/cBNZYXJqPytagNpFFWtyS08=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mp0OeFruUnTwB+4rkEDx6qXEcMT8cEf5G4PzWMS7mVj1ZSa8SWk5V1C+eglczKpU0
         CMrM9oGbKbVD0tla3nVQJhr/LGP0S5wVOo0+0oh8LK90+Q2/IRdru4epFQIiwWqEnZ
         h57OL/Qww1Ym8VD0gF2t3RheAW3abWyH8hD9+pHztdXUZS0O9PnqgKmcG/9ocFtuV9
         6t/StAKvoWMzxcwl/5/JpY1FUEEtSTlYuI9snlGryEFeHvX/dXJzl2ZRcaDzV6e1D0
         fn8NR3Mu/LcrDBFNxFPgib7LMmWs+aPY0aPCt78Yq8svoafhkQohGWmIWdOrk5oBuj
         yLuSoIBNpdndw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9ADB2E4521F;
        Wed, 13 Jul 2022 14:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] r8152: fix accessing unset transport header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165772081462.13863.15234899108123755082.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 14:00:14 +0000
References: <20220711070004.28010-390-nic_swsd@realtek.com>
In-Reply-To: <20220711070004.28010-390-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Jul 2022 11:31:11 +0800 you wrote:
> A warning is triggered by commit 66e4c8d95008 ("net: warn if transport
> header was not set"). The warning is harmless, because the value from
> skb_transport_offset() is only used for skb_is_gso() is true or the
> skb->ip_summed is equal to CHECKSUM_PARTIAL.
> 
> Fixes: 66e4c8d95008 ("net: warn if transport header was not set")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> [...]

Here is the summary with links:
  - [v2,net] r8152: fix accessing unset transport header
    https://git.kernel.org/netdev/net/c/057cc8c9005e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


