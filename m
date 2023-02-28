Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140E66A6254
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjB1WUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjB1WUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05627DBC;
        Tue, 28 Feb 2023 14:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C207611F4;
        Tue, 28 Feb 2023 22:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4F63C433D2;
        Tue, 28 Feb 2023 22:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677622817;
        bh=ppvw0cxQI4JUhJxcTuOANj+eLyjWJ0rOYMJFU7anKAA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f94cHrYbIQXeA9UEKLVi0Qc/wp7x6VynPGkBe57Z8RWOGW4auwjaXGRfAyumpPtVg
         NDpWgyp4u5kwz3qDUXV5S49XR5O0PQHhykhL5GHtxblkm+5kiy7NEoymgJ8++D73k1
         NYeK75uTZEJi4UXXEFA6zixIhkLJGGwV2T/C9dQKh1r5sHeAkKU4vBBpHkvLed2Pxl
         bD7iAQGR1narZuzteL19aOW9CUwv81VzKXCpWo4y7B0rntXrQY/nhYuTu3N2hyXJIr
         qrAEFJz6pN6/siYbcOwkTaN3d9kihl/x+zew6EtuIUWW0ScLCcPSCOq3jWx7Ysit5a
         Tvqkr6+XT53aA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABF6DC691DE;
        Tue, 28 Feb 2023 22:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] Freescale T1040RDB DTS updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167762281770.1436.1743470013249301155.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Feb 2023 22:20:17 +0000
References: <20230224155941.514638-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230224155941.514638-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        npiggin@gmail.com, christophe.leroy@csgroup.eu, fido_max@inbox.ru,
        bigunclemax@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 24 Feb 2023 17:59:38 +0200 you wrote:
> This contains a fix for the new device tree for the T1040RDB rev A
> board, which never worked, and an update to enable multiple CPU port
> support for all revisions of the T1040RDB.
> 
> Vladimir Oltean (2):
>   powerpc: dts: t1040rdb: fix compatible string for Rev A boards
>   powerpc: dts: t1040rdb: enable both CPU ports
> 
> [...]

Here is the summary with links:
  - [1/2] powerpc: dts: t1040rdb: fix compatible string for Rev A boards
    https://git.kernel.org/netdev/net/c/ae44f1c9d1fc
  - [2/2] powerpc: dts: t1040rdb: enable both CPU ports
    https://git.kernel.org/netdev/net/c/8b322f9fdb35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


