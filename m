Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F7A6A7A93
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCBEkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCBEkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:40:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C5214EBC;
        Wed,  1 Mar 2023 20:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33DD1CE1ECA;
        Thu,  2 Mar 2023 04:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 585E4C4339B;
        Thu,  2 Mar 2023 04:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677732018;
        bh=pM69SkwpXH3McdQECBuSiN3WLXofyNW4tSdi9yTvgiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g8o4rgU8rwm1L5V5Te5a0hBotp0S19ozO2yFahmdreHRIVh9HpYuaYTDW4iHg6Djn
         P7VOgIHRbWZF63E6z2H/Ti0IkTrjrYQZ2C+iWaYRx9DI30BSG03P8uBcJvO6AfUgC/
         hOtLsHGDlgwLvzUHvvayeyvb9mVsDZFOLkwYdFatypnjjEd7lFQ+85o+P80/1+HSvf
         lWKaAujrIyu0NLrgIWpW/sNzpHxYI8ysey+fFQVsYWSyLKu0Tc13pXAYLeWgm54cRi
         Iy/Fjeb6c/upgiXGn5Er+UsYX0c5s0GGsOLz+V14LBIKKvWccxnFVVdg3MvELyxzbD
         gOPAV8eIbtsZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38531E4D00C;
        Thu,  2 Mar 2023 04:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: tls: avoid hanging tasks on the tx_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167773201822.21303.9431691804610702435.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Mar 2023 04:40:18 +0000
References: <20230301002857.2101894-1-kuba@kernel.org>
In-Reply-To: <20230301002857.2101894-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com,
        stable@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, simon.horman@netronome.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Feb 2023 16:28:57 -0800 you wrote:
> syzbot sent a hung task report and Eric explains that adversarial
> receiver may keep RWIN at 0 for a long time, so we are not guaranteed
> to make forward progress. Thread which took tx_lock and went to sleep
> may not release tx_lock for hours. Use interruptible sleep where
> possible and reschedule the work if it can't take the lock.
> 
> Testing: existing selftest passes
> 
> [...]

Here is the summary with links:
  - [net] net: tls: avoid hanging tasks on the tx_lock
    https://git.kernel.org/netdev/net/c/f3221361dc85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


