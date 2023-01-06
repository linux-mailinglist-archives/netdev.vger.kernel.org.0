Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4451765FB38
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjAFGKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAFGKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02226B588;
        Thu,  5 Jan 2023 22:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78A1EB81C9C;
        Fri,  6 Jan 2023 06:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 061F5C433F0;
        Fri,  6 Jan 2023 06:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672985416;
        bh=Cach64z5M0knxSqan5nA60Iv5LtmLstDsa9zAlDKzuY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LU2Hdk9hiORJsWSBKr4gKBiXFHaKtChgt8cXtlDFlJct4rbHK3M/8vOjdicf9dwdb
         S6ZN5F26mH/I7kidcIHcc7aOFwrUQ0ZBxshX036Bg6Y62NhWRCZkzriCJ+Ha5/R4Ha
         uU6kLt2q6tdWdAy8bQb2lpg+9M9xhryhYxJGssvUbWhONEErKAzAmfJMJ1jnnCE+Gg
         4Sxx0jgAd3sXooL3VVLEwcHgDIrL+N84vXUXZh/ViZq3VEeOyo+WV+/Y/LWt7eBbF/
         yQgk2FWBk0niPHNWwzfVdO4y5295be7kNjuvPWHSejEQCQ7iK3sx2lxyhiq+xK9YAw
         4iUrQ3zhnk8XQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBA55E21EEB;
        Fri,  6 Jan 2023 06:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: cdc_ether: add support for Thales Cinterion PLS62-W
 modem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167298541589.969.4400590386173666162.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Jan 2023 06:10:15 +0000
References: <20230105034249.10433-1-hui.wang@canonical.com>
In-Reply-To: <20230105034249.10433-1-hui.wang@canonical.com>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        davem@davemloft.net, oliver@neukum.org, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  5 Jan 2023 11:42:49 +0800 you wrote:
> This modem has 7 interfaces, 5 of them are serial interfaces and are
> driven by cdc_acm, while 2 of them are wwan interfaces and are driven
> by cdc_ether:
> If 0: Abstract (modem)
> If 1: Abstract (modem)
> If 2: Abstract (modem)
> If 3: Abstract (modem)
> If 4: Abstract (modem)
> If 5: Ethernet Networking
> If 6: Ethernet Networking
> 
> [...]

Here is the summary with links:
  - net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem
    https://git.kernel.org/netdev/net/c/eea8ce81fbb5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


