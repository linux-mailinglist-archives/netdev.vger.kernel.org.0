Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEBB6053CA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 01:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiJSXKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 19:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiJSXK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 19:10:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC34169CDF;
        Wed, 19 Oct 2022 16:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66B7AB8261B;
        Wed, 19 Oct 2022 23:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB942C433B5;
        Wed, 19 Oct 2022 23:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666221020;
        bh=D3R+B5TDr2P9Jc3Chn1FNBBV2QgMjte5FJZjM9dRgEM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e4CaNH8T/RAzp37dFrO7+K+N7vZKcz4yrmBJwCUas5CK5SdC9NSLZBuxiGIBA/1/F
         rh9uIOKg4OoOFMrYIQhzXTjfrEhtAHSt/2+v6UXksD0mOai7xQgMHkdhQkAwlQt32d
         dT2fnu1EPw8bkB30TiJSfZJqfXXOfPMf+AnsXy9S+2TV7rACq6gguNtaXP9S617MB7
         6FYQ+30q2HsIZtu4yWUYPHDL+qPR51xxwwbj3/eG87WGWs11nxT8MxIVFSup36JXNL
         y8NSH/ukEZUGnqhZWbQl7diDR/EF1VWl39WRvhjh2wBgOg22iwsvtfISNgWl+YjkhZ
         m6fWJ8qqCOy7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C96F9E29F37;
        Wed, 19 Oct 2022 23:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: Use kzalloc instead of kmalloc/memset
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166622101982.13398.13879326059626905110.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 23:10:19 +0000
References: <20221017054713.7507-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20221017054713.7507-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 17 Oct 2022 13:47:13 +0800 you wrote:
> Use kzalloc rather than duplicating its implementation, which makes code
> simple and easy to understand.
> 
> ./net/bluetooth/hci_conn.c:2038:6-13: WARNING: kzalloc should be used for cp, instead of kmalloc/memset.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2406
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - Bluetooth: Use kzalloc instead of kmalloc/memset
    https://git.kernel.org/bluetooth/bluetooth-next/c/b0a19a2c4c53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


