Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574E068B876
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjBFJUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjBFJUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5044C2C;
        Mon,  6 Feb 2023 01:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84EC960DBC;
        Mon,  6 Feb 2023 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9B5BC433A0;
        Mon,  6 Feb 2023 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675675218;
        bh=sFHJsCIv6APZjKAZbKQHciXAKXWG3v01FwOAYkcfDBY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ShYUo4xz097X61miwHCeqfZ8WejCqeIatuogM7D9Wi7UqtAlLsGIB2gV/LV+EHWQW
         UQW/ib5ManST9M/bD8NHNzk2nxgnK5CBhwzswiFbgO9n2xqE0KCAEOk6CyZlCwEc+P
         xP1z11EX1DwJnPB9nHWdXF0dTsObqjXXsRCgfYjVtkD+jm9xfYEZEUyQMX060loiSy
         85UKHV5TESl+reeqJEbRsYV8ZYd5K9CvMQQ+Xtf2xv+LEW5clUjCEPmpVPxwkb+e+o
         4AEPiiiYwUaDyzBzo5fuM/0o2OjHDU7usBMIP3WQd6T9BlzUoiqxhhPrpm+X8Lim5T
         b19YzIq1utkMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A339DE55EFD;
        Mon,  6 Feb 2023 09:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: page_pool: use in_softirq() instead
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567521866.4325.3118293660232321249.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 09:20:18 +0000
References: <20230203011612.194701-1-dqfext@gmail.com>
In-Reply-To: <20230203011612.194701-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, nbd@nbd.name
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  3 Feb 2023 09:16:11 +0800 you wrote:
> From: Qingfang DENG <qingfang.deng@siflower.com.cn>
> 
> We use BH context only for synchronization, so we don't care if it's
> actually serving softirq or not.
> 
> As a side node, in case of threaded NAPI, in_serving_softirq() will
> return false because it's in process context with BH off, making
> page_pool_recycle_in_cache() unreachable.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: page_pool: use in_softirq() instead
    https://git.kernel.org/netdev/net-next/c/542bcea4be86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


