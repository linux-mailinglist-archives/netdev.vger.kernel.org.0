Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E694E4B16A7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 21:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242835AbiBJUAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 15:00:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240562AbiBJUAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 15:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889AB1AB
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 12:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E341B8273D
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 20:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7F40C340EB;
        Thu, 10 Feb 2022 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644523211;
        bh=aGzxvJTZG8hQDrbDQvcN9Dhac+B/ALA4FOjcCKJqooQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SL8QAlJOmFiQCk1lkBuRWgl+Cll/7GBxpsqoscYCXcW+87SWN3SLmD45/P+hfAujr
         Zy4rv5x47UhUev+mIPZHq4K1NwNQHqKHzwAYB4Mxexd9JF/atKFQqZoMsdqoRQAGb4
         P6oska4QY1vjksx9iF/6WS/lf/LBnL+7kI7raI5Uf0dnpwbXKeH48kcNXwcyfY8Apl
         mThK8vB+kyzNDwrEzZk0aHdeywufM/HtxwVwtfo0W5diXoIo7p+X5w6F6Kr4RsB4ja
         UqpWYxC5dJ9lP+RhtM9C7/DkIos5m1LE9K19Srjaps1OgUn+Od6hHLIW8/KL4jT/TC
         OqvhyLhCgOk0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD14FE6D3DE;
        Thu, 10 Feb 2022 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-02-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164452321083.17968.6545148739670700002.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 20:00:10 +0000
References: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 10 Feb 2022 09:05:11 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Dan Carpenter propagates an error in FEC configuration.
> 
> Jesse fixes TSO offloads of IPIP and SIT frames.
> 
> Dave adds a dedicated LAG unregister function to resolve a KASAN error
> and moves auxiliary device re-creation after LAG removal to the service
> task to avoid issues with RTNL lock.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ice: fix an error code in ice_cfg_phy_fec()
    https://git.kernel.org/netdev/net/c/21338d58736e
  - [net,2/4] ice: fix IPIP and SIT TSO offload
    https://git.kernel.org/netdev/net/c/46b699c50c03
  - [net,3/4] ice: Fix KASAN error in LAG NETDEV_UNREGISTER handler
    https://git.kernel.org/netdev/net/c/bea1898f65b9
  - [net,4/4] ice: Avoid RTNL lock when re-creating auxiliary device
    https://git.kernel.org/netdev/net/c/5dbbbd01cbba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


