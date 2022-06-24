Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14D655A4D4
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 01:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiFXXaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 19:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiFXXaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 19:30:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADB089D22;
        Fri, 24 Jun 2022 16:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 491FDCE2F4D;
        Fri, 24 Jun 2022 23:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77E4AC341CA;
        Fri, 24 Jun 2022 23:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656113413;
        bh=Ht6R2r82+jx5cL7os5K71lbPP+dTQVliq4b0VOkioig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kf4MbI4OdE7wZASvQookB2PUmlPyUlo+ST2lpBJOg1EXYraQRmROAoFPBGryOCszM
         4VE5tYTtf0MkT5rsYCQlgfvqBF1rbnFDO+TZOItuDAUv/Yhio2C1kd/LVexrJXm5oJ
         +H/pooReKuGndQeqvS7tSpq8kQ2IH+NowX6S/czC2Oz5zHpiQyHpXIVE61gVgsbuu1
         V0mLh6WcNHm5ZlSBUiB1VstnweLJ9Il/bYzNPnlTfcFi/OjR5el4zkKNx5/EuLXZiz
         D17njjFRs+d382M1TrcB+wcktc/g9UiDrZR6KoJv8X2ntKCSPshFFYxC7Zfn2cO5TV
         hVluH7Z7hftqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57126E8DBCB;
        Fri, 24 Jun 2022 23:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tc-testing: gitignore, delete plugins directory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165611341334.10990.4924424332691591051.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 23:30:13 +0000
References: <20220622121237.5832-1-liujing@cmss.chinamobile.com>
In-Reply-To: <20220622121237.5832-1-liujing@cmss.chinamobile.com>
To:     liujing <liujing@cmss.chinamobile.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 22 Jun 2022 08:12:37 -0400 you wrote:
> when we modfying kernel, commit it to our environment building. we find a error
> that is "tools/testing/selftests/tc-testing/plugins" failed: No such file or directory"
> 
> we find plugins directory is ignored in
> "tools/testing/selftests/tc-testing/.gitignore", but the plugins directory
> is need in "tools/testing/selftests/tc-testing/Makefile"
> 
> [...]

Here is the summary with links:
  - tc-testing: gitignore, delete plugins directory
    https://git.kernel.org/netdev/net-next/c/1da9e27415bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


