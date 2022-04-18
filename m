Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0777E504EAD
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiDRKM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 06:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237597AbiDRKMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 06:12:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F68263B0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 03:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01DEA611BF
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 10:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62DC1C385A9;
        Mon, 18 Apr 2022 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650276614;
        bh=Te485GlnCzMbmQvVPeb3o4OX0BpYEYJAWQ2dg5SOsuQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gw29Psq8T8w1vqfsLsKUZ+Wv8FxvGY6pDmEniyi7KVj5xWCDjRA72eN0/FfcSjGXl
         aT+9kjUFPeDFt+TgbULXpEcyR1bU0oeqFXIUY+BflxHELvARD4MEnOYupiKIIPRIt4
         wF4kDDGWbCsIu1ZGKPECdqG23zilr9fuzuos0fm384MniNB/cYLzbI2A7TnPvo1Pb5
         QSJfyA8Qo/uJlwmw1Hf++lYSA0rhQUutjc/KPAWAyFWe5Y9IXA8FQBjXxrxueCiPWH
         QXMeH/1v0bdNMbJwFUGecQHDSsZpKSg0CWgYcKYOY8AB9GxdE5LcVeR2ntukFtowkb
         xFP0f+xvo+uNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47492E8DD85;
        Mon, 18 Apr 2022 10:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/17] Introduce line card support for modular switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165027661428.27278.6733768484429701742.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Apr 2022 10:10:14 +0000
References: <20220418064241.2925668-1-idosch@nvidia.com>
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jiri@nvidia.com, vadimp@nvidia.com,
        petrm@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Apr 2022 09:42:24 +0300 you wrote:
> Jiri says:
> 
> This patchset introduces support for modular switch systems and also
> introduces mlxsw support for NVIDIA Mellanox SN4800 modular switch.
> It contains 8 slots to accommodate line cards - replaceable PHY modules
> which may contain gearboxes.
> Currently supported line card:
> 16X 100GbE (QSFP28)
> Other line cards that are going to be supported:
> 8X 200GbE (QSFP56)
> 4X 400GbE (QSFP-DD)
> There may be other types of line cards added in the future.
> 
> [...]

Here is the summary with links:
  - [net-next,01/17] devlink: add support to create line card and expose to user
    https://git.kernel.org/netdev/net-next/c/c246f9b5fd61
  - [net-next,02/17] devlink: implement line card provisioning
    https://git.kernel.org/netdev/net-next/c/fcdc8ce23a30
  - [net-next,03/17] devlink: implement line card active state
    https://git.kernel.org/netdev/net-next/c/fc9f50d5b366
  - [net-next,04/17] devlink: add port to line card relationship set
    https://git.kernel.org/netdev/net-next/c/b83758598538
  - [net-next,05/17] mlxsw: spectrum: Allow lane to start from non-zero index
    https://git.kernel.org/netdev/net-next/c/bac62191a3d4
  - [net-next,06/17] mlxsw: spectrum: Allocate port mapping array of structs instead of pointers
    https://git.kernel.org/netdev/net-next/c/d3ad2d88209f
  - [net-next,07/17] mlxsw: reg: Add Ports Mapping Event Configuration Register
    https://git.kernel.org/netdev/net-next/c/ebf0c5341731
  - [net-next,08/17] mlxsw: Narrow the critical section of devl_lock during ports creation/removal
    https://git.kernel.org/netdev/net-next/c/adc6462376b1
  - [net-next,09/17] mlxsw: spectrum: Introduce port mapping change event processing
    https://git.kernel.org/netdev/net-next/c/b0ec003e9a90
  - [net-next,10/17] mlxsw: reg: Add Management DownStream Device Query Register
    https://git.kernel.org/netdev/net-next/c/505f524dc660
  - [net-next,11/17] mlxsw: reg: Add Management DownStream Device Control Register
    https://git.kernel.org/netdev/net-next/c/5290a8ff2e11
  - [net-next,12/17] mlxsw: reg: Add Management Binary Code Transfer Register
    https://git.kernel.org/netdev/net-next/c/5bade5aa4afc
  - [net-next,13/17] mlxsw: core_linecards: Add line card objects and implement provisioning
    https://git.kernel.org/netdev/net-next/c/b217127e5e4e
  - [net-next,14/17] mlxsw: core_linecards: Implement line card activation process
    https://git.kernel.org/netdev/net-next/c/ee7a70fa671b
  - [net-next,15/17] mlxsw: core: Extend driver ops by remove selected ports op
    https://git.kernel.org/netdev/net-next/c/45bf3b7267e0
  - [net-next,16/17] mlxsw: spectrum: Add port to linecard mapping
    https://git.kernel.org/netdev/net-next/c/6445eef0f600
  - [net-next,17/17] selftests: mlxsw: Introduce devlink line card provision/unprovision/activation tests
    https://git.kernel.org/netdev/net-next/c/e1fad9517f0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


