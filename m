Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940755006AC
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 09:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbiDNHMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 03:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240311AbiDNHMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 03:12:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD361DED3
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 00:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BE1061F0F
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 07:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7AB3C385AB;
        Thu, 14 Apr 2022 07:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649920211;
        bh=+7WDmCNW+j9GboLoX6w0yhYRBJ4b/nktjNsjxZdcuUo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ej5zssG6lS+YG4qm87crHJg+2ksvPgvuE5FlvtMqeH9GRw2d7l/31gX87lrsFqzHs
         21RmNcftuNWxKQL9ecuCLxvFvL4cyAp2s8avnPQboubVWZ/uNAo42Gy/yDcE2Uqmgb
         v3be9foGeBWUf6iXE4lxLSmgA7ooxTwwxbSO41TEMtxZEzkPX6MDHzJqvxPs3+4Eiu
         oppQ0znF935LSE5+AGtHfXEC9h0ZVuSQ2nQ6+T5KtfnqKyrdT+C11k2YlRWiZNlB4+
         dQbTRdIr3dJJwxjlZkm4Fey2OnpHQusJ/uJoqkx0xWQIXZGJ0KzS/n9aQXHWUPX7va
         5V1R5kdW02VYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA3C9E8DD69;
        Thu, 14 Apr 2022 07:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: fix tagging protocol changes with
 multiple CPU ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164992021169.11214.13963321022424411309.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Apr 2022 07:10:11 +0000
References: <20220412172209.2531865-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220412172209.2531865-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        michael@walle.cc
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 12 Apr 2022 20:22:09 +0300 you wrote:
> When the device tree has 2 CPU ports defined, a single one is active
> (has any dp->cpu_dp pointers point to it). Yet the second one is still a
> CPU port, and DSA still calls ->change_tag_protocol on it.
> 
> On the NXP LS1028A, the CPU ports are ports 4 and 5. Port 4 is the
> active CPU port and port 5 is inactive.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: fix tagging protocol changes with multiple CPU ports
    https://git.kernel.org/netdev/net/c/00fa91bc9cc2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


