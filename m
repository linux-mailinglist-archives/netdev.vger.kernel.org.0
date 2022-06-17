Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B8854F4BE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381458AbiFQKA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381550AbiFQKAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7466971E
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0121B8292E
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F835C3411C;
        Fri, 17 Jun 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655460015;
        bh=ECpDzGvsb/mGZlEI0swezRtq+gew6P9//LtFK62OwRk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=du6UYTQzfqHvkBawYiAbd+oB/HMOC0rdyrYheEXscweY3DZ4+9meFQWV08TbNCHZA
         Xkurftm81B9HJoZf8giABTimiWid2FET2bHz7pVtER/z3hkHKiqAaxlw1wKIJU8CFZ
         Yq6o5s/scMU4aUU/Dz9SSpn3Nx7nndRJEIbSPsrj6QRFHZ5mf6/lhKmmiEjerprftG
         Y7IbfIvuL9yY+l218O/J8mYoeLST8OGMpkXpEFXB2/gVrwgS6q6g/npEjycD3vbgCo
         GTHmWmpS61wXgUHU9VZvLkjLMyumJcQDWW71c52I2JpQCQdOhIM7WxNj9R9cVxMIVJ
         HzeQlnoHPewGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85C09E6D466;
        Fri, 17 Jun 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] mlxsw: L3 HW stats improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546001554.29023.10810591741033095290.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:00:15 +0000
References: <20220616104245.2254936-1-idosch@nvidia.com>
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com
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

On Thu, 16 Jun 2022 13:42:34 +0300 you wrote:
> While testing L3 HW stats [1] on top of mlxsw, two issues were found:
> 
> 1. Stats cannot be enabled for more than 205 netdevs. This was fixed in
> commit 4b7a632ac4e7 ("mlxsw: spectrum_cnt: Reorder counter pools").
> 
> 2. ARP packets are counted as errors. Patch #1 takes care of that. See
> the commit message for details.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] mlxsw: Trap ARP packets at layer 3 instead of layer 2
    https://git.kernel.org/netdev/net-next/c/4b1cc357f843
  - [net-next,02/11] mlxsw: Keep track of number of allocated RIFs
    https://git.kernel.org/netdev/net-next/c/b9840fe035ac
  - [net-next,03/11] mlxsw: Add a resource describing number of RIFs
    https://git.kernel.org/netdev/net-next/c/4ec2feb26cc3
  - [net-next,04/11] selftests: mirror_gre_bridge_1q_lag: Enslave port to bridge before other configurations
    https://git.kernel.org/netdev/net-next/c/e386a527fc08
  - [net-next,05/11] selftests: mlxsw: resource_scale: Update scale target after test setup
    https://git.kernel.org/netdev/net-next/c/d3ffeb2dba63
  - [net-next,06/11] selftests: mlxsw: resource_scale: Introduce traffic tests
    https://git.kernel.org/netdev/net-next/c/3128b9f51ee7
  - [net-next,07/11] selftests: mlxsw: resource_scale: Allow skipping a test
    https://git.kernel.org/netdev/net-next/c/8cad339db339
  - [net-next,08/11] selftests: mlxsw: resource_scale: Pass target count to cleanup
    https://git.kernel.org/netdev/net-next/c/35d5829e86c2
  - [net-next,09/11] selftests: mlxsw: tc_flower_scale: Add a traffic test
    https://git.kernel.org/netdev/net-next/c/dd5d20e17c96
  - [net-next,10/11] selftests: mlxsw: Add a RIF counter scale test
    https://git.kernel.org/netdev/net-next/c/be00853bfd2e
  - [net-next,11/11] selftests: spectrum-2: tc_flower_scale: Dynamically set scale target
    https://git.kernel.org/netdev/net-next/c/ed62af45467a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


