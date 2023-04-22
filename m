Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07B36EB722
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDVDk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjDVDkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDF31BDA;
        Fri, 21 Apr 2023 20:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CE956440A;
        Sat, 22 Apr 2023 03:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82FB8C433A7;
        Sat, 22 Apr 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682134820;
        bh=KCRJghHLAYGi+nJzJ0HgRyHXCCuLKYNr9RWnD+OIos8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BgOeGi693jgk15wxNucxSuNGVs5oyNctZ+HgoLKwaQ0e08fjMOaIaFZ0kvH1qSfU1
         /ZE8nuZ+albqNfIAHfJvYIxarn3ZndCvJ3f0ranGpv07+CBv3BiBTAKdEoYjvzWb2v
         Qzm8MSbc/ahXlP3pNbEuTqwm5qFxLqvBkf4h06EZ2p6PxlMnjjspsSVnPrMc58tfAf
         aKmVpSsjYcVc1T4x17dh5jcAC3lvYMlt7fR+zpc4GdH6RXojJNuRasp1AkPmOXby53
         dhm98XgfOFFmq11TSaZeLJgFbKb+iQIUDbxj9qbZGIXZOX1DgGCVFUm+hgXmuwZvNJ
         VF5b81Fh1i60Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62E7BE501E2;
        Sat, 22 Apr 2023 03:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: cls_api: Initialize miss_cookie_node when
 action miss is not used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213482040.27640.9410450020348917576.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:40:20 +0000
References: <20230420183634.1139391-1-ivecera@redhat.com>
In-Reply-To: <20230420183634.1139391-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com,
        marcelo.leitner@gmail.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 20:36:33 +0200 you wrote:
> Function tcf_exts_init_ex() sets exts->miss_cookie_node ptr only
> when use_action_miss is true so it assumes in other case that
> the field is set to NULL by the caller. If not then the field
> contains garbage and subsequent tcf_exts_destroy() call results
> in a crash.
> Ensure that the field .miss_cookie_node pointer is NULL when
> use_action_miss parameter is false to avoid this potential scenario.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: cls_api: Initialize miss_cookie_node when action miss is not used
    https://git.kernel.org/netdev/net/c/2cc8a008d62f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


