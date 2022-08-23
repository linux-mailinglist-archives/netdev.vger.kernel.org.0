Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CB159E989
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiHWRcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237450AbiHWRbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:31:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8071A6A4A4
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE174615DD
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F379C433D7;
        Tue, 23 Aug 2022 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661267415;
        bh=lBf9U3M5rqEY6SppznF6hPTHuIGQx4bVdp4XcJ2VATQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TCuanN5v/y+BXiFWwWWBejvIRDwjbBvFDA/IuVP1RITaSLmTbAYwZdwUoEQuuyJ8w
         utyl2zB0vnByXyIrWgkvdnZ60XyuB/l2++TlIawn5JR59bC9LUGTcE8DrWs26lwZxg
         3uKWiMVoZCF5qf28qpe9DpuucdDJQaQN8dulSBSufMTYJyvaSii8wskkFhGrzOmMV8
         OFv5tcCrae/aI5++gEuL18PlXchKLaFMO0HbnOFrLr997O8tPCQN1npploCea5x2Gy
         qOteHsiJ3WkMok79hMcPWC5teR+G7uRYkpAyMP5HUNYSpz+IhNA92SygU1c+ZbLN6t
         2SEkelNtWQUtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 326EBC0C3EC;
        Tue, 23 Aug 2022 15:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: don't dereference NULL extack in
 dsa_slave_changeupper()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166126741519.17387.9920726954282752743.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 15:10:15 +0000
References: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, clement.leger@bootlin.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, saproj@gmail.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 19 Aug 2022 20:39:25 +0300 you wrote:
> When a driver returns -EOPNOTSUPP in dsa_port_bridge_join() but failed
> to provide a reason for it, DSA attempts to set the extack to say that
> software fallback will kick in.
> 
> The problem is, when we use brctl and the legacy bridge ioctls, the
> extack will be NULL, and DSA dereferences it in the process of setting
> it.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: don't dereference NULL extack in dsa_slave_changeupper()
    https://git.kernel.org/netdev/net/c/855a28f9c96c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


