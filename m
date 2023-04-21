Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D4C6EA541
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjDUHuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbjDUHul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:50:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C1E6EB6
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A72D64E93
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79477C433D2;
        Fri, 21 Apr 2023 07:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682063430;
        bh=2Tn3zQr7Y9cLJcf5WIJDYbTBlOm8fRhoguS/4BE0BAk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XBA0FldBRcl4kgfKAA9XjbLZHICMr0bI3oqyjRe/6DY10asVJe67QwN6jQIXydcUR
         mSk15tBdd+a6xV/fIMPi/iRdM+GWWqjCAloshdwl8LuaxyZAjo+k3Ke1bEpYVOM/6O
         JT8D2Sd86O8I0q+Iy82cuGb+9YykqpF4R8D1Pd/kF028TSmEQIsh3euThtPAN+ykwv
         Z4apr0SXT8NRYtHR+zRqPSiB4uZi+Smp2PanbZ1NwV1ZKb9bgu/zXr6uUqBeU0yAXS
         bh0syR53jAHEXwlVC0L7mWa4OR0uNguOcHk3dsSm5enBRBsQOyPRWcDnNkbEaaCY8d
         GBvl9smntVzUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57D22C561EE;
        Fri, 21 Apr 2023 07:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v11 net-next 00/14] pds_core driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168206343035.30967.14987352827118974870.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 07:50:30 +0000
References: <20230419170427.1108-1-shannon.nelson@amd.com>
In-Reply-To: <20230419170427.1108-1-shannon.nelson@amd.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org,
        jiri@resnulli.us, simon.horman@corigine.com
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

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Apr 2023 10:04:13 -0700 you wrote:
> Summary:
> --------
> This patchset implements a new driver for use with the AMD/Pensando
> Distributed Services Card (DSC), intended to provide core configuration
> services through the auxiliary_bus and through a couple of EXPORTed
> functions for use initially in VFio and vDPA feature specific drivers.
> 
> [...]

Here is the summary with links:
  - [v11,net-next,01/14] pds_core: initial framework for pds_core PF driver
    https://git.kernel.org/netdev/net-next/c/55435ea7729a
  - [v11,net-next,02/14] pds_core: add devcmd device interfaces
    https://git.kernel.org/netdev/net-next/c/523847df1b37
  - [v11,net-next,03/14] pds_core: health timer and workqueue
    https://git.kernel.org/netdev/net-next/c/c2dbb0904310
  - [v11,net-next,04/14] pds_core: add devlink health facilities
    https://git.kernel.org/netdev/net-next/c/25b450c05a49
  - [v11,net-next,05/14] pds_core: set up device and adminq
    https://git.kernel.org/netdev/net-next/c/45d76f492938
  - [v11,net-next,06/14] pds_core: Add adminq processing and commands
    https://git.kernel.org/netdev/net-next/c/01ba61b55b20
  - [v11,net-next,07/14] pds_core: add FW update feature to devlink
    https://git.kernel.org/netdev/net-next/c/49ce92fbee0b
  - [v11,net-next,08/14] pds_core: set up the VIF definitions and defaults
    https://git.kernel.org/netdev/net-next/c/65e0185ad764
  - [v11,net-next,09/14] pds_core: add initial VF device handling
    https://git.kernel.org/netdev/net-next/c/f53d93110aa5
  - [v11,net-next,10/14] pds_core: add auxiliary_bus devices
    https://git.kernel.org/netdev/net-next/c/4569cce43bc6
  - [v11,net-next,11/14] pds_core: devlink params for enabling VIF support
    https://git.kernel.org/netdev/net-next/c/40ced8944536
  - [v11,net-next,12/14] pds_core: add the aux client API
    https://git.kernel.org/netdev/net-next/c/10659034c622
  - [v11,net-next,13/14] pds_core: publish events to the clients
    https://git.kernel.org/netdev/net-next/c/d24c28278a01
  - [v11,net-next,14/14] pds_core: Kconfig and pds_core.rst
    https://git.kernel.org/netdev/net-next/c/ddbcb22055d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


