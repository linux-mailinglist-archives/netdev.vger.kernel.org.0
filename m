Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9495BBA18
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 21:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiIQTU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 15:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiIQTUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 15:20:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71595275F2;
        Sat, 17 Sep 2022 12:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08891B80DCD;
        Sat, 17 Sep 2022 19:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C09D5C433D7;
        Sat, 17 Sep 2022 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663442421;
        bh=UQfXo29y9NbqLAQN1NnMX4RCp1VnZdXZ2n97AO2/IHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rYr8Yf5GP+CqS4DxvlU55ytm9008m2dcl5K6gJo44Eo1gQDp4PW6ZNpqtfkkZm3lj
         dDNkhTS7dBmMEiHJJj7PQTxsidkeJfGp0BEqUnKT8zLaOXrleRdDr2Z982fU/d0RKD
         w1IEPX2in4YMp9k8CKLrS+Hjm8VMhJSs7MNPJdoVzuX2I84Q6loxsOv7KN5Ps7EtRh
         Zd8oiRGpC3K+Gb0sGPy1BgFQhHI9y1yuNpFA9yhc4EDCdCS79Ocxnf8Qb79wZbx/UW
         DdL31Kwa+tx3kS95S0zKFgnYwy2PHuzOkZ1/9h5cKx/ZqAtu5ys7kt20xCapAviAuj
         PcQhaPIXIMBuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7639C04E59;
        Sat, 17 Sep 2022 19:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] can: flexcan: Switch to use dev_err_probe() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166344242168.31603.12470053140330012834.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Sep 2022 19:20:21 +0000
References: <20220914134030.3782754-1-yangyingliang@huawei.com>
In-Reply-To: <20220914134030.3782754-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        wg@grandegger.com, mkl@pengutronix.de
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
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed, 14 Sep 2022 21:40:30 +0800 you wrote:
> dev_err() can be replace with dev_err_probe() which will check if error
> code is -EPROBE_DEFER.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/can/flexcan/flexcan-core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [-next] can: flexcan: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/1c679f917397

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


