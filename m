Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6907697A15
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbjBOKkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjBOKkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:40:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBBC37F17;
        Wed, 15 Feb 2023 02:40:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E50B8211A;
        Wed, 15 Feb 2023 10:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFABEC4339B;
        Wed, 15 Feb 2023 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676457617;
        bh=6XfvpkS4ktnzBRkhY+HY/ay+Qmpby5+oDivd/EpfJvA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R5HmBC/DtHPMgpOZgyx4pO6599jxLceSMUmzDdDdCgCpNcJzu3nFMOc/jOMBRxMeJ
         s5yJOKqz2qP0CcuiEbfh4KLB3khJ1fU9X5Xon0ksc8dcy9C+exP1Oqsu+cr0dvvLPX
         BsWY7TmzJpypJ7iuSoYSfpojA0D3jCrwRmpSkP+Xy4GEohKAM9hGpWMUdAirFmaSBB
         74Gdd5YuOjtp0EmSTyYMwr/EtUwIrZt9npuLPAcHkFBQCQf7qIay8dUc6Zn4MjKptf
         qe59s2YonKMX4nzIYc0FhN6aPydbJd7w4oud10Qmf9z949zrYtpF0DGP3hnYcswEFF
         zAmkiXoFaU1LA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98809C41676;
        Wed, 15 Feb 2023 10:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: support validated pause and autoneg in
 fixed-link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167645761762.3800.17601944894703381087.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 10:40:17 +0000
References: <20230210154627.19086-1-i.bornyakov@metrotek.ru>
In-Reply-To: <20230210154627.19086-1-i.bornyakov@metrotek.ru>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        system@metrotek.ru
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 18:46:27 +0300 you wrote:
> In fixed-link setup phylink_parse_fixedlink() unconditionally sets
> Pause, Asym_Pause and Autoneg bits to "supported" bitmap, while MAC may
> not support these.
> 
> This leads to ethtool reporting:
> 
>  > Supported pause frame use: Symmetric Receive-only
>  > Supports auto-negotiation: Yes
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: support validated pause and autoneg in fixed-link
    https://git.kernel.org/netdev/net-next/c/894341ad3ad7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


