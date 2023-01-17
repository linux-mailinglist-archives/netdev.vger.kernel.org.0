Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6036666DBEA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbjAQLKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbjAQLKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEE55274;
        Tue, 17 Jan 2023 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26AE2612A0;
        Tue, 17 Jan 2023 11:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80DF1C433F1;
        Tue, 17 Jan 2023 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673953816;
        bh=IsdZ8Fg3+12nH6+CtutQzxt4C2PLALmAN9RkPs5rCHs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mx45UPDAz7ybWFeEz5r6rVmZen8vAwt+EF7W5bhnqaYIncNK0OqoBv0+/hnmHyDSG
         VltcQwmKtal88iuvq3QqUKhXyLrc4g6JLjyJSsCaU7rtQIdhz3yEkbnngmDaOVrIq0
         YioSltPvy6jehuGcCP4tZrAMKR9if56z4I7D51C3dQkn2I/z3nlBXdE26EeunBMB15
         +7SAe/8bO8ldTe6PBNa8ft/s/neeg0DIr8lPUnY0k77XfITdhJMWAs7gHA6NCIgumk
         Lvk6DHuFB/yCtupieba0WzCNoNvEhoa8KDYzN46diYbjfmO4jMmWWI9kyXHb8R6RL3
         SmKzY1BBUcURA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 627AEC43159;
        Tue, 17 Jan 2023 11:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: sr9700: Handle negative len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167395381639.12891.10619571705736269049.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 11:10:16 +0000
References: <20230114182326.30479-1-szymon.heidrich@gmail.com>
In-Reply-To: <20230114182326.30479-1-szymon.heidrich@gmail.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 14 Jan 2023 19:23:26 +0100 you wrote:
> Packet len computed as difference of length word extracted from
> skb data and four may result in a negative value. In such case
> processing of the buffer should be interrupted rather than
> setting sr_skb->len to an unexpectedly large value (due to cast
> from signed to unsigned integer) and passing sr_skb to
> usbnet_skb_return.
> 
> [...]

Here is the summary with links:
  - net: usb: sr9700: Handle negative len
    https://git.kernel.org/netdev/net/c/ecf7cf8efb59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


