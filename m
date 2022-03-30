Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D01D4ECD40
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350743AbiC3TcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350741AbiC3TcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:32:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839611929A;
        Wed, 30 Mar 2022 12:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D266B614F0;
        Wed, 30 Mar 2022 19:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8743BC340F3;
        Wed, 30 Mar 2022 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648668612;
        bh=8onKiBYlVNpLQTNxcJtyuKnNPZLikBvRjBdmcyWb0x8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I4089kO3GFzMWh/yZDm+5ewjhUvy5jrBUQmM/kCEBG+EAazB+UkvrJpqniJli4dN/
         vPpZ3kugXVxMhFNjGjGDxzxLZ50pgCBMk5YcSWA0sEtkEIYIrtrc+wDv8rfd7U7oWr
         wHaGAoWHfXwpHhOD+wcXhMHpPwXHS6kGC/phFZ3Dcv21yJVVXibTJlUNpD1fbWW3Eb
         RjxKj6/M7l5ryLn+s9vsnQOmPILI7UCxNxufCJDJt+IoaTxtGzljpDxLq2Rz2jwROX
         ag6N3Ty+gVpzr4e0Jy/r+jjpA78CQ43Ok/lqc/Ieu75mDzOAUJbZjWfJGZHOmeg0cZ
         LpzKRPqva1xtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C380E6BBCA;
        Wed, 30 Mar 2022 19:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: felix: fix possible NULL pointer dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164866861243.12292.10767729029354514539.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Mar 2022 19:30:12 +0000
References: <20220329090800.130106-1-zhengyongjun3@huawei.com>
In-Reply-To: <20220329090800.130106-1-zhengyongjun3@huawei.com>
To:     zhengyongjun <zhengyongjun3@huawei.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
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

On Tue, 29 Mar 2022 09:08:00 +0000 you wrote:
> As the possible failure of the allocation, kzalloc() may return NULL
> pointer.
> Therefore, it should be better to check the 'sgi' in order to prevent
> the dereference of NULL pointer.
> 
> Fixes: 23ae3a7877718 ("net: dsa: felix: add stream gate settings for psfp").
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: felix: fix possible NULL pointer dereference
    https://git.kernel.org/netdev/net/c/866b7a278cdb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


