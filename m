Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E65A8BB6
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiIADAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiIADAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C237756B
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 20:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F1E9B823F1
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C04DAC433D6;
        Thu,  1 Sep 2022 03:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662001215;
        bh=kKd/EpU7peVF0OYTPjKfQ8slmQsfssTT4JMi2M8dflE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u917Dg91zbNgfSPBIPkTzOMy5cD3WMD/eOQMMi70ZF/+BwRJDmkIpTDVyBGE7RIzp
         p7U/Y4ukecbq5KjXSyWJegZn3JB6wFwCldpdxRtCE0N6mwf5RQ71Wktltnk18yfiLf
         IvaRUh+mVG9j75ct0sdEY4TfutuDacYL09EQROXxXTkqdiZ1pQJj32OREvR6kcGrmE
         E45DKP5JDAAqrVDmDvfoqP1iKFcGKha217zOt9gSSRGiChwOdlq5gjlbHnK09xDt5v
         X/CBrFDWfedZfKLpFPgt5SHagck4WPpAwWwQGaOSqgpm0P27R4AdpZMzelCPmYB6r5
         7OtPv/Vp3CwIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A395BE924DA;
        Thu,  1 Sep 2022 03:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166200121566.29714.11056938922390994481.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 03:00:15 +0000
References: <20220830163448.8921-1-kurt@linutronix.de>
In-Reply-To: <20220830163448.8921-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Aug 2022 18:34:48 +0200 you wrote:
> In case the source port cannot be decoded, print the warning only once. This
> still brings attention to the user and does not spam the logs at the same time.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  net/dsa/tag_hellcreek.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dsa: hellcreek: Print warning only once
    https://git.kernel.org/netdev/net/c/52267ce25f60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


