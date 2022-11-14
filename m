Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46663628BCC
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 23:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237580AbiKNWKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 17:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbiKNWKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 17:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6AD2DD0;
        Mon, 14 Nov 2022 14:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A5161489;
        Mon, 14 Nov 2022 22:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3861AC43470;
        Mon, 14 Nov 2022 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668463816;
        bh=it+DmqALvMissYN0BJm/a/L7moNZDNLxTiB+fuO2SY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uKZ2HLiky6WbGvy6KFeJ66OoXA2PxsfhLxdeG2RakRxenegZwUfBADqX1h/Zc2drF
         Nej11MXM5McT9jtgDecXIO7PQeOOYsF4cRhGs/BEo2AKrPSPpWkHGKHqg1rkiRvvGS
         knVBcs4KLUYDfZ1qbVQQa5mCSmN7vW5tfYH8/D697jYTBcuBa0S1WJ5IjXrCxzcIcY
         NB9/KKXy10GOwRR/lstG5xeqIwMRkRjB4LV8qigwolxFeZZ/Bz1U6HPDlWnofplhRa
         JjfFUvXqq2amG61uyx0SrWBli9YDClQkLHrYHa3/aTeNh59BthnN4abcJSRSn4CHQr
         QEkHGVp2oaM/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1AE3FE50D60;
        Mon, 14 Nov 2022 22:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Bluetooth: hci_conn: add missing hci_dev_put() in
 iso_listen_bis()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166846381610.12666.4847222969416922565.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 22:10:16 +0000
References: <20221109023906.1556201-1-bobo.shaobowang@huawei.com>
In-Reply-To: <20221109023906.1556201-1-bobo.shaobowang@huawei.com>
To:     Wang ShaoBo <bobo.shaobowang@huawei.com>
Cc:     luiz.von.dentz@intel.com, luiz.dentz@gmail.com, pabeni@redhat.com,
        liwei391@huawei.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 9 Nov 2022 10:39:06 +0800 you wrote:
> hci_get_route() takes reference, we should use hci_dev_put() to release
> it when not need anymore.
> 
> Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
> ---
> 
> [...]

Here is the summary with links:
  - [v2] Bluetooth: hci_conn: add missing hci_dev_put() in iso_listen_bis()
    https://git.kernel.org/bluetooth/bluetooth-next/c/e32c8d8c6f29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


