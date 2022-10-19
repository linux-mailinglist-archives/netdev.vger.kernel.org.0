Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00706052CC
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiJSWKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiJSWKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B640125017
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 435ADB82612
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 22:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0335C433C1;
        Wed, 19 Oct 2022 22:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666217420;
        bh=xk6cRbUHDzm/el/vkgFyIt3xPTO2ZBc3A34+ZWtt49M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZMzFFvUVGaXlNAi+zBahoEAKfygvVzrdEaRbYBZ1qVBjkUTei6+uG5fY7/bvm8BdL
         EfIyURrncoxAn0hxX4ER9T+Dqf06VrmbIIwRXHeoUtiAdcKjmcrU0hVGgo3OUZnx2p
         9kccDk0sWqCBJNhEEBnaUYAl/aQIBmOujzTtW2LUdVjT+ZDz3EdxPOXGcGU/N3BNir
         YroeVfT/dGhokBgiOAo4oFyIgk9Rixi31pIjjMpUUqR4C8QrNkYl8CLPrH7T9VJllw
         EptAuMg7CaJE0FvjNI5jHXKAm+q1/FlKM0tN9Fn6QP8QRChFT3r7+paPL9inmNxSM7
         M9ZxWuVS3KAYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7905E4D007;
        Wed, 19 Oct 2022 22:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/3] netlink: formatted extacks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166621741987.14082.13421045521288464984.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 22:10:19 +0000
References: <cover.1666102698.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1666102698.git.ecree.xilinx@gmail.com>
To:     <edward.cree@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        johannes@sipsolutions.net, marcelo.leitner@gmail.com,
        jiri@resnulli.us, ecree.xilinx@gmail.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Oct 2022 15:37:26 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Currently, netlink extacks can only carry fixed string messages, which
>  is limiting when reporting failures in complex systems.  This series
>  adds the ability to return printf-formatted messages, and uses it in
>  the sfc driver's TC offload code.
> Formatted extack messages are limited in length to a fixed buffer size,
>  currently 80 characters.  If the message exceeds this, the full message
>  will be logged (ratelimited) to the console and a truncated version
>  returned over netlink.
> There is no change to the netlink uAPI; only internal kernel changes
>  are needed.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/3] netlink: add support for formatted extack messages
    https://git.kernel.org/netdev/net-next/c/51c352bdbcd2
  - [v3,net-next,2/3] sfc: use formatted extacks instead of efx_tc_err()
    https://git.kernel.org/netdev/net-next/c/ad1c80d5f777
  - [v3,net-next,3/3] sfc: remove 'log-tc-errors' ethtool private flag
    https://git.kernel.org/netdev/net-next/c/b799f052a987

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


