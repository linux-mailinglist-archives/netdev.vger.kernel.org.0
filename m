Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06826E9D97
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 23:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjDTVAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 17:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjDTVAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 17:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEABB44AF;
        Thu, 20 Apr 2023 14:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5070364BF6;
        Thu, 20 Apr 2023 21:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAE1FC433D2;
        Thu, 20 Apr 2023 21:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682024420;
        bh=s1zEtJJD2YjqlbXEJW2LoiA2+oEzJ8YMMXKTXIPZRtI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ggsZJkNTVuKkLbM9tYWVjI1AdGmWamQC4FoPRmBA/oeM87n/MJImHAr6AGbw8UqbM
         xHoRc0LQfyZsa8HdxNjVE5UQ9zoWPLl6ebbhNB05/Imtwy647n04dvr6I5uBwIvcHf
         hw4izoMlcd1DCdUSjYGfg3Sr7LVe41r1PP/AwhdTB16jA09WUZzXlAVKdNNzfFSffa
         +PoisODxoSxu+eQWVjdKXpWb36a13JHp2nqHUgsgW0+VPoxxquQrQmuhPQKrKnOII8
         u+dCKcvqqiA15UgFKYaUlpED10rFunEnZBaNduca2XccElIw7DXtuIZnJXEHbNpJO9
         6J40oiUZMSalg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D014E501E2;
        Thu, 20 Apr 2023 21:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: Cancel sync command before suspend and power off
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168202442057.11865.14095636153952852238.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 21:00:20 +0000
References: <20230420202312.1.I53bc906a716045c7474a77d3038bfcb6909094e2@changeid>
In-Reply-To: <20230420202312.1.I53bc906a716045c7474a77d3038bfcb6909094e2@changeid>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        apusaka@chromium.org, yinghsu@chromium.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, johan.hedberg@gmail.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Thu, 20 Apr 2023 20:23:36 +0800 you wrote:
> From: Archie Pusaka <apusaka@chromium.org>
> 
> Some of the sync commands might take a long time to complete, e.g.
> LE Create Connection when the peer device isn't responding might take
> 20 seconds before it times out. If suspend command is issued during
> this time, it will need to wait for completion since both commands are
> using the same sync lock.
> 
> [...]

Here is the summary with links:
  - Bluetooth: Cancel sync command before suspend and power off
    https://git.kernel.org/bluetooth/bluetooth-next/c/ef917d571667

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


