Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233FE560FBA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiF3DkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiF3DkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA8013D2A;
        Wed, 29 Jun 2022 20:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E32F46209D;
        Thu, 30 Jun 2022 03:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E705C3411E;
        Thu, 30 Jun 2022 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656560413;
        bh=jDsCvJhPVsSeBQhc8uSr1wOUL3dZenoJpvdsOb0HjSU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MU9qqgFbaj4hFETLjYxIl6x8M5MA+JlayhU7YZlk7pFuRWNCgf1o6/EcVJqIuEX+x
         ryVRtSDISe9TxQS3nSSoY6IoecbiA7nFo/vn4j7hTQnmrb/GXDAI/o5M2ty9Hfapnz
         T/woVssWs2TAdQhUBWqnOrbxd0Ymd39PiyNf2UzIiOzFQ5ayH9XoByiTcucC9COxYA
         Z0kVNKdkmOk5eW2joXFfF59IL1IL3YGVTjCO/8pRT76vPV7n8cHnDrE6SY3WYsxIaC
         GNlQ9NQBhOpY4zubsjcgKD10huFz5sZekb59H7w7a5yRAtMw1aYI0Ktnn4LE4YJxfP
         ooOUy74aW3QXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15FBBE49BBF;
        Thu, 30 Jun 2022 03:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usbnet: fix memory allocation in helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656041308.25608.12257307799959039409.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 03:40:13 +0000
References: <20220628093517.7469-1-oneukum@suse.com>
In-Reply-To: <20220628093517.7469-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 28 Jun 2022 11:35:17 +0200 you wrote:
> usbnet provides some helper functions that are also used in
> the context of reset() operations. During a reset the other
> drivers on a device are unable to operate. As that can be block
> drivers, a driver for another interface cannot use paging
> in its memory allocations without risking a deadlock.
> Use GFP_NOIO in the helpers.
> 
> [...]

Here is the summary with links:
  - usbnet: fix memory allocation in helpers
    https://git.kernel.org/netdev/net/c/e65af5403e46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


