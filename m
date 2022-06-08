Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587E8542659
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiFHGAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243016AbiFHFyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:54:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62BD39181A;
        Tue,  7 Jun 2022 20:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDDF6B82581;
        Wed,  8 Jun 2022 03:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB779C341C0;
        Wed,  8 Jun 2022 03:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654660213;
        bh=Pzo1qS4dLFSya8BwxSFVdwOB54vrcuvErReAICds9fY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=syi90ZlEgUbERqFzV0dDHhLN/LWp+rvL+/8bP53VfwWZ7arlMd1Hr4CdND6rKENQT
         zPOznWHwelRQrF2zQ+DuQrhyZQiweN4uPkbFqjV5q+svkKKKeHT1VMyNutDEdUlra+
         Ek9V8nYU5syFlpYCEu2JvzZjOUgjEf02eKF4WS6XLRJ+8AJIkSKkV23XFD5lgdeG+v
         WvGj78P5yh6pH6O9G47sJWG+OV3Wqit/OnOsfhwuXcrZs9ti1nUrIS/t8di1iyT2le
         L2luGV7woWYaPZJ687/xCUAGzJ+ZVvBJnw55K6/dolLs0d17Gbm3x0Js19v6JPYvSX
         90FI+TioPzTJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92A3CE737F4;
        Wed,  8 Jun 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: lantiq_gswip: Fix refcount leak in
 gswip_gphy_fw_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165466021359.10912.7788070039284246103.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 03:50:13 +0000
References: <20220605072335.11257-1-linmq006@gmail.com>
In-Reply-To: <20220605072335.11257-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun,  5 Jun 2022 11:23:34 +0400 you wrote:
> Every iteration of for_each_available_child_of_node() decrements
> the reference count of the previous node.
> when breaking early from a for_each_available_child_of_node() loop,
> we need to explicitly call of_node_put() on the gphy_fw_np.
> Add missing of_node_put() to avoid refcount leak.
> 
> Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list
    https://git.kernel.org/netdev/net/c/0737e018a05e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


