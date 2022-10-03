Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3B5F2FD0
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJCLuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 07:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJCLuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1BF3057B;
        Mon,  3 Oct 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44308B81091;
        Mon,  3 Oct 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E836AC433C1;
        Mon,  3 Oct 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664797815;
        bh=mfrtYBsFiTXSXmbE9rSN3pPn4sSyz0gxr06m4S5/xyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B7/YRFm/wV/Ntl2MwkblZZ8Xmsqi20IeJkBKkGLsCz3z1YbHgF/yggZExl4fchc7W
         Sch9qM5Q0hrMAZtW6jEFfMBSEu19C15vCGTAMmsSSAqXXfcSah32V/zdZjqsiynQJL
         v3HvDQqL5ltfNXdxSMlaNGpQXhVroOT+YvAkXiPEgWKYGwRCySkiiVrJaZOVXJs7on
         nqUTbkXin7WcFFj3byPCtiRxS3p/zLKJRU/DUAs46UDBMejpoJcfpz7aLOLm890xlB
         4ZWaDmCJgBZ2Ngxrvp2SdVUHOmT9ZEwLWdun6/LskVrwCs9TpLByn0L/oKG++ArKNq
         6rDsCRcXLyh9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7CEDE4D013;
        Mon,  3 Oct 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V5] eth: lan743x: reject extts for non-pci11x1x devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479781481.26331.952596663333339021.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 11:50:14 +0000
References: <20220930092740.130924-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20220930092740.130924-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        edumazet@google.com, pabeni@redhat.com,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 30 Sep 2022 14:57:40 +0530 you wrote:
> Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not support
> the PTP-IO Input event triggered timestamping mechanisms added
> 
> Fixes: 60942c397af6 ("net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)")
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
> Changes:
> ========
> V4 -> V5:
>  - Remove the Reviewed-by tag added by me
>  - Correct the Fixes tag subject line
> 
> [...]

Here is the summary with links:
  - [net,V5] eth: lan743x: reject extts for non-pci11x1x devices
    https://git.kernel.org/netdev/net/c/cb4b12071a4b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


