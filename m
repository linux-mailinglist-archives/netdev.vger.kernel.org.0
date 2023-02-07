Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7768DBDE
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjBGOmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjBGOlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:41:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F28230DB
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF28E60C66
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 14:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4588DC4339E;
        Tue,  7 Feb 2023 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675780817;
        bh=f4VvTpegzU7vdFsQQguVR0tWEq9qkd7LuLLOubvhDgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aIQ+0UWJ/0mCaPR88ACzxtUXjd+qqrwjJgNFK6HAkZoehoavdlv5KwW6PRv7B526I
         Hq1FR6d9pOQNVpukpEcOBxcurcyQT4by61C6hcmQjspXUQ0IuxBVpXSpn5fc9ErOy+
         XBjBKcxi1OOhcspOpsoimKIG2ABCAElfZfg/TyHE00NEXh3e1rjb2xxYVg+DS52Hcl
         WkGGzdTrud+Qppy2act92MTK6u0oj0NEMEOm8mjAAzJijONIvGV6pO8bwYa9mBCbWV
         9+ybA6QtAMwGrvcokns1j9Z73lhu1aIoTGBAMZg+zDcCbQRpKBKqN3/Ze6jxfhlVKW
         WUzwA6yqORjaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29F34E55F06;
        Tue,  7 Feb 2023 14:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net] devlink: change port event netdev notifier from per-net
 to global
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167578081716.12071.3318312149665722510.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 14:40:17 +0000
References: <20230206094151.2557264-1-jiri@resnulli.us>
In-Reply-To: <20230206094151.2557264-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  6 Feb 2023 10:41:51 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Currently only the network namespace of devlink instance is monitored
> for port events. If netdev is moved to a different namespace and then
> unregistered, NETDEV_PRE_UNINIT is missed which leads to trigger
> following WARN_ON in devl_port_unregister().
> WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
> 
> [...]

Here is the summary with links:
  - [net] devlink: change port event netdev notifier from per-net to global
    https://git.kernel.org/netdev/net/c/565b4824c39f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


