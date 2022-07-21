Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F3B57D5D1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiGUVUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiGUVUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AD715838;
        Thu, 21 Jul 2022 14:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98BE96181D;
        Thu, 21 Jul 2022 21:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA372C341C0;
        Thu, 21 Jul 2022 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658438414;
        bh=HUuVCf8AwAMI2usXH0mlaxaxdAySQiYPiu5NUkSZYro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cxO5QSNahJG1CTiuTmit/uJ3/vQpQbwD3RXU/9tHvGJH3OXy750qY2796yxEvtD3d
         qlyAU+BpEEQk6DM8O3lFi9Hzz5XNcGjZ6OQdsHOPACaMgiuSd/j563x2cZQafOECxt
         6KFIUAtPcAWy9Bz4mZADCkN5HS78lAxXtmnJex4FzRAQhhYqkwxBdzAsXd6qixrWW7
         SHGsuTNoUJw2nVzJ13spduBAIPtzZP80RlNnNcMJLBTj85IkUcHZepJsmqwoCXTFrp
         aZzIosXvq9SMCdamLDUSufweNuBjwz6KCgFhd2yvu3WSZWOyhN4NtZjGSIuldq2ofI
         69PqoSGcYmLBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFB9DD9DDDD;
        Thu, 21 Jul 2022 21:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] Bluetooth: hci_sync: Refactor add Adv Monitor
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165843841384.2414.3327226907905248679.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 21:20:13 +0000
References: <20220720162102.v2.1.If745ed1d05d98c002fc84ba60cef99eb786b7caa@changeid>
In-Reply-To: <20220720162102.v2.1.If745ed1d05d98c002fc84ba60cef99eb786b7caa@changeid>
To:     Manish Mandlik <mmandlik@google.com>
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org, mcchou@google.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 20 Jul 2022 16:21:13 -0700 you wrote:
> Make use of hci_cmd_sync_queue for adding an advertisement monitor.
> 
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Miao-chen Chou <mcchou@google.com>
> ---
> 
> Changes in v2:
> - Refactored to correctly use hci_cmd_sync_queue
> 
> [...]

Here is the summary with links:
  - [v2,1/2] Bluetooth: hci_sync: Refactor add Adv Monitor
    https://git.kernel.org/bluetooth/bluetooth-next/c/75d2509cd04e
  - [v2,2/2] Bluetooth: hci_sync: Refactor remove Adv Monitor
    https://git.kernel.org/bluetooth/bluetooth-next/c/6b88eff43704

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


