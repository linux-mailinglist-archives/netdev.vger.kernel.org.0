Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785AE52808C
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241396AbiEPJKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 05:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242320AbiEPJKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 05:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AC2BE2B;
        Mon, 16 May 2022 02:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE9846127D;
        Mon, 16 May 2022 09:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FE70C385B8;
        Mon, 16 May 2022 09:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652692212;
        bh=DLxSzkZM0MdAIAq8FKo7oy8buyuB/4oBvp6tuto9RnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ehJ1OtavRjX+syfli6ADwGyAaZ6tetrOxIcCx7yHe5mSI2Ke3Rxh5JW3gbGTLUnZB
         aVvCZR/ax3qfOt/T2Q9KXbTicuI09fW3ojjNyOSYOKgrKX/yjYbkNeXyBa+SNb9z5z
         Z1aC7CvT1FDvEocByrW1X+gh/Vb4ivv8vXD3bvlCiPNfWMHLaV1FBHSD3EwTpEAJ3y
         jj1BVKu5HEadYIyqkhawjD73bsJR619AoOe4DnNs8eTI76rNlHyHhxWe93StVACMNH
         /lOnuJy/c6sl+DaVoIBskNgleMBGGu07QTLb9ZRiksX90q3ZabUlBHZOkE+qQP4jF2
         TET8Ltm7IsvfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D618E8DBDA;
        Mon, 16 May 2022 09:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] Revert "can: m_can: pci: use custom bit timings for
 Elkhart Lake"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269221211.27907.1144930451900278439.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 09:10:12 +0000
References: <20220514185742.407230-2-mkl@pengutronix.de>
In-Reply-To: <20220514185742.407230-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        jarkko.nikula@linux.intel.com, chee.houx.ong@intel.com,
        aman.kumar@intel.com, kumari.pallavi@intel.com,
        stable@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sat, 14 May 2022 20:57:41 +0200 you wrote:
> From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> 
> This reverts commit 0e8ffdf3b86dfd44b651f91b12fcae76c25c453b.
> 
> Commit 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for
> Elkhart Lake") broke the test case using bitrate switching.
> 
> [...]

Here is the summary with links:
  - [net,1/2] Revert "can: m_can: pci: use custom bit timings for Elkhart Lake"
    https://git.kernel.org/netdev/net/c/14ea4a470494
  - [net,2/2] can: m_can: remove support for custom bit timing, take #2
    https://git.kernel.org/netdev/net/c/d6da7881020f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


