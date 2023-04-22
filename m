Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70716EB71F
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDVDkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDVDkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF751BD5
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 20:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26F64644C1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 03:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76E0EC433A4;
        Sat, 22 Apr 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682134820;
        bh=zKdxiN3l95VjKJnOqQI+M39kMRpAPhpHhQw6BDCPz08=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m3UztXMm5jNfAgellJRSpZatiSY+N7/PW+Q0SOXxsRiUm7UZEU4pFV30t8kFHh0a3
         dlDauZ9LO7KEf74Q4rCkiwMrE8L1mGhsHq1FZQp1XjX6uCjoZK2vlyLsdFH2AYHgoy
         BUeqp8CJvEatVJSXZViBDRgJ0LZBgNe7SYu8zePyFbi+tO2XB/7MBjjEiEnlHpLSp5
         IVlPt/ihnep/BDgf9T3TzVWN2pfMH45Dvo5o5vdESmgJ3H0Loyc5vzS98fA4pUQym8
         djW/EgTbRVUodvrpCJulKdX3X8ilyATA6I1hMaSbvoT3hAQmWNwWYCnOgdwPV4yfvS
         4wXtsRZAYd4HQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59990E270E2;
        Sat, 22 Apr 2023 03:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] ixgbe: Multiple RSS bugfixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213482035.27640.5352065668735045838.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:40:20 +0000
References: <20230420235000.2971509-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230420235000.2971509-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, jdamato@fastly.com
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

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 20 Apr 2023 16:49:58 -0700 you wrote:
> Joe Damato says:
> 
> This series fixes two bugs I stumbled on with ixgbe:
> 
> 1. The flow hash cannot be set manually with ethool at all. Patch 1/2
> addresses this by fixing what appears to be a small bug in set_rxfh in
> ixgbe. See the commit message for more details.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ixgbe: Allow flow hash to be set via ethtool
    https://git.kernel.org/netdev/net/c/4f3ed1293feb
  - [net,2/2] ixgbe: Enable setting RSS table to default values
    https://git.kernel.org/netdev/net/c/e85d3d55875f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


