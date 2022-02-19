Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F234BC956
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242655AbiBSQki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:40:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242629AbiBSQkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFF91D178B;
        Sat, 19 Feb 2022 08:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A3B1B80BEB;
        Sat, 19 Feb 2022 16:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94BE0C340EF;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645288811;
        bh=X/kxOCcThSRqIZcPFK+Z3GKfVTxcm612QscjgtLtwXE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ilP/YOxhjz9OfWysXj4zcGzUD9Ij8CfA1pJAd/Q3bb6k+ACCWwNwBt++Yj2wo6QWz
         4afs3I85sgAHYwSFNYrITHIJTAm+VfpD75aiCxBJKK7BC1X9TCDKo9Qj0o69uQPtKW
         B/xePY38aV93bjM3c4Y6nx5Xz4PzmVJf7aofqnYX+k/fgmpeWuUxyo5pHsySiCtgJS
         ynQ12BmcJ26mWuc8of7CX5K7QCJqDf+rSdtDJa0mb/W4TRfMDjWN+dz6M/oWVw9dRU
         fnB8NSMoUDVRba9k0EYXjvvIrH0WrtXh5Y1lWhwV0RL/Oz7MIVMv2O9T1ywgXkTm7e
         AsuVNxGJ/ZAmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BCE9E7BB18;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/2] MCTP I2C driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528881150.6364.7423694364094851793.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:40:11 +0000
References: <20220218055106.1944485-1-matt@codeconstruct.com.au>
In-Reply-To: <20220218055106.1944485-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     davem@davemloft.net, kuba@kernel.org, jk@codeconstruct.com.au,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        zev@bewilderbeest.net
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

On Fri, 18 Feb 2022 13:51:04 +0800 you wrote:
> This patch series adds a netdev driver providing MCTP transport over
> I2C.
> 
> I think I've addressed all the points raised in v5. It now has
> mctp_i2c_unregister() to run things in the correct order, waiting for
> the worker thread and I2C rx to complete.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/2] dt-bindings: net: New binding mctp-i2c-controller
    https://git.kernel.org/netdev/net-next/c/6881e493b08f
  - [net-next,v6,2/2] mctp i2c: MCTP I2C binding driver
    https://git.kernel.org/netdev/net-next/c/f5b8abf9fc3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


