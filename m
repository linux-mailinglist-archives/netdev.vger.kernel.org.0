Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F074AA9B5
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380236AbiBEPkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378892AbiBEPkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F605C061353;
        Sat,  5 Feb 2022 07:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CADBB80689;
        Sat,  5 Feb 2022 15:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B50C8C340F4;
        Sat,  5 Feb 2022 15:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644075610;
        bh=kArubcuN+KF9oLo7jM9T0LWsPVKEtgtoY8Difk7e6dc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r1VCRYwcqYrsdMW7ZUQcHoOS8lRBvNe5mKzAar1+9D8KWIbWzYyEFa9tYu32hSqhy
         Nwn6AQ3hxnZYuMaYy7LUBzovjoadvaNRCQtYwP10cR8+JLU9AFd3sFxh+3jt3Iy0z5
         HLmPsJNxDNKZq7OxDSFHA2jtM9radhrJ2NukQNXFrY8dmSJGVtzWOW+/eDzSVS2p7s
         LsNjns1czQ2JaRC5i9jeBAiW8bdMy2OXw844TTcmNNkspxtwu70sXih2lXU21He7Gp
         jYQ74/SPDkH5gbi+CyBHQbLfInyG9fI68lWH3qykvrGEv2LSJS9gHZifGcY2s52Mot
         GbtqJ1MtcAXVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9954AE6D445;
        Sat,  5 Feb 2022 15:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,
 0/2] net: mana: Add handling of CQE_RX_TRUNCATED and a cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407561062.28243.2373896003754860597.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:40:10 +0000
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Feb 2022 14:45:43 -0800 you wrote:
> Add handling of CQE_RX_TRUNCATED and a cleanup patch
> 
> Haiyang Zhang (2):
>   net: mana: Add handling of CQE_RX_TRUNCATED
>   net: mana: Remove unnecessary check of cqe_type in mana_process_rx_cqe()
> 
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next,1/2] net: mana: Add handling of CQE_RX_TRUNCATED
    https://git.kernel.org/netdev/net-next/c/e4b7621982d2
  - [net-next,2/2] net: mana: Remove unnecessary check of cqe_type in mana_process_rx_cqe()
    https://git.kernel.org/netdev/net-next/c/68f831355052

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


