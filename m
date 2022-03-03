Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905984CBFDD
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbiCCOVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbiCCOVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:21:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02F01405CA
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 594C1B82554
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F27B4C340F3;
        Thu,  3 Mar 2022 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646317213;
        bh=VdY2+K+XPx+N9TxpGlE5NN7d50jIlIUXnN0REGSrS64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cgOut9ikBKU59H9/F2w4BN+Y/GlDxadyvLB9sndwOixr1w5xAezplH9PyXcYsEcMv
         Un879iGkwHtdQVfvvrxr94Ee+s+yXwbICfA/HvtYD/uC9eVlX889YTixgB+ZNhp3Tj
         9NicvDVZRrwGIEhafeak6YPtQIcTEh0JKoIhSPtvfc278AaNCQZG8773S0UcIqkgXe
         Qrrf5eJ5aq+tr5V1yTJ1Qea9JxxMg/Ro5gsosQ3tHZ9MrdciKUiKiyVquN+K2AuP7a
         geRvlTtan5X/ul4ScBgWeKSkSd7qZlPW5Fc9s8cyEstfYjd+H7p15Bsg2jyZfdtIgN
         OQX9JmXBcvZzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D48B2E7BB08;
        Thu,  3 Mar 2022 14:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] ice: add TTY for GNSS module for E810T device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164631721286.14029.15482788606226274969.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 14:20:12 +0000
References: <20220301183803.3004648-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220301183803.3004648-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, karol.kolacinski@intel.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        sudhansu.mishra@intel.com, sunithax.d.mekala@intel.com
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
by David S. Miller <davem@davemloft.net>:

On Tue,  1 Mar 2022 10:38:03 -0800 you wrote:
> From: Karol Kolacinski <karol.kolacinski@intel.com>
> 
> Add a new ice_gnss.c file for holding the basic GNSS module functions.
> If the device supports GNSS module, call the new ice_gnss_init and
> ice_gnss_release functions where appropriate.
> 
> Implement basic functionality for reading the data from GNSS module
> using TTY device.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] ice: add TTY for GNSS module for E810T device
    https://git.kernel.org/netdev/net-next/c/43113ff73453

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


