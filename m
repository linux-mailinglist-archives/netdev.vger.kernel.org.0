Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119F852B98E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbiERMAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbiERMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4694179C3A
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AEB360F33
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79EAEC34100;
        Wed, 18 May 2022 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652875214;
        bh=ItQAV1tgp6gwhwzTWENpYn0w2+ocOavq2pq2WYYFTfM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VRe06/3yf6lCB6nVgyD0xZgfy+oQR0KZZSEIjWRzcuhjEQcMaRz82nTvmcd9Gr3J+
         TZ0Za7NXyGyi4IfDsSj03orkYlvaK+XmPD6s+S3DGz4F7/IHJVxMMUTlXE5ijO2jMC
         FRGk+imlmlGvBNESkQtUGmlx1Zh6P+bZb9OMM58U/OO8c1JW4ZnIeTp4b4mWC92sY4
         lqCOSy74lmZmC3JxEfNhOAx2/rvuovcLMkgRsWgDaBcU4Mb38rZghNRQ7NgH5hi/Fg
         KQ1sLhmISFsXnHY/2f9eD31W/V+6Pgg7vd3efj9BW9c+gPYVg76Ocg8vtxguZo+Gw7
         VkDcKMqE3CQ+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A723F0393B;
        Wed, 18 May 2022 12:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2022-05-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287521436.18230.7415025900469719681.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 12:00:14 +0000
References: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        richardcochran@gmail.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 17 May 2022 10:45:44 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Arkadiusz prevents writing of timestamps when rings are being
> configured to resolve null pointer dereference.
> 
> Paul changes a delayed call to baseline statistics to occur immediately
> which was causing misreporting of statistics due to the delay.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ice: fix crash when writing timestamp on RX rings
    https://git.kernel.org/netdev/net/c/4503cc7fdf9a
  - [net,2/3] ice: fix possible under reporting of ethtool Tx and Rx statistics
    https://git.kernel.org/netdev/net/c/31b6298fd8e2
  - [net,3/3] ice: Fix interrupt moderation settings getting cleared
    https://git.kernel.org/netdev/net/c/bf13502ed5f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


