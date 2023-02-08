Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152EC68E94F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBHHuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBHHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8E5CC1B;
        Tue,  7 Feb 2023 23:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2439BB81C5E;
        Wed,  8 Feb 2023 07:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4734C433EF;
        Wed,  8 Feb 2023 07:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675842617;
        bh=3X6iCVRH3YCGJ4kwf3aQPk36BGhPpfkXBgfgGERqCOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OHkIxR+o+JyibIa1RFIYx26nsFF+gjIX+y6Hm02b60emIR5w2j5qoy3xXC/JD1j2W
         FLgNAyOX2lbPB3k7NrK2O4nXwIFM2hMqwNTQA/KmeGDKW2mct4nQ2jPxvrRs+av6AR
         IaFxuGE8EUkwf0lf3h6c6G8viPfEMAwXq5IesAf7AhYd9WtAod4dPA8QSaIYM/2FOD
         SU0+Qj/DK8+7EXugZQU+qlVGdsjgqUUgteexicar8cMsS5xCROU+1NraosRJfG4eRn
         7PZDubBU38MuHp+fmgmtTAISR/HDAPRWYYfdxk92JQj5uz0XF4dbS6dnBtn2CfhzlG
         P/ywn4XUaKMmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A998BE21ECB;
        Wed,  8 Feb 2023 07:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: sch: Fix off by one in
 htb_activate_prios()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584261769.18852.13801863931987193123.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 07:50:17 +0000
References: <Y+D+KN18FQI2DKLq@kili>
In-Reply-To: <Y+D+KN18FQI2DKLq@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     jhs@mojatatu.com, keescook@chromium.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 6 Feb 2023 16:18:32 +0300 you wrote:
> The > needs be >= to prevent an out of bounds access.
> 
> Fixes: de5ca4c3852f ("net: sched: sch: Bounds check priority")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  net/sched/sch_htb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: sched: sch: Fix off by one in htb_activate_prios()
    https://git.kernel.org/netdev/net/c/9cec2aaffe96

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


