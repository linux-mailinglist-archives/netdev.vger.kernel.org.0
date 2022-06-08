Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B18D543A0D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 19:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiFHRO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 13:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiFHROR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 13:14:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE1F26F37B;
        Wed,  8 Jun 2022 10:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D10E61AC1;
        Wed,  8 Jun 2022 17:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BF5EC341C5;
        Wed,  8 Jun 2022 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654707614;
        bh=Pe3mMFVoHSFwdO+nJFPdZhMmjIrPdDigiIO3eldq3vs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jg0zgtzquzYjJChvLjewLKAxoyVC+K75RE0IrzoqspTWP75phVHf+4GoX/t+qbeqP
         DM7WJUiAxspXd9EviTrSrFgp/IgLVf/HqyBd/qxgxnP58fTKSOJ4FXNY58K/mofmxX
         whUuZD2YUnT/LYhrT9Y4osVo2By/lKFC+KZk0OsFnJlpO+gjV7n/8Xcq+N3EudgezK
         d6nwmboQBxqgu0td9u3ip/vUL4HbDGfKouPDwagLxlmSsB8PEpQECEuUciCdHllrcd
         t5VHlBry0i9KRwfh9wK5uqvrBdTlh9in7bLKCtWZ2fz0QEXrhmlEU5VIWg8IYsE5Z3
         IhOuZggsRTSyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72B1BE73800;
        Wed,  8 Jun 2022 17:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] Bluetooth: hci_core: Fix error return code in
 hci_register_dev()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165470761446.24378.861317142054344061.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 17:00:14 +0000
References: <20220606134807.4102807-1-yangyingliang@huawei.com>
In-Reply-To: <20220606134807.4102807-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        abhishekpandit@chromium.org
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

This patch was applied to bluetooth/bluetooth-next.git (master)
by Marcel Holtmann <marcel@holtmann.org>:

On Mon, 6 Jun 2022 21:48:07 +0800 you wrote:
> If hci_register_suspend_notifier() fails, it should return error
> code in hci_register_dev().
> 
> Fixes: d6bb2a91f95b ("Bluetooth: Unregister suspend with userchannel")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] Bluetooth: hci_core: Fix error return code in hci_register_dev()
    https://git.kernel.org/bluetooth/bluetooth-next/c/ad564394b3db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


