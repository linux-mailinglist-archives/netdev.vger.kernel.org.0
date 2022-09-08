Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173195B1E92
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiIHNUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiIHNUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:20:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604AC8E4ED
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FFCFB82104
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 13:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29A15C433C1;
        Thu,  8 Sep 2022 13:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662643215;
        bh=RMpPTdM9BAdBgvkzUP3TMz4G8QeMuiwCuso96+Qembo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BwSg2lxUJeRGchvEl+aNzmFMJv155pk95Ch/4KPch4K2lRZsUiUarlcgeQac/lJSK
         j836tXzdq+pY2/uRS1rQcbHvZP07S6/emaPmZvTcMM42OEPGYa1wqrCRE3Z8SZIrgW
         gMOtMssNSI4EJxk/Q3PhSczxs8doHnIffdGuzZ9DgeFdCrVquxCVt3Xu6pXtpBjHIt
         Z7xeEFxe3iQR2V0vlbZeB9MenEY9C31QyiQdPqnT54cDarg2RtEujN9NXrWNUmeR+p
         f30ZJ7zZwXOwQzPdKPY3zoMGGERjzIr9/wPQ63BTXRWAL3LP3ZMtM/0JKcvvetbC/G
         6Y5EWxAuYjA2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D3D3E1CABD;
        Thu,  8 Sep 2022 13:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: sparx5: fix function return type to match
 actual type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166264321504.19009.15565172745208170830.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Sep 2022 13:20:15 +0000
References: <20220906065815.3856323-1-casper.casan@gmail.com>
In-Reply-To: <20220906065815.3856323-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, dan.carpenter@oracle.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  6 Sep 2022 08:58:15 +0200 you wrote:
> Function returns error integer, not bool.
> 
> Does not have any impact on functionality.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: sparx5: fix function return type to match actual type
    https://git.kernel.org/netdev/net-next/c/75554fe00f94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


