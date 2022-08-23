Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C7259CDE5
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbiHWBaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiHWBaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96565A2DA
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D0D611F4
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE0F4C433B5;
        Tue, 23 Aug 2022 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661218214;
        bh=LVGa1FRzE8KAkbpiy1isG/PeUnUXyhF/rTiEQKHw0mA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CLm88ZAWUclMBe+V8PBuF3OD2qY/IcacZZPA9zum+ijr5bgESMCI1vTg3mEt2n4mW
         rJHTYL/xZXaNffZ2XqTyQizPvENX7ftJ1R71/shdv5ND25v9NdIp58Q4OFvqSuOSBi
         SnqeL4J38pyxuGfNgkaX7EnGtQTqbWvRoiaHd4nfdPqBTBnqgGOTQxYQenUnOkDU53
         6aFK6X5tgsSvx6b8RKSSZOiUfGy5O1L8XrnMsOAAAuXcyjKbtFE8Jpfmxw0JNIGuYv
         acJYl8NTdQyTkF0zzbNpZxG01x075KTqCTlcm13ePAtFRoPz1YxAKHa/3DE4M67NkS
         qjQIE0KIkM4Aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5DA4E2A041;
        Tue, 23 Aug 2022 01:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: moxa: get rid of asymmetry in DMA mapping/unmapping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166121821480.29630.4763945927297799597.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 01:30:14 +0000
References: <20220819110519.1230877-1-saproj@gmail.com>
In-Reply-To: <20220819110519.1230877-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        olteanv@gmail.com
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

On Fri, 19 Aug 2022 14:05:19 +0300 you wrote:
> Since priv->rx_mapping[i] is maped in moxart_mac_open(), we
> should unmap it from moxart_mac_stop(). Fixes 2 warnings.
> 
> 1. During error unwinding in moxart_mac_probe(): "goto init_fail;",
> then moxart_mac_free_memory() calls dma_unmap_single() with
> priv->rx_mapping[i] pointers zeroed.
> 
> [...]

Here is the summary with links:
  - [v2] net: moxa: get rid of asymmetry in DMA mapping/unmapping
    https://git.kernel.org/netdev/net/c/0ee7828dfc56

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


