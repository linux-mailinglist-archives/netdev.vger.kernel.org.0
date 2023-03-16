Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04076BD74D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCPRlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCPRlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:41:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A48441B41;
        Thu, 16 Mar 2023 10:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55F09620D4;
        Thu, 16 Mar 2023 17:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6C81C433A8;
        Thu, 16 Mar 2023 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678988418;
        bh=gT3w3bZwq9uRuWOPQh7rpuQcsW3BmrE4X89BCBoEau0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U5SozdjLbTUZ0UO1HLhABH6sXrT77AVR7BoVItiXnl1aQrxJo8gZkHn7xDbNOmmA0
         u1SAQ7jGahsJ4OU2pUJAPBHlv89cjo06FeeoW3dYC89jbNoOoBNB3W8NWoMBYvKp+l
         PQ50XiLgvyWje5DVwGwwm+VU+GehdXtujCECVQwjbWH1HNCPDAKeog/kPmUL1BT0kh
         7wMFSb/W2iGxwyIW2d/rHW+lVHRvF76KsKCm694zbGg0A3tUtDZ1a0bIrbJEuZWjO6
         Toc//oGijNiScKIenOdsdz8a+CNrzkVICmoi/WLOdeda6Kl6gWW9c5Lhq7ufnt/1br
         nfI15nGxTf+Cw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0BC0E66CBF;
        Thu, 16 Mar 2023 17:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] Bluetooth: mgmt: Fix MGMT add advmon with RSSI command
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167898841865.29063.6355531025608761688.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 17:40:18 +0000
References: <20230316181112.v3.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
In-Reply-To: <20230316181112.v3.1.I9113bb4f444afc2c5cb19d1e96569e01ddbd8939@changeid>
To:     Howard Chung <howardchung@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org, apusaka@chromium.org,
        brian.gix@intel.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Thu, 16 Mar 2023 18:11:38 +0800 you wrote:
> The MGMT command: MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI uses variable
> length argument. This causes host not able to register advmon with rssi.
> 
> This patch has been locally tested by adding monitor with rssi via
> btmgmt on a kernel 6.1 machine.
> 
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
> Signed-off-by: Howard Chung <howardchung@google.com>
> 
> [...]

Here is the summary with links:
  - [v3] Bluetooth: mgmt: Fix MGMT add advmon with RSSI command
    https://git.kernel.org/bluetooth/bluetooth-next/c/8abee3773899

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


