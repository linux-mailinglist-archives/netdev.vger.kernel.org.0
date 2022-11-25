Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BF26384E4
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiKYIA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiKYIAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:00:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290762FFF9;
        Fri, 25 Nov 2022 00:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDD6BB82974;
        Fri, 25 Nov 2022 08:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D4FEC433D6;
        Fri, 25 Nov 2022 08:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669363217;
        bh=0HvTLDVz0F+F3ENKXrYiYaMjdbfw6Al5nW8NPscnaRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P40z/GZM7AGjL6AHDIRqg1VTrTsFpOH6QI9zt6eWUBuUHpO1Wcp7kAzalsqMgafZ5
         heJ30oEvNVBnLFKDuma2P98VDA/4vO/I1SS0es5mzi0q+z972FXmkJ5/JDbLMqTmx8
         RRfZWUvIwQ6Z66Bhenp8kgBiOU7goKlC18WPN9CqqtKfQyKgHrEqfOjVfpa995X/Hm
         rssyYUYgZNh/2EaKQZCOHauchVk+8stLkH3Qx+sWhg2m0bbABvv/ZWvPp0CKmalYZl
         TS60kOybSCNHFgyh6JEGsH5Mcn/grpixf9p1zVAYrERKZkIup3UZpCQK5a5ueUbuOu
         KwBH8Hr8lT+Cw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54675E270C7;
        Fri, 25 Nov 2022 08:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] can: mcba_usb: Fix termination command argument
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936321734.29613.11890827238652314469.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 08:00:17 +0000
References: <20221124152504.125994-1-yashi@spacecubics.com>
In-Reply-To: <20221124152504.125994-1-yashi@spacecubics.com>
To:     Yasushi SHOJI <yasushi.shoji@gmail.com>
Cc:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, remigiusz.kollataj@mobica.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Fri, 25 Nov 2022 00:25:03 +0900 you wrote:
> Microchip USB Analyzer can activate the internal termination resistors
> by setting the "termination" option ON, or OFF to to deactivate them.
> As I've observed, both with my oscilloscope and captured USB packets
> below, you must send "0" to turn it ON, and "1" to turn it OFF.
> 
> >From the schematics in the user's guide, I can confirm that you must
> drive the CAN_RES signal LOW "0" to activate the resistors.
> 
> [...]

Here is the summary with links:
  - [v2] can: mcba_usb: Fix termination command argument
    https://git.kernel.org/netdev/net/c/1a8e3bd25f1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


