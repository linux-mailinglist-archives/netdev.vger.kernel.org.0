Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D0450DD29
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbiDYJxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbiDYJx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAC53EF21
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 02:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2342961580
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 844EEC385AB;
        Mon, 25 Apr 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650880215;
        bh=UiMxMilEbYYR6yuAuSr7r3Z04jh6WAIQhyuZdAgySWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AqqESvZtNWRYNjMeebgV1A72x1r+N+sfeZy9gHV0MbkVdscX6INfNJF4EtsyFdTEl
         tfKmxlZ7W5BJaAlKpOUGY7yxdznGAWrb2yxIX/G3ivTrqC85S2RjXZzyZvSqkv3ptg
         ewuaRCaTxSVV3CrggNisi0Nohz5qQB32Rod/ByqGED0FXgFbocRGmQO8Zms4j3YSOr
         MYOJ0bNyb5epML4TIHtH2Z+bOgJV/FkVn/DGTFShH0A5yxkLANmZaKXBfEW2T7Qe3N
         qwWHTddJdvTqRyRNKtIbU/2ObdUG5lqUA4L7U4tdQ4u5zuhDxfMxIeQhF6f81Ikt/p
         bygipP4f9fbag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72AC3E6D402;
        Mon, 25 Apr 2022 09:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices and
 info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088021546.12536.11360043399780328498.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 09:50:15 +0000
References: <20220425034431.3161260-1-idosch@nvidia.com>
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jiri@nvidia.com, petrm@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Apr 2022 06:44:20 +0300 you wrote:
> Jiri says:
> 
> This patchset is extending the line card model by three items:
> 1) line card devices
> 2) line card info
> 3) line card device info
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] devlink: introduce line card devices support
    https://git.kernel.org/netdev/net-next/c/8d92e4fbcf0f
  - [net-next,02/11] devlink: introduce line card info get message
    https://git.kernel.org/netdev/net-next/c/276910aecc6a
  - [net-next,03/11] devlink: introduce line card device info infrastructure
    https://git.kernel.org/netdev/net-next/c/28b2d1f1ac41
  - [net-next,04/11] mlxsw: reg: Extend MDDQ by device_info
    https://git.kernel.org/netdev/net-next/c/798e2df5067c
  - [net-next,05/11] mlxsw: core_linecards: Probe provisioned line cards for devices and attach them
    https://git.kernel.org/netdev/net-next/c/8e2e10f65112
  - [net-next,06/11] selftests: mlxsw: Check devices on provisioned line card
    https://git.kernel.org/netdev/net-next/c/5e2229891825
  - [net-next,07/11] mlxsw: core_linecards: Expose HW revision and INI version
    https://git.kernel.org/netdev/net-next/c/3b37130f4855
  - [net-next,08/11] selftests: mlxsw: Check line card info on provisioned line card
    https://git.kernel.org/netdev/net-next/c/08682c9e58cd
  - [net-next,09/11] mlxsw: reg: Extend MDDQ device_info by FW version fields
    https://git.kernel.org/netdev/net-next/c/c38e9bf33812
  - [net-next,10/11] mlxsw: core_linecards: Expose device FW version over device info
    https://git.kernel.org/netdev/net-next/c/e932b4bdbd7c
  - [net-next,11/11] selftests: mlxsw: Check device info on activated line card
    https://git.kernel.org/netdev/net-next/c/002defd576a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


