Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FDA5EB1A0
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiIZTub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiIZTu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DFF1CB2C;
        Mon, 26 Sep 2022 12:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCE16B80E65;
        Mon, 26 Sep 2022 19:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D90AC43141;
        Mon, 26 Sep 2022 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664221817;
        bh=reL7wTuQS0hg3+tTB0XgWfAlXlohb1odvr36rBNB+qU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A//Dr5+WIt7PeBykDesy1SvbjxmwzxwRczoE6stxjqVzyGWZWoh3e6CJ5LBZSgjn5
         bbizXFyUoYfhCh/woz+C7Jod8KNrvp3gx9A72eHRuwclrnbpTg2l3qnURUfoAiLeeQ
         BeKSI6o8l7f1vFI5L2mQKP4R6AL+vqTyNq8p+T46Z2mfrWUHXDPSjc722Sr5N0xVLh
         ucHVD2MZB5g6lqlyqjgq+0/9rjr1R1krghEo3h+jCGOfX6deZY99A/aohxn3iGw4ar
         g+FSrN0dBRG39I2OlkvcmB12qY5JO04PiDuK14KGACrQTDzWqAHp2c4KeDBiFUfiFw
         NO+aFBL5zS4VQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72FF4E21EC2;
        Mon, 26 Sep 2022 19:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: taprio: simplify list iteration in
 taprio_dev_notifier()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422181746.25918.9646343346290126504.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 19:50:17 +0000
References: <20220923145921.3038904-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220923145921.3038904-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 23 Sep 2022 17:59:21 +0300 you wrote:
> taprio_dev_notifier() subscribes to netdev state changes in order to
> determine whether interfaces which have a taprio root qdisc have changed
> their link speed, so the internal calculations can be adapted properly.
> 
> The 'qdev' temporary variable serves no purpose, because we just use it
> only once, and can just as well use qdisc_dev(q->root) directly (or the
> "dev" that comes from the netdev notifier; this is because qdev is only
> interesting if it was the subject of the state change, _and_ its root
> qdisc belongs in the taprio list).
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: taprio: simplify list iteration in taprio_dev_notifier()
    https://git.kernel.org/netdev/net-next/c/fc4f2fd02a1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


