Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B45451CE41
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244637AbiEFCES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388289AbiEFCDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:03:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFCC13F35;
        Thu,  5 May 2022 19:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AFAE62043;
        Fri,  6 May 2022 02:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6FADC385A4;
        Fri,  6 May 2022 02:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651802412;
        bh=xDruWFRHuePEkAyV8YC+1fdTRTDjM7xot3ryjvi6KmY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sbOW0MbyCW31eK0pDQ2MeiM2gCoK4YqlEd/QIuCsUXSqGMOgEOT8lnqSvxondDESh
         Ker5wyE0kEGYzJQ+rVHEhofS26vW1IuqOb8WsJl4DTUXUEfndYefT1SEYz0qOEv+G6
         97PGWxh1bpQoWlXtnzLiNTtI7hMqQkooYTZaEJ0CP1QRhHrjEWi8PQ+Kj4xeY8AUaE
         GAv61+aYExyDEYhjcdT068TWbmhbDwKwdcw4PddUeJ5yl82oUUeTvZXJ7Mm1yEOKHk
         TR/+hmtilVRx9s+Z4t+sl/cOFnidMx3GuV6XTWNa+OD/fvK71Cakr+j+akD+9b/Gzn
         WOkd7KEKTHQrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4809F03874;
        Fri,  6 May 2022 02:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 1/1] firmware: tee_bnxt: Use UUID API for exporting the
 UUID
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180241267.2024.13062789128039053176.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 02:00:12 +0000
References: <20220504091407.70661-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20220504091407.70661-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     apais@linux.microsoft.com, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        zajec5@gmail.com, michael.chan@broadcom.com, f.fainelli@gmail.com,
        hch@lst.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 12:14:07 +0300 you wrote:
> There is export_uuid() function which exports uuid_t to the u8 array.
> Use it instead of open coding variant.
> 
> This allows to hide the uuid_t internals.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> [...]

Here is the summary with links:
  - [v4,1/1] firmware: tee_bnxt: Use UUID API for exporting the UUID
    https://git.kernel.org/netdev/net-next/c/10b4a11fe70f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


