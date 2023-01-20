Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE0F6755CD
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjATNaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjATNaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2388BC3831
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B194D61F6E
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B95AC433A1;
        Fri, 20 Jan 2023 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674221417;
        bh=ram0Jsbg1kYCfpG9+NLpwKTUjxkP/pVPCgS7iwb+u8o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jSFy8Ks2t2gYkWXoifFlESqjDeO7izKnnGiduzB/S+aa6RZPFXqmRwB7Df30a1b9c
         ZufYVbi2kt4XJHvIV9xYbB/aPIeb75xgZwZSNGlZtREMq/pa0LCoHKiQ3SV8oNKjMt
         jxNuqM/bToiRzrpteET8kGUDzoQHMK9zDtsvDWggjlSbNPU7JyyetGRBJOywvw5puZ
         HPLbCGElVhm6/M7izE0s0Nw4iOwhI4a2OZMdwaSddGi7unLaHVfwmakU//2+xO7PzG
         PVVpb4x8iGYg5fuFTjwQG9CgVM8GeGUNs6M52oahiAIAoH6yZxm1CBFOQtmKvqk9B3
         GmiIdttZ3q+Eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7193C395DC;
        Fri, 20 Jan 2023 13:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] ice: use GNSS subsystem instead of TTY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167422141694.18652.7138102508736773253.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 13:30:16 +0000
References: <20230119005836.2068818-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230119005836.2068818-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, arkadiusz.kubalewski@intel.com,
        netdev@vger.kernel.org, johan@kernel.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexandr.lobakin@intel.com, karol.kolacinski@intel.com,
        michal.michalik@intel.com, gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 18 Jan 2023 16:58:36 -0800 you wrote:
> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> 
> Previously support for GNSS was implemented as a TTY driver, it allowed
> to access GNSS receiver on /dev/ttyGNSS_<bus><func>.
> 
> Use generic GNSS subsystem API instead of implementing own TTY driver.
> The receiver is accessible on /dev/gnss<id>. In case of multiple receivers
> in the OS, correct device can be found by enumerating either:
> - /sys/class/net/<eth port>/device/gnss/
> - /sys/class/gnss/gnss<id>/device/
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] ice: use GNSS subsystem instead of TTY
    https://git.kernel.org/netdev/net-next/c/c7ef8221ca7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


