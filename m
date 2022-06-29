Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681CB55F557
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiF2EkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiF2EkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E572C657
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C34DB821AF
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0C57C341CE;
        Wed, 29 Jun 2022 04:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656477612;
        bh=RMpxU5HC0yNZ+kigOTY0Tiw95szIyj+f/D5fp4PPz5Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QJSmpWAqLVHLXP9fzmlKVGYCBojp03fLLesU8kUyx+thYhI2mkl7XeqNy/WilVsSB
         o1cB0J/TNqMzgHYEficIylA0yu/Gne87Ymy7oESmp86h1MJU/dcL3Bz7Qh/odEf2Ov
         Vmrg8JGBROIPQnzCePKYm+SHrIzlJcRL+aYi6pPMSZ5KPOvJnfagtyOMabWPvKCipt
         xeiH67MSK9eALCuPFlEDLafq9Wip2Cv+dgAEvU9gSxLvxZLuz7j7S2R3V1psTFtEDC
         oKLJIEyVwZQwQ51rNpY5mWIg2dUENwlkbLBryD5mnb226Lj0Oh69nLGn3i9Vv045Qj
         UZTtJOrLmKVTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA908E49BB8;
        Wed, 29 Jun 2022 04:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/funeth: Support for ethtool -m
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165647761282.961.2131106581942422381.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 04:40:12 +0000
References: <20220627182000.8198-1-dmichail@fungible.com>
In-Reply-To: <20220627182000.8198-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Jun 2022 11:20:00 -0700 you wrote:
> Add the FW command for reading port module memory pages and implement
> ethtool's get_module_eeprom_by_page operation.
> 
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> ---
>  .../net/ethernet/fungible/funcore/fun_hci.h   | 40 +++++++++++++++++++
>  .../ethernet/fungible/funeth/funeth_ethtool.c | 34 ++++++++++++++++
>  2 files changed, 74 insertions(+)

Here is the summary with links:
  - [net-next] net/funeth: Support for ethtool -m
    https://git.kernel.org/netdev/net-next/c/f03c8a1e33ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


