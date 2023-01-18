Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4184F671FDA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjAROkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjAROjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:39:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EDD32E5F;
        Wed, 18 Jan 2023 06:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4835B81D31;
        Wed, 18 Jan 2023 14:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E66EC4339B;
        Wed, 18 Jan 2023 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674052217;
        bh=+S0bqAuYObSV7Oo+RzKQU93LpRgcanqdJ+xlx/dP7BQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F8/LTVajbOx4Cw6ZnZl9bgzIqWCZrRodYCls0ZnudWM5qoV6z6bs/WPlROeRbCD/m
         OiFBbwjLqYrQzw84ZMHNIpCVV3RaLTSDGmju80UuuKgwBVozDXVqa2CvbNHb8VELao
         uEozVjRdwG8aj9xTy0/sXzRUjHTdlzWbxlkgC11SYf6h9tDrXEyC7Ev1IDG2kohMlV
         B6Ld82xpd+gVR0nY0NN12XfTS3gjs71Vi+ixQTSbaFscyNG3H6X+0OYAs2Jz8/E4VY
         u9XbSv234Cq1HqCZE0mci73kcXRDH9qDScyXDqzYS/GmJ8pHDXcDWhmkPzOcXXeP5E
         8O4MkatdbOdwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 582B1C3959E;
        Wed, 18 Jan 2023 14:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: macb: simplify TX timestamp handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167405221735.16594.17758306182605357931.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 14:30:17 +0000
References: <20230116220835.1844547-1-robert.hancock@calian.com>
In-Reply-To: <20230116220835.1844547-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 16 Jan 2023 16:08:34 -0600 you wrote:
> This driver was capturing the TX timestamp values from the TX ring
> during the TX completion path, but deferring the actual packet TX
> timestamp updating to a workqueue. There does not seem to be much of a
> reason for this with the current state of the driver. Simplify this to
> just do the TX timestamping as part of the TX completion path, to avoid
> the need for the extra timestamp buffer and workqueue.
> 
> [...]

Here is the summary with links:
  - [net-next] net: macb: simplify TX timestamp handling
    https://git.kernel.org/netdev/net-next/c/8e7610e686d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


