Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358FF558F65
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiFXEAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiFXEAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B7527D7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 21:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07341620CF
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F487C341CC;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656043214;
        bh=1JFXBWNqsZYiXXYTnth6HiM6GEPVhWRho9w2XhYtHdc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XsfJxT50bKftqGsn+InrPIzVM16uUelyVjnC7ssVGFISJuDQca84A+pcs+CYLXD2C
         e08tLFOfaenZVONHbknoYlhY/3SgZpXHbNzIGpKz29cbd5PUjyqVCfPn7wuZzcRUWf
         uC43qPuSYOpZqqAU2LFXpaoh02aQjQMiRyfG5rqhaKd3hq4ktdASaUARa74yRgfuPJ
         FoC/W4iXwixcHVc1jeZvw/rI7JYOEdOV2FK8SQfH8Rv/cNo3KTg0fK/SnyTx1iuonK
         mViXRy81IZ0jw6yZckDekiSDbZkARhRtjWLOE7QfzeHeuTbBUbt/dUj6c9PutFqIGX
         5jxuK5gCCGO5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24F2AE7BA3C;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v9 0/3] Broadcom PTP PHY support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604321414.27108.17310382374787348185.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 04:00:14 +0000
References: <20220622050454.878052-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220622050454.878052-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, andrew@lunn.ch,
        f.fainelli@gmail.com, richardcochran@gmail.com, l@ssejohnsen.me,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bcm-kernel-feedback-list@broadcom.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jun 2022 22:04:51 -0700 you wrote:
> This adds PTP support for the Broadcom PHY BCM54210E (and the
> specific variant BCM54213PE that the rpi-5.15 branch uses).
> 
> This has only been tested on the RPI CM4, which has one port.
> 
> There are other Broadcom chips which may benefit from using the
> same framework here, although with different register sets.
> 
> [...]

Here is the summary with links:
  - [net-next,v9,1/3] net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
    https://git.kernel.org/netdev/net-next/c/15acf89e1286
  - [net-next,v9,2/3] net: phy: broadcom: Add PTP support for some Broadcom PHYs.
    https://git.kernel.org/netdev/net-next/c/39db6be781cd
  - [net-next,v9,3/3] net: phy: Add support for 1PPS out and external timestamps
    https://git.kernel.org/netdev/net-next/c/7bfe91efd525

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


