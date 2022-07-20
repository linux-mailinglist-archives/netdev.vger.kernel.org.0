Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B7057B3D9
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiGTJa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235990AbiGTJaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2A120BE0;
        Wed, 20 Jul 2022 02:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D93E561B3C;
        Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 382EBC341C7;
        Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658309421;
        bh=uW2wvPc0MTR/lHlk/Kks289UXX6rNoiNDOfbuCbBjzU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LBJXFffvroA3BkliuipUs4oPthXLPyuaZRwE1sUrF/iOvRJh1q3u+qChQ+hmRd59s
         hywUeZfir53UYuWbFzVIkGj334+mSK84y4fmU7Qfxuu1Lj6DmbS2c9WhY1FZpK3OrW
         aQzJDDm2YYif0Kx157PbKVOdZyKGp+QaHz1AQ9dhRuRsDwAzdbHKkd6m0y9MyDzE3a
         goYXkjh/oOzk24eP/Si2hd4gB+tXhRNvK5vC1bjqgdzxKcsfZv+ebY+UALhEig6sjA
         MSqOhIqH39ddcEOxrQ5eH3Ubj6MGFoBjd7tc5yM7Ws9BuZu4Ffpf2wtV92gKIl3JyE
         3oX319q8Row4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18B77E451AD;
        Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V5 net-next] net: marvell: prestera: add phylink support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165830942109.20880.12654941413277044286.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 09:30:21 +0000
References: <20220719105716.19692-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20220719105716.19692-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu, linux@armlinux.org.uk, andrew@lunn.ch
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Jul 2022 13:57:16 +0300 you wrote:
> For SFP port prestera driver will use kernel
> phylink infrastucture to configure port mode based on
> the module that has beed inserted
> 
> Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> 
> [...]

Here is the summary with links:
  - [V5,net-next] net: marvell: prestera: add phylink support
    https://git.kernel.org/netdev/net-next/c/52323ef75414

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


