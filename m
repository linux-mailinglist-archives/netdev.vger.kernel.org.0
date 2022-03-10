Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0C34D4028
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbiCJELN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbiCJELM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:11:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA9E123413;
        Wed,  9 Mar 2022 20:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C8661812;
        Thu, 10 Mar 2022 04:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BF61C340EB;
        Thu, 10 Mar 2022 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646885410;
        bh=AQzK0dBnDk1T0hgHhUnFSvDzRcSlhthzIHTQepfssUA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ifkO3Pm1BaalIDaUR6gy7MNkzTGjQXw+LBpGF5oXWEyLvGZSw2QQo07LoM4lY9dWm
         0LoiARiJID7bNwswZ5zwN+6yYyk/bz2hepJ/JyQjBeTr9+qmWzOgrtn5hi+Gn3nKmU
         0W7IbgO7rN7jZ0jn1mob6o4GT1qlp7GrckhPO/8+11UBKlQ70GdN5blBytOzdy44qb
         OjT+EpyD74/DEFtMsw4owd8zzmaS1ljq3Cij+orbZjacBjZQZsWA8X1chGlBBKDFmu
         P7xg/uHmUmh2Y3X95t/pfg/sa0TgqjeTPnnhOz0tQZQ4B70hO8nO770kiUNBT78Vc/
         GY/MWoUFqf7vA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54E33E6D3DE;
        Thu, 10 Mar 2022 04:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: port100: fix use-after-free in port100_send_complete
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688541034.5045.14625682237475664726.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:10:10 +0000
References: <20220308185007.6987-1-paskripkin@gmail.com>
In-Reply-To: <20220308185007.6987-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     krzysztof.kozlowski@canonical.com, sameo@linux.intel.com,
        thierry.escande@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Mar 2022 21:50:07 +0300 you wrote:
> Syzbot reported UAF in port100_send_complete(). The root case is in
> missing usb_kill_urb() calls on error handling path of ->probe function.
> 
> port100_send_complete() accesses devm allocated memory which will be
> freed on probe failure. We should kill this urbs before returning an
> error from probe function to prevent reported use-after-free
> 
> [...]

Here is the summary with links:
  - NFC: port100: fix use-after-free in port100_send_complete
    https://git.kernel.org/netdev/net/c/f80cfe2f2658

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


