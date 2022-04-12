Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479064FCD64
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240939AbiDLECv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiDLECc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:02:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B262559D;
        Mon, 11 Apr 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24E76176C;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F8FFC385AA;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649736015;
        bh=cb2IK7ZCUYg0hCj+u3irAlPf2Mq2DTpvNrFIhw03YWc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DQMSiuzyHCR16iZFZW04LRwCMFM6zgQ6caKxUaG8/R81nQpqtLhLkz6poEnh2R2tf
         Sg938W+z0ihaazpAHZF909HczsHCYXLPZ7w/LtVBG6FQD5Tm3KV4KetKJGmH0Sk0xV
         QycatjgzX0xUY8jw+sDejG0i9xlkLXhHiDh1BWPX4GPQ3+NC1uGQhysGUSKqIYFK9l
         LYzfTdcFT+7idcqIZ928xl7JZwo5D9Tu4/jtg5bCFnnjW1/u+XuczaU4PpkUdPsRef
         bQNWQi8lamVvonXFYYakI51/HpGcQypqAldiMPEN619pA5ycnAsnCKuklsfzML6OFZ
         YSnz9cjGnoTiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16879E8DD64;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: offload BR_HAIRPIN_MODE, BR_ISOLATED,
 BR_MULTICAST_TO_UNICAST
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164973601508.30868.14748692315248046303.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 04:00:15 +0000
References: <20220410134227.18810-1-arinc.unal@arinc9.com>
In-Reply-To: <20220410134227.18810-1-arinc.unal@arinc9.com>
To:     =?utf-8?b?QXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg==?=@ci.codeaurora.org
Cc:     olteanv@gmail.com, roopa@nvidia.com, razor@blackwall.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 10 Apr 2022 16:42:27 +0300 you wrote:
> Add BR_HAIRPIN_MODE, BR_ISOLATED and BR_MULTICAST_TO_UNICAST port flags to
> BR_PORT_FLAGS_HW_OFFLOAD so that switchdev drivers which have an offloaded
> data plane have a chance to reject these bridge port flags if they don't
> support them yet.
> 
> It makes the code path go through the
> SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS driver handlers, which return
> -EINVAL for everything they don't recognize.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: offload BR_HAIRPIN_MODE, BR_ISOLATED, BR_MULTICAST_TO_UNICAST
    https://git.kernel.org/netdev/net-next/c/c3976a3f8445

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


