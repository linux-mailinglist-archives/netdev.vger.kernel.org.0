Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906486053C8
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 01:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbiJSXK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 19:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiJSXK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 19:10:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4FB168E45;
        Wed, 19 Oct 2022 16:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC8A5CE24A3;
        Wed, 19 Oct 2022 23:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3054C433C1;
        Wed, 19 Oct 2022 23:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666221020;
        bh=DZTuuFU3EMXa7wsxN/PeDKX03VuVfFusIKbQRGXa9C0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=StNftmAA5ph7nUwOxlr6PcE/cGlQDbTbCEVzv2vs8fuKPsR/ss05FQNKdWJDdCZ4h
         rRMRaAix8LeYCpA7lXpdKD4m1In/Wq2MRa7cpGO8nIGaQfa2LJ+ozOXPi7du3WARF9
         0Zud2aI2P2ACqOA8rVkaG2Ovj9VLJTNTDy1gdmDEjpUTE+svvvZuXdHtQTrX+eLvdK
         nSVx5T9l/lrmsamEpG6EZTgmK9umV9v2ivTc5qsR8aFVk493TEujsgjqn2FxIfpyo4
         975+Io8cb6wqq0+1N4i2NlOze0cG9pH4s6AU0YeApTcGKBFi3IWRl9Up2igCMv0j2J
         WlqUCJrB73DCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC768E4D007;
        Wed, 19 Oct 2022 23:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bluetooth: Use kzalloc instead of kmalloc/memset
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166622101976.13398.9806993237794232819.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 23:10:19 +0000
References: <20221017030421.69108-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20221017030421.69108-1-jiapeng.chong@linux.alibaba.com>
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

On Mon, 17 Oct 2022 11:04:21 +0800 you wrote:
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
  - net: bluetooth: Use kzalloc instead of kmalloc/memset
    https://git.kernel.org/bluetooth/bluetooth-next/c/b0a19a2c4c53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


