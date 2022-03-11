Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35434D598C
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346254AbiCKEbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346246AbiCKEbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:31:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE151A39FF;
        Thu, 10 Mar 2022 20:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E866195C;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 543B7C340F8;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973013;
        bh=ciDN2VAdc1eJObt9pEjQs0UqJnRaibkHAZzfwB1zNDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IJxuGnBGVmX96EIHP0XifFxYJTsVbjlK15Onw84fO1WgXSFydjCfE3RLOCMq5qAPU
         PdnkKkS0z9p8jqjzIal+lib47SeHR8kYXccHHLe72+tCdtyJEimy3BHBbZh96LOB7L
         vS+gOs6SHxfsJuI9xcxFOnGgb2lCaQZHc/X/NDoDFH9y1KYq6ZolFMONrC9Wv+vVxr
         LLYLIZ7FE7JHiQ5MFP5FQCDnIOVvuPOFLR7ia52gGXvu0t5C3d8k/gsqLpKd4u9wEo
         xE5D+qjWzdOHPFjP4rIKBbxNIxeviJplsKU4rGpO1x1ywcUwZlmfmlEx/0fBgaZDOq
         vHSOx/w3QJzDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35AA7F03842;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: lantiq_gswip: enable jumbo frames on GSWIP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697301321.12732.1511628765770626834.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 04:30:13 +0000
References: <20220308230457.1599237-1-olek2@wp.pl>
In-Reply-To: <20220308230457.1599237-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom@tomn.co.uk
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Mar 2022 00:04:57 +0100 you wrote:
> This enables non-standard MTUs on a per-port basis, with the overall
> frame size set based on the CPU port.
> 
> When the MTU is not changed, this should have no effect.
> 
> Long packets crash the switch with MTUs of greater than 2526, so the
> maximum is limited for now. Medium packets are sometimes dropped (e.g.
> TCP over 2477, UDP over 2516-2519, ICMP over 2526), Hence an MTU value
> of 2400 seems safe.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: lantiq_gswip: enable jumbo frames on GSWIP
    https://git.kernel.org/netdev/net-next/c/c40bb4fedcd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


