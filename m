Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F3D4B3B38
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 13:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiBMMAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 07:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiBMMAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 07:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F935B8AC
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 04:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE40761128
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 12:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 587BBC340EF;
        Sun, 13 Feb 2022 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644753610;
        bh=Aku4prQUIPszsSAdIbDCocPaTkt81+RQ5/uN46sY6rQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NY9yYou7WHjUUOUxmhUGd1pbdYmeIqbpGg/9jXQ9Im5LuaUoKQvj0+Ntj+erOh2I8
         PveJASKt33A93MZfXfy6DwIVzecDFppBTYqxmP4iXkYkRVRAFQJ04tdKu98o76TgSq
         h6KYn0jbqL9MXyzVFv0ZX0mt1lTsqOdFpNClb/0LB1M12Sw4uNazSH6sgoh7PZcSWr
         eX5ldA4mBG8RGmzm6UD3BSFYpAdaLrlV5qiVS5e1WPzp4qC/Sn6/6v+iy0VaNUgzJi
         w7Ipi+w00ECwtgqxpqmy3xpWMj+m8LWh1wc/j/MxIB/5t2Ut07vU4mpnEKwWATccx3
         urRX4Cqfx9FyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4119EE6BBD2;
        Sun, 13 Feb 2022 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: iosm: Enable M.2 7360 WWAN card support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164475361026.6074.6669930273206471588.git-patchwork-notify@kernel.org>
Date:   Sun, 13 Feb 2022 12:00:10 +0000
References: <20220210153445.724534-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20220210153445.724534-1-m.chetan.kumar@linux.intel.com>
To:     Kumar@ci.codeaurora.org, M Chetan <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com, flokli@flokli.de, jan.kiszka@siemens.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 21:04:45 +0530 you wrote:
> This patch enables Intel M.2 7360 WWAN card support on
> IOSM Driver.
> 
> Control path implementation is a reuse whereas data path
> implementation it uses a different protocol called as MUX
> Aggregation. The major portion of this patch covers the MUX
> Aggregation protocol implementation used for IP traffic
> communication.
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: iosm: Enable M.2 7360 WWAN card support
    https://git.kernel.org/netdev/net-next/c/1f52d7b62285

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


