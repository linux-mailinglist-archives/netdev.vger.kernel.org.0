Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663D65F3A8C
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJDAZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJDAZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:25:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B7813D19
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:25:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F20AB818C2
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 00:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE429C433B5;
        Tue,  4 Oct 2022 00:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664843101;
        bh=F8rYkFsBtfOo5uVSPHuLFJo6+bA1ogeLTOBJQq0rlEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YtQomm2mLMq+eYug28rI4/NeqSpEZ6NSuiaWgUoPrV2yomlf1UvHsN3dWNSwrOVna
         yGP8IzlJ6bvK7LtOsYIqbfPD+q008Z+EomC7c1Cq5K/QC1XnNBnm3vBbWf6zSKK0ff
         qk7a7et6QjKKW5FU7+Tov157EjKfLpH5wvOlzyzWFysABJon+jSNuibPIde+CdCD0h
         6m8+NiFzeQoo0RulrOq3WIZu4ojoo8f3Fky/HzL2T7MZPYO+Fq/xmapdISbPpW5oTI
         7L9oEtm9T6FQPBiEaBAkrgK7ZN5gOSa76ANswc3zn/Np0gsTkaxW5ogw/QiH7T/xNb
         kVWicjU6GxUDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 890AFE49FA7;
        Tue,  4 Oct 2022 00:25:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: octeon: fix build after netif_napi_add()
 changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484310155.14032.2805290778017289231.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 00:25:01 +0000
References: <20221002175650.1491124-1-kuba@kernel.org>
In-Reply-To: <20221002175650.1491124-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux@roeck-us.net, liuhangbin@gmail.com,
        mkl@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  2 Oct 2022 10:56:50 -0700 you wrote:
> Guenter reports I missed a netif_napi_add() call
> in one of the platform-specific drivers:
> 
> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c: In function 'octeon_mgmt_probe':
> drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:1399:9: error: too many arguments to function 'netif_napi_add'
>  1399 |         netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
>       |         ^~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] eth: octeon: fix build after netif_napi_add() changes
    https://git.kernel.org/netdev/net-next/c/899b8cd0d392

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


