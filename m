Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99EF65616C
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 10:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiLZJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 04:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiLZJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 04:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1361127;
        Mon, 26 Dec 2022 01:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11ECAB802BE;
        Mon, 26 Dec 2022 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB638C433F0;
        Mon, 26 Dec 2022 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672046415;
        bh=kjxJEX+PwFMsqnRFN92K7Un15lxgxiWqXlmQKldJQPY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dPAcZzRXIfLPM60PpxeeOXw8wpMxKLJ73dskjiaZtlxjZh2mesL+Jk73yreEs1D0k
         IK8Ms7cCbVEScDikryQ4Lo2/4HEVzR6gOlypFBvXbPKx3uStmg1ToVJReE7VduPexG
         slmX6SWC663EyLsTAhDLKc34ckLPgxXtEny8lyStJiYy9ZFSn/Q0RD2L8UjuZkHa1k
         2r+EOtR+5CiFbTivTpYuFR23gPcbPZXVCoNxExlHe7QZqzOetS/AUMqRiWmg8E8X7A
         2tajojRY56ffr7353KGeF1iORH8Ub0hqTn20RNpKzsnfS4GVfmTbP6HDmB0tzzHNj0
         ly/MGc9IfT8sw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B481E50D66;
        Mon, 26 Dec 2022 09:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc:  Fix potential resource leaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167204641556.10716.12082519458105064136.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Dec 2022 09:20:15 +0000
References: <20221223073718.805935-1-linmq006@gmail.com>
In-Reply-To: <20221223073718.805935-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sameo@linux.intel.com, christophe.ricard@gmail.com,
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 23 Dec 2022 11:37:18 +0400 you wrote:
> nfc_get_device() take reference for the device, add missing
> nfc_put_device() to release it when not need anymore.
> Also fix the style warnning by use error EOPNOTSUPP instead of
> ENOTSUPP.
> 
> Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
> Fixes: 29e76924cf08 ("nfc: netlink: Add capability to reply to vendor_cmd with data")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] nfc: Fix potential resource leaks
    https://git.kernel.org/netdev/net/c/df49908f3c52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


