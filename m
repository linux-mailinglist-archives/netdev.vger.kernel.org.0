Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94BA698BFC
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjBPFa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjBPFaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A448170D
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 21:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA9FBB823E0
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 836F3C433D2;
        Thu, 16 Feb 2023 05:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676525418;
        bh=fVb1AWDI7Y5pbjvKDPwz3K59V7MpwaeoekTk+PeAWzc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=akUD/56/wGuOA6JTbfxb9EQUfKl6Y1EzPKJeMqVzhqjmluCTJ3IIzcOhV351G0E8X
         CK2xuZiVL96X62d519jcBQyY2w+yVEXDKibyl6bgpjK1UakVfV5TEJDUniu5OfigrW
         3A4R7lOqw8+G/byK2sKjwPyAxVxxP/s08GVrGn9zCvc4u7oaxbeqz4b99CQ1z2JLEv
         NfPZBzZzxUKrQU6v3u9rpb7TGgV9fS8tu5SZQr0KRxFQgj0/PMPmQt0x48LuRkhQYi
         vN7rS84/r8r1XJ/SdcK2EX2+VosgigoWye/YapwRiJBNsr8C/4Pj2X9eO5BHmVQTOL
         6vXTZJ6Juo+yA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68059E68D2E;
        Thu, 16 Feb 2023 05:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igb: conditionalize I2C bit banging on external
 thermal sensor support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167652541842.5481.17175752290918342945.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 05:30:18 +0000
References: <20230214185549.1306522-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230214185549.1306522-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, vinschen@redhat.com, netdev@vger.kernel.org,
        jan.kundrat@cesnet.cz, mateusz.palczewski@intel.com,
        jbainbri@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Feb 2023 10:55:48 -0800 you wrote:
> From: Corinna Vinschen <vinschen@redhat.com>
> 
> Commit a97f8783a937 ("igb: unbreak I2C bit-banging on i350") introduced
> code to change I2C settings to bit banging unconditionally.
> 
> However, this patch introduced a regression:  On an Intel S2600CWR
> Server Board with three NICs:
> 
> [...]

Here is the summary with links:
  - [net,1/1] igb: conditionalize I2C bit banging on external thermal sensor support
    https://git.kernel.org/netdev/net/c/5d54cb1767e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


