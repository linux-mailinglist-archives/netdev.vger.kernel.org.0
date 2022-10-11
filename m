Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D895FB346
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 15:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJKNVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 09:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJKNVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 09:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4888C444;
        Tue, 11 Oct 2022 06:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A73261127;
        Tue, 11 Oct 2022 13:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5025C433B5;
        Tue, 11 Oct 2022 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665494416;
        bh=5/U84ftdVB9QrPzbhDtjgeZ/yd+ovlBaxXqyYfqm3uE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U49NSY3uFrJGk6ityYz97uokV51UDaDWwNLS9BOGyVTPhIbYS+38v0bZ4ZM0MrT3N
         pC8MAdE6+OOr7wqjDuRnsPLAWDUPGx4LBn4AmpUWk/eJlvF697xZMMNTzNydfKKhHH
         4wVamYs7PhVHuKKnunZK5z53Ge+ZVN1CDgHciNIZaQcWFd6BV8gRcf9MfkjITq4vQY
         TgFddV/av8amtrA1rZ9aC5PJKMDVT6xgnS/q5iRqYZCXCBHqzFRyG+y/v2qeY62MOl
         otCkJzzARJ8MbbfeeL6vNNNhQm3gIn3mwrFk38s921RAXnOD6MLJHRIaDJelco1aEe
         aC3Kf6k0Qdqug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA920E29F35;
        Tue, 11 Oct 2022 13:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] can: kvaser_usb_leaf: Fix overread with an invalid
 command
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166549441675.3513.6322660201168688295.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Oct 2022 13:20:16 +0000
References: <20221011074815.397301-2-mkl@pengutronix.de>
In-Reply-To: <20221011074815.397301-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        anssi.hannula@bitwise.fi, stable@vger.kernel.org, extja@kvaser.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Tue, 11 Oct 2022 09:48:12 +0200 you wrote:
> From: Anssi Hannula <anssi.hannula@bitwise.fi>
> 
> For command events read from the device,
> kvaser_usb_leaf_read_bulk_callback() verifies that cmd->len does not
> exceed the size of the received data, but the actual kvaser_cmd handlers
> will happily read any kvaser_cmd fields without checking for cmd->len.
> 
> [...]

Here is the summary with links:
  - [net,1/4] can: kvaser_usb_leaf: Fix overread with an invalid command
    https://git.kernel.org/netdev/net/c/1499ecaea9d2
  - [net,2/4] can: kvaser_usb: Fix use of uninitialized completion
    https://git.kernel.org/netdev/net/c/cd7f30e174d0
  - [net,3/4] can: kvaser_usb_leaf: Fix TX queue out of sync after restart
    https://git.kernel.org/netdev/net/c/455561fb618f
  - [net,4/4] can: kvaser_usb_leaf: Fix CAN state after restart
    https://git.kernel.org/netdev/net/c/0be1a655fe68

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


