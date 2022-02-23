Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A864C1337
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240638AbiBWMuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240632AbiBWMun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:50:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B57A8EC5
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5851AB81F4D
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 12:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA374C340EB;
        Wed, 23 Feb 2022 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645620612;
        bh=tpKJL5r36Np5qblRrmXAazXxEYQ+TmN8ugsvtdjEmhA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jEjj3YVfTFovnx+pJ/3PEDWKNXg1JFkYDSVS1jG7c7Auk52O1eIlYBI81T2ealJTr
         6uzZ8OPiCXiM8aZdtycSH+TAKiArNlI9ab7XYgX1PuExI5a3qIiQoKaIum5Pz8veVU
         9B65SPPsr8gvUQiCoEOxfAxpjsAPfWvfMSOQYVi88f2y8vFx7kBBZohOeOnw/tbBKj
         aTHhiipvEw6/NmihgfuENP5xWVU14Zx/4ogb8B11vm8pWWUoVbRwInGdhY2kWuGie2
         dB9CBJIwjVTY8QTZhD1OW5+DPKsmkTeKPNygvD0WEEgC4mx79QnyGrJ9KgDdst3A8h
         MmAKjqDyZmN+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9B3BE6D4BA;
        Wed, 23 Feb 2022 12:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] mlxsw: Various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562061282.32023.2567919313660541014.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:50:12 +0000
References: <20220222171703.499645-1-idosch@nvidia.com>
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, jiri@nvidia.com, danieller@nvidia.com,
        vadimp@nvidia.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 22 Feb 2022 19:16:51 +0200 you wrote:
> This patchset contains miscellaneous updates to mlxsw gathered over
> time.
> 
> Patches #1-#2 fix recent regressions present in net-next.
> 
> Patches #3-#11 are small cleanups performed while adding line card
> support in mlxsw.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] mlxsw: core: Prevent trap group setting if driver does not support EMAD
    https://git.kernel.org/netdev/net-next/c/c035ea76c4e7
  - [net-next,02/12] mlxsw: spectrum_span: Ignore VLAN entries not used by the bridge in mirroring
    https://git.kernel.org/netdev/net-next/c/42c9135fef9b
  - [net-next,03/12] mlxsw: core_thermal: Avoid creation of virtual hwmon objects by thermal module
    https://git.kernel.org/netdev/net-next/c/f8a36880f474
  - [net-next,04/12] mlxsw: core_hwmon: Fix variable names for hwmon attributes
    https://git.kernel.org/netdev/net-next/c/bed8f4197cb2
  - [net-next,05/12] mlxsw: core_thermal: Rename labels according to naming convention
    https://git.kernel.org/netdev/net-next/c/009da9fad567
  - [net-next,06/12] mlxsw: core_thermal: Remove obsolete API for query resource
    https://git.kernel.org/netdev/net-next/c/bfb82c9cceac
  - [net-next,07/12] mlxsw: reg: Add "mgpir_" prefix to MGPIR fields comments
    https://git.kernel.org/netdev/net-next/c/719fc0662cdc
  - [net-next,08/12] mlxsw: core: Remove unnecessary asserts
    https://git.kernel.org/netdev/net-next/c/af9911c569d5
  - [net-next,09/12] mlxsw: spectrum: Remove SP{1,2,3} defines for FW minor and subminor
    https://git.kernel.org/netdev/net-next/c/8b5f555be8f2
  - [net-next,10/12] mlxsw: core: Unify method of trap support validation
    https://git.kernel.org/netdev/net-next/c/902992d18f5a
  - [net-next,11/12] mlxsw: Remove resource query check
    https://git.kernel.org/netdev/net-next/c/cc4d3de99052
  - [net-next,12/12] mlxsw: core: Add support for OSFP transceiver modules
    https://git.kernel.org/netdev/net-next/c/f881c4ab37db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


