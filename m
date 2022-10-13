Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794685FD2FC
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJMBuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiJMBuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5933F89916;
        Wed, 12 Oct 2022 18:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 047F2B81CF2;
        Thu, 13 Oct 2022 01:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D064C43142;
        Thu, 13 Oct 2022 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665625816;
        bh=DuFTGXXm2cbJFPX5Eh6xe1lCKfrfa3knQ9WIgTotzgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o/0iCtBLoRuGsi0oVqwFjaj0dm9gqIFBe/tyzl4QS7NzAnTouPGmYtJd4irqQhCic
         wYojglXe6lqPy/oXy6fZt2027D42N4ncGtzfPux9QxM6tHqQqNPTExCadHW7ROdjYH
         Z1+B+FgwsbPciyEHDBOq78SsTrileB4qJydJls1y8dAVBcDGxkRdS+MAq2utwZTOgf
         zVjmIQau0GOzk1cSvT0E8IKd//wU/8O9r5eSKSvaIru3Y9ewDbAr5sJ+RrzcBkWwMM
         vSHtsFXXLxRNrxsnL7t1hCTs91+EKuTN6zD2dx1YgYygi/TZcxRnX8ArgH8kWyOohC
         sAbpSr8nGOTRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7921BE50D96;
        Thu, 13 Oct 2022 01:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net] net: phy: micrel: Fixes FIELD_GET assertion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166562581649.26155.6931582824828929370.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Oct 2022 01:50:16 +0000
References: <20221011095437.12580-1-Divya.Koppera@microchip.com>
In-Reply-To: <20221011095437.12580-1-Divya.Koppera@microchip.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Oct 2022 15:24:37 +0530 you wrote:
> FIELD_GET() must only be used with a mask that is a compile-time
> constant. Mark the functions as __always_inline to avoid the problem.
> 
> Fixes: 21b688dabecb6a ("net: phy: micrel: Cable Diag feature for lan8814 phy")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> 
> [...]

Here is the summary with links:
  - [RESEND,net] net: phy: micrel: Fixes FIELD_GET assertion
    https://git.kernel.org/netdev/net/c/fa182ea26ff0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


