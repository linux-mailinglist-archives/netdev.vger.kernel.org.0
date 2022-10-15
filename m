Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB015FF9D6
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 13:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJOLkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 07:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJOLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 07:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA8339126
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 04:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0409360CEE
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EEFCC433D6;
        Sat, 15 Oct 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665834015;
        bh=HWzOIdm/SXZX57mUR2lF9IlBwqXaNsfG5gQlazsAX14=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kJmyrpxEUYr0l9swkQYcPX1k8aIP0Oky7kUnYWUtwOA38ZYLW447BUrBQm86FAWM9
         6ukBK60mAOXn7GmiEjfIoWglN71Nr0fqAEvBf5chbUOwiS0E7p2LLqkVwEUlkhyQPZ
         xjzwmjNGR4cMmPS2VG4ZKWWqArfse6DelXmID8GfSMBW+fzD2XcfsJ/5lb6iNImD+O
         84Rv9TzjlE1JxF5dK1JfUJ4P5PSDv2Qg1EWjYRiz6uT8GS6KVvYd0U7jfEYOQw+BlQ
         sncToAKBKSVLvIMCeloNZitRuWx0Bz1N+ChBBzsykZiJdMldG8osYhk+gPA51Y4npa
         +n3ZyrQnfcSFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30B4BE4D00C;
        Sat, 15 Oct 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH NET v6 0/2] net: phylink: add phylink_set_mac_pm() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166583401519.3126.7962999627489450739.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Oct 2022 11:40:15 +0000
References: <20221014144729.1159257-1-shenwei.wang@nxp.com>
In-Reply-To: <20221014144729.1159257-1-shenwei.wang@nxp.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Oct 2022 09:47:27 -0500 you wrote:
> Per Russell's suggestion, the implementation is changed from the helper
> function to add an extra property in phylink_config structure because this
> change can easily cover SFP usecase too.
> 
> Changes in v6:
>  - update the fix tag hash and format
> 
> [...]

Here is the summary with links:
  - [NET,v6,1/2] net: phylink: add mac_managed_pm in phylink_config structure
    https://git.kernel.org/netdev/net/c/96de900ae78e
  - [NET,v6,2/2] net: stmmac: Enable mac_managed_pm phylink config
    https://git.kernel.org/netdev/net/c/f151c147b3af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


