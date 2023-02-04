Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6DC68A7FA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 04:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjBDDa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 22:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjBDDaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 22:30:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E501A58287;
        Fri,  3 Feb 2023 19:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A62ACE3083;
        Sat,  4 Feb 2023 03:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A3E5C4339C;
        Sat,  4 Feb 2023 03:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675481419;
        bh=1JRPe4xjNZWLtJ/AQQk0YD4tI9TuJJ9WFt1OnnsW5cA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YcqQ4R5hrgFPzMPoAOY60mV6NPTcEz5YWpZB+y1MoCDvlqg8wCYTBf1L7GgyIiYn5
         Ajp4KzE3IhgXR0HFQDCXPUk18jqK0yJRXOcB9nDXSzWFqfbEbiUxH6xDLrwJAmM8+7
         Gh8zj0aTIdMOkeW9hSIDn/kt87KzVJukAuRn6xZBUd9n9yw9Lxu/SkofnG3Nd/1O32
         gXvV+FL8jIquFID3pzs2Uj4Xm582yib60JLsdP3h4U6STBt+wBFNR/ORqsd9CpLNsj
         qO1AuBHJNVBrg80o6KOM5XjWnIBA80vDgVFY0WWFQRDW0gxyThJieZD9bqevzwqDJ/
         Z6fHkzf87yeFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76894E270C4;
        Sat,  4 Feb 2023 03:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] devlink: Move devlink dev code to a separate
 file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167548141948.31101.10238526649161481755.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Feb 2023 03:30:19 +0000
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 2 Feb 2023 16:46:59 +0200 you wrote:
> This patchset is moving code from the file leftover.c to new file dev.c.
> About 1.3K lines are moved by this patchset covering most of the devlink
> dev object callbacks and functionality: reload, eswitch, info, flash and
> selftest.
> 
> Moshe Shemesh (7):
>   devlink: Split out dev get and dump code
>   devlink: Move devlink dev reload code to dev
>   devlink: Move devlink dev eswitch code to dev
>   devlink: Move devlink dev info code to dev
>   devlink: Move devlink dev flash code to dev
>   devlink: Move devlink_info_req struct to be local
>   devlink: Move devlink dev selftest code to dev
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] devlink: Split out dev get and dump code
    https://git.kernel.org/netdev/net-next/c/dbeeca81bd93
  - [net-next,2/7] devlink: Move devlink dev reload code to dev
    https://git.kernel.org/netdev/net-next/c/c6ed7d6ef929
  - [net-next,3/7] devlink: Move devlink dev eswitch code to dev
    https://git.kernel.org/netdev/net-next/c/af2f8c1f8229
  - [net-next,4/7] devlink: Move devlink dev info code to dev
    https://git.kernel.org/netdev/net-next/c/d60191c46ec9
  - [net-next,5/7] devlink: Move devlink dev flash code to dev
    https://git.kernel.org/netdev/net-next/c/a13aab66cbe0
  - [net-next,6/7] devlink: Move devlink_info_req struct to be local
    https://git.kernel.org/netdev/net-next/c/ec4a0ce92e0c
  - [net-next,7/7] devlink: Move devlink dev selftest code to dev
    https://git.kernel.org/netdev/net-next/c/7c976c7cfc70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


