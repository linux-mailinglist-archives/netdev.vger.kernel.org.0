Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B56624F06
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiKKAkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKKAkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC121FFA4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3647361E79
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85FB4C43470;
        Fri, 11 Nov 2022 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668127217;
        bh=dTh8OG8/veHh0QkHqJoFlFpR0qvYB7+UpcJT2wAd7uc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PKSKHWqZbTAiovjjl+0KnVX9HRh5fOWvEZGALEOINzXs0xR0cLbYZxwZ0rOkf2bCJ
         Ox9NtrOhe/lYOUy8M8u0FZeWejCcjEpBOtE6ZNs8KSCKGJzUHsCj4QHiyEY8CT1EDq
         6T/zPHP3U0HYow8AwMfDH1v087d2juZgk0q2rJqrDLWaRtf6MuQnfBNdi1HJ32l0Dh
         JfV9rmbOovt7kuKsB0IfJ1E4qgbllWoLkmp2uc6BZVvV16WauCfZfDxWRr60bDjyXv
         utF+7pQbmjtshGQQwH+P5wY004IN3zbipfapY2P0OqyUfHPuqVde3N+oorMuDzS+VY
         ooPzM/bhsyeng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A586E49FA8;
        Fri, 11 Nov 2022 00:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates
 2022-11-09 (ice, iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166812721743.19097.13974943970350424745.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 00:40:17 +0000
References: <20221110003744.201414-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221110003744.201414-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed,  9 Nov 2022 16:37:42 -0800 you wrote:
> This series contains updates to ice and iavf drivers.
> 
> Norbert stops disabling VF queues that are not enabled for ice driver.
> 
> Michal stops accounting of VLAN 0 filter to match expectations of PF
> driver for iavf.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] ice: Fix spurious interrupt during removal of trusted VF
    https://git.kernel.org/netdev/net/c/f23df5220d2b
  - [net,v2,2/2] iavf: Fix VF driver counting VLAN 0 filters
    https://git.kernel.org/netdev/net/c/0e710a3ffd0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


