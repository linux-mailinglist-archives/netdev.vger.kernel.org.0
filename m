Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202F15258BD
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359645AbiELXuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359642AbiELXuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476B8289BD3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C462B62096
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B9FBC34114;
        Thu, 12 May 2022 23:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652399415;
        bh=yiFBk+kVe+gS7KdVy63OovKKCk7a+28yTR1JOCdhlqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B6Ov0s5evtyn85KuvwA5TJ9p6kIhkQU4aKrY7XJ5dMa9aWTNo5QgFF0drEyeKaWKK
         mvgkuODNw+BuaKUMB42gn+CuKZxu3WnVKinbYkl9mD96nzCIkZHJskeQQdPek1bvQS
         1Xxz7RbwmDuPVBLFXyjttuOu7KXTgWWKpk6cICB9h36nirAnDumctgSG6lcb5zJjX4
         ITfyWx6yEhV83sauLdkeqKQ53iABxNYYYun20TxTtBtIndtkPItZNLt7DmLF/vIzIx
         1WiuyKHY7hMFzTamiKEL8kslBwujPJ8fczCoksSb0XKhFz20HuEyGaNQYlB0OBxZV2
         N7q+nxSXo9QsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F00F6F03935;
        Thu, 12 May 2022 23:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/8] DSA changes for multiple CPU ports (part 1)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165239941497.20203.10953892440196302945.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 23:50:14 +0000
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220511095020.562461-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        tobias@waldekranz.com, kabel@kernel.org, ansuelsmth@gmail.com,
        dqfext@gmail.com, alsi@bang-olufsen.dk, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        colin.foster@in-advantage.com, linus.walleij@linaro.org,
        luizluca@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 12:50:12 +0300 you wrote:
> I am trying to enable the second internal port pair from the NXP LS1028A
> Felix switch for DSA-tagged traffic via "ocelot-8021q". This series
> represents part 1 (of an unknown number) of that effort.
> 
> It does some preparation work, like managing host flooding in DSA via a
> dedicated method, and removing the CPU port as argument from the tagging
> protocol change procedure.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/8] net: dsa: felix: program host FDB entries towards PGID_CPU for tag_8021q too
    https://git.kernel.org/netdev/net-next/c/e9b3ba439dcb
  - [v2,net-next,2/8] net: dsa: felix: bring the NPI port indirection for host MDBs to surface
    https://git.kernel.org/netdev/net-next/c/0ddf83cda5a6
  - [v2,net-next,3/8] net: dsa: felix: bring the NPI port indirection for host flooding to surface
    https://git.kernel.org/netdev/net-next/c/910ee6cce92f
  - [v2,net-next,4/8] net: dsa: introduce the dsa_cpu_ports() helper
    https://git.kernel.org/netdev/net-next/c/465c3de42b5d
  - [v2,net-next,5/8] net: dsa: felix: manage host flooding using a specific driver callback
    https://git.kernel.org/netdev/net-next/c/72c3b0c7359a
  - [v2,net-next,6/8] net: dsa: remove port argument from ->change_tag_protocol()
    https://git.kernel.org/netdev/net-next/c/bacf93b05619
  - [v2,net-next,7/8] net: dsa: felix: dynamically determine tag_8021q CPU port for traps
    https://git.kernel.org/netdev/net-next/c/c352e5e8e8f2
  - [v2,net-next,8/8] net: dsa: felix: reimplement tagging protocol change with function pointers
    https://git.kernel.org/netdev/net-next/c/7a29d220f4c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


