Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC56A543A09
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 19:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiFHROb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 13:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiFHROR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 13:14:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0053AD8A8;
        Wed,  8 Jun 2022 10:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D70EBB828FC;
        Wed,  8 Jun 2022 17:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83DAAC3411F;
        Wed,  8 Jun 2022 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654707614;
        bh=wHDWDadjXahBcCqOH7i1sGoWyuDatot+S1M8ovKT/Co=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UmqRHTU30itbqGegfL5vZBn9b1Vx6fvrwB0TaVY+WnQjX6aVRergtaOy3wa9MiIdj
         MVul8GXKNRshfGnAoXNG3RP5yiIbDj/vZ81+34yXPe6ka4G/TD6ZXxBubO5/IfDd5I
         TX9UoI86fR6Qmk/ImVrTg4EojC+yE8mOtyFqstnSDdTYmjMpsBJPaWV9p4YWP1tSCX
         dsnbRsYJvlNXw6PpcgPncJj5QB2hrRpK0U/lRb6gpmE1YZuQ8TPH7dVHJAJvkgr0EU
         hNQDCbgKgiIOAj6VydTw8OaJseV8AE73QaQOUPwAMaZ/OurJ76ohXzavxLsYDDcTmp
         CNQiDr7gWnCzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69C20E737EF;
        Wed,  8 Jun 2022 17:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] Bluetooth: use memset avoid memory leaks
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165470761443.24378.11011419118716998242.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 17:00:14 +0000
References: <20220607153020.29430-1-ruc_zhangxiaohui@163.com>
In-Reply-To: <20220607153020.29430-1-ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiaohuizhang@ruc.edu.cn
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

On Tue,  7 Jun 2022 23:30:20 +0800 you wrote:
> From: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
> 
> Similar to the handling of l2cap_ecred_connect in commit d3715b2333e9
> ("Bluetooth: use memset avoid memory leaks"), we thought a patch
> might be needed here as well.
> 
> Use memset to initialize structs to prevent memory leaks
> in l2cap_le_connect
> 
> [...]

Here is the summary with links:
  - [1/1] Bluetooth: use memset avoid memory leaks
    https://git.kernel.org/bluetooth/bluetooth-next/c/0b537674e072

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


