Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407B763C60D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbiK2RDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbiK2RCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:02:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993AA6DCC6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31D726186D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8939DC43142;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669741218;
        bh=LbvpLsjDuDLEbSLPNXvZeoAK1EgCqC/1EyhEY2aWpqU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NUYuyEFup0zvyAr+tVzwqN6N9XiK2dK+EmGJfemfqpSP+1HLaXUzlXgyM7qsRLPBl
         8rLk+mStnAAM65FvUy6t8fXDNjzDHnzOOTx+UoIA+8WHYwj+rZeMk3KEFNyJxo3mDL
         XZt/O2CD6YA9FA6HWN6tDjNz/yuijftL7oUPGdIp1ei7mIPdrOmEEhuI9WiOJXLJ5y
         zF8fiY9GK3m1cQY3G7prX7XXdz4iawylDNHsCoAWVI0c43NTXVHjA2J/pcYwzkOaID
         W9u9V58zBFWc+3h+ORMjuVcrPLxDW2RRCO2CmFiPy/xJF9CiIsPW4HqVRgu+YuSSyw
         KrdA9WBcZRklw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66E32E52556;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] ionic: update MAINTAINERS entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166974121841.7750.16992202069668452487.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 17:00:18 +0000
References: <20221129011734.20849-1-shannon.nelson@amd.com>
In-Reply-To: <20221129011734.20849-1-shannon.nelson@amd.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, drivers@pensando.io
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

On Mon, 28 Nov 2022 17:17:34 -0800 you wrote:
> Now that Pensando is a part of AMD we need to update
> a couple of addresses.  We're keeping the mailing list
> address for the moment, but that will likely change in
> the near future.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> 
> [...]

Here is the summary with links:
  - [v2,net] ionic: update MAINTAINERS entry
    https://git.kernel.org/netdev/net/c/91a2bbfff3e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


