Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BD7597DFF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243438AbiHRFUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243167AbiHRFUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B49A7D1D7
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4478B820C2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9900BC433D7;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660800017;
        bh=RfvVceix08rdqgd3pt/c7aUSqvA2gSHVZ7wqzYhsGYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b98tiB6xcI+weAU/+/KTK9fqKhPwjSTdvVOf/8FzK2r4RBHLnveUwnfe6AN6fXAYK
         j1Jl+q6qZt4vltnT9ZZNxOHz1ATgm6LM+M7j/kZKtLIoUiKvW8EBgRnspD4CoEOy6L
         aMW3kD8YUdMwo5XyOSVHKpUtfgr0Ib79jvlSh0ISxTKykDlOfeSzs9bI5Ky81U0yLx
         cTSPNGPDZgKiK613qK0nWY1IFdQfOowrIij8B1aQnyg2wr30/+BhRROjCSla/BhY7Y
         Ukj0zJ8OweM3Dprix8j/FgoniPMjBEgMjdTat8J5/ztGqmUcii8tLUtobnStV52mXF
         9OTW44x973q6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83C60E2A055;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: don't warn in dsa_port_set_state_now() when
 driver doesn't support it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166080001753.8479.2546456092819161388.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 05:20:17 +0000
References: <20220816201445.1809483-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220816201445.1809483-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, saproj@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Aug 2022 23:14:45 +0300 you wrote:
> ds->ops->port_stp_state_set() is, like most DSA methods, optional, and
> if absent, the port is supposed to remain in the forwarding state (as
> standalone). Such is the case with the mv88e6060 driver, which does not
> offload the bridge layer. DSA warns that the STP state can't be changed
> to FORWARDING as part of dsa_port_enable_rt(), when in fact it should not.
> 
> The error message is also not up to modern standards, so take the
> opportunity to make it more descriptive.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: don't warn in dsa_port_set_state_now() when driver doesn't support it
    https://git.kernel.org/netdev/net/c/211987f3ac73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


