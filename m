Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ACD6BF821
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjCRFuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRFuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D97AD000
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 22:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF24860A36
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BE2BC433EF;
        Sat, 18 Mar 2023 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679118619;
        bh=Z98PTkc26IMJTNCq8NGYiVw8/bP9ssp8WYzgxjteBGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uPonnRZnSzD4vBy9vi/EaSeDt3DFoVO9mL+MOX4hbvWJHKbGyPZU2HuQ9ATyaoKTo
         kho8IYm3g1i6/EYPARf2I2tudWf3CXI3oaulspEIjXf8XrgwtWX/bM9UhRECv0hhHU
         SpNKQhVqFpsmTNL32aylACh8Joi47cNyxPxmfNitEWrlNeJt0wdn+rkfKIyR0JIFES
         /Qn1aCssVzp1JQV8zgJ7RKT0gRNcFMBfafrYqna3OvqO1Kcx4Cd/DPJE75LbrHEy/i
         mRDgdRsAzDwHWLWxzo8a3Ohsb1J2bMzXtdWFbUJq6W2yS4d6PdvjgZiAIpyIK7H+YF
         QhdWzBLaPjKEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 037AAC395F4;
        Sat, 18 Mar 2023 05:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3][pull request] Intel Wired LAN Driver Updates
 2023-03-16 (iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911861901.13068.5722161287367475382.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:50:19 +0000
References: <20230316155316.1554931-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230316155316.1554931-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, leonro@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 16 Mar 2023 08:53:13 -0700 you wrote:
> This series contains updates to iavf driver only.
> 
> Alex fixes incorrect check against Rx hash feature and corrects payload
> value for IPv6 UDP packet.
> 
> Ahmed removes bookkeeping of VLAN 0 filter as it always exists and can
> cause a false max filter error message.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] iavf: fix inverted Rx hash condition leading to disabled hash
    https://git.kernel.org/netdev/net/c/32d57f667f87
  - [net,v2,2/3] iavf: fix non-tunneled IPv6 UDP packet type and hashing
    https://git.kernel.org/netdev/net/c/de58647b4301
  - [net,v2,3/3] iavf: do not track VLAN 0 filters
    https://git.kernel.org/netdev/net/c/964290ff32d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


