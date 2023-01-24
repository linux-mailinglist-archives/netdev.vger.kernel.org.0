Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0CB679147
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjAXGuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjAXGuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCC92725
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 754D061202
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1EA5C4339B;
        Tue, 24 Jan 2023 06:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674543017;
        bh=LopLXjIxHHyEPex+xAqb5oz95d2CTXkIbjigci22OHU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lYULYzVmKvo3M+/sqlljxVaNRCuUzFi/PgugZVk4BszNio7IsG53p3x2++14BLqJE
         SN7MaUDdaRTFPoFJuSIl6bf5dBxTNPWt3e3j8S8CGn3ChjiiC+E6NP7NKA+pg3kKMn
         zmYCjrtVmJeoZMOS0eotTCxCIXBUkY4xZrkydFlWy/p8Mo5in3SP4ZLlrotU5prLmD
         QvLUzniaiMveZaa+O9AWRV8gDbZPleDYAOf1E2JapKvh8YMQxa8TpVtHt9oSI0ZkSY
         FkW7EgsNXurEPm3N1tztzE+ycDnBObuY0dgA0oHHQdqrMAXeQYRrSq0ATAFktHFWY4
         Tjud/TsEuAQqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B773DC5C7D4;
        Tue, 24 Jan 2023 06:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2023-01-20 (iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167454301774.1018.10031652558855371239.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 06:50:17 +0000
References: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
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

On Fri, 20 Jan 2023 13:10:33 -0800 you wrote:
> This series contains updates to iavf driver only.
> 
> Michal Schmidt converts single iavf workqueue to per adapter to avoid
> deadlock issues.
> 
> Marcin moves setting of VLAN related netdev features to watchdog task to
> avoid RTNL deadlock.
> 
> [...]

Here is the summary with links:
  - [net,1/3] iavf: fix temporary deadlock and failure to set MAC address
    https://git.kernel.org/netdev/net/c/4411a608f7c8
  - [net,2/3] iavf: Move netdev_update_features() into watchdog task
    https://git.kernel.org/netdev/net/c/7598f4b40bd6
  - [net,3/3] iavf: schedule watchdog immediately when changing primary MAC
    https://git.kernel.org/netdev/net/c/e2b53ea5a7c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


