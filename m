Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C99F5FC1E0
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiJLIVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiJLIUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21890AA3F7;
        Wed, 12 Oct 2022 01:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A0C261458;
        Wed, 12 Oct 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B17AC433C1;
        Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665562816;
        bh=TQ1OmF/oP4qYTQrpS4gOqgsinfFbOgwsgGnL/eJfDr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eU82oOwmXo7Wt8iOke77uZF9vs+Y/v5r0cqRG3iHNWmLAupG8m6cuoNIj05aYDHcU
         W4GObl4RyPF9WQqmOLfbxO5m0h3c1UHfyoYgYLlFEKT9I0nFTz8egNGdQtrqWb0zMA
         miY5U5wFMEZfitgxeEopkb8C80mCD3nYBMJTfbi4idLIzLkzDobQ8JVFwbr7/iiW8G
         g0BVpRNR5esWFgbzxrQSLEUOavLBqHsuIMqdKEVeFZpsRrdWUuTscCopirIJSbsEJO
         0W1ffJoHu2RTrTOPoefVNj5FiUX06WjQCtqJgYQ3tPQ8CXy56uq1xiuNFOOgKBfJq/
         Svj/CwQRd0FhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E85DE4D00C;
        Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: set correct devlink flavour
 for unused ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166556281625.4495.12938019302652198027.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Oct 2022 08:20:16 +0000
References: <20221011075002.3887-1-matthias.schiffer@ew.tq-group.com>
In-Reply-To: <20221011075002.3887-1-matthias.schiffer@ew.tq-group.com>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, s-vadapalli@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Tue, 11 Oct 2022 09:50:02 +0200 you wrote:
> am65_cpsw_nuss_register_ndevs() skips calling devlink_port_type_eth_set()
> for ports without assigned netdev, triggering the following warning when
> DEVLINK_PORT_TYPE_WARN_TIMEOUT elapses after 3600s:
> 
>     Type was not set for devlink port.
>     WARNING: CPU: 0 PID: 129 at net/core/devlink.c:8095 devlink_port_type_warn+0x18/0x30
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: ti: am65-cpsw: set correct devlink flavour for unused ports
    https://git.kernel.org/netdev/net/c/7e777b1b012e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


