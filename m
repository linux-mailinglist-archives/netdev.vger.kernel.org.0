Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62604DB379
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355652AbiCPOla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240487AbiCPOl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:41:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93C055776;
        Wed, 16 Mar 2022 07:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FAE4B81BF9;
        Wed, 16 Mar 2022 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1974BC340EC;
        Wed, 16 Mar 2022 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647441611;
        bh=AhhBV5ymBH+fRd3v6EVZuoqFf7WyZo7pCSKEWnGsRBg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c77h+4HnIvLqkxbBL+XOUkgHVx2btcxAF4oNSTJ1xanmD60Sa8UsOcLf+Xp+t9ou1
         v80Jh2gxRg9SMJGoPvtpJt76QxIkgpkmIWAxzKwFVMtRph5JafZwlFR8KjTSeeNnoD
         It+vy9hUCowO2pP4CxfZsHFZaQH1NY6TQr+pKbK7gClYUB/IC+QQMlDZx1vksOFYc5
         +ZBkt3nyUCn39SpPuWVQvAleVNz2BFl2TILDppF7qaW2wCp5mfshc/xd8YOd6YdB6S
         9uCTuRKzFjEI7TB6q2WuYovFGChOtf1pr7I8mTWoTTW2rl1TkpDNeJx/hPgjTCqbyg
         CjQWof33OlJoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6DFAF03844;
        Wed, 16 Mar 2022 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] Bluetooth: msft: Clear tracked devices on resume
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <164744161093.31498.12555709865853013941.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 14:40:10 +0000
References: <20220312020707.1.I2b7f789329979102339d7e0717522ba417b63109@changeid>
In-Reply-To: <20220312020707.1.I2b7f789329979102339d7e0717522ba417b63109@changeid>
To:     Manish Mandlik <mmandlik@google.com>
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org, mcchou@chromium.org,
        davem@davemloft.net, kuba@kernel.org, johan.hedberg@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Marcel Holtmann <marcel@holtmann.org>:

On Sat, 12 Mar 2022 02:08:58 -0800 you wrote:
> Clear already tracked devices on system resume. Once the monitors are
> reregistered after resume, matched devices in range will be found again.
> 
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> [...]

Here is the summary with links:
  - [1/2] Bluetooth: msft: Clear tracked devices on resume
    https://git.kernel.org/bluetooth/bluetooth-next/c/28c5124c1e07
  - [2/2] Bluetooth: Send AdvMonitor Dev Found for all matched devices
    https://git.kernel.org/bluetooth/bluetooth-next/c/1b144a7a0512

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


