Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CB34D4082
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbiCJFBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239461AbiCJFBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:01:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E75612D914
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BBA5B824CF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 05:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9D2BC340EB;
        Thu, 10 Mar 2022 05:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646888411;
        bh=AEXFh4/wlrfB2aRs9dMBk9fQiw1Z5lw8taAFza/A2eQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MHEG+RsGhOQlyTFX5xMrFuabRVAfECHqbBKiheUpwnu2YD2GC6v0dsXlrDNigVtI8
         23jdDaOnnbaNGuniZuvFe8yIIpZgVIaYQivkz+s5Qc4eNL1pF6kYGQCYtpzcMJe3qP
         cmF2dqkGu9wehKi3SiF7sXaH7i9nKjlZSbK03pe2wtrL7FkGfzlI1nAVWPPXp16qWR
         vs9rzVvbxacvr8Bh8Vl96tGTAFggGp2d0muOcOER2Mk3uKPNlWv8sIxFxQQ6v67e9w
         o3dLcGA+HpDa1CVZR//xBFfYdJTVpv/vN7mzQDJ1EFvOtLsjqALaFiJF9rXkAAGNx6
         tw2qLwfvBvK3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97C37EAC095;
        Thu, 10 Mar 2022 05:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: axienet: Use napi_alloc_skb when refilling RX
 ring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688841161.28597.7017946950287132937.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 05:00:11 +0000
References: <20220308211013.1530955-1-robert.hancock@calian.com>
In-Reply-To: <20220308211013.1530955-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, jwiedmann.dev@gmail.com
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

On Tue,  8 Mar 2022 15:10:13 -0600 you wrote:
> Use napi_alloc_skb to allocate memory when refilling the RX ring in
> axienet_poll for more efficiency.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: axienet: Use napi_alloc_skb when refilling RX ring
    https://git.kernel.org/netdev/net-next/c/6c7e7da2e0f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


