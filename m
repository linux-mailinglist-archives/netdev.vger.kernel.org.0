Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A36E5E7201
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 04:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiIWCkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 22:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiIWCkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 22:40:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298D1923E4
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 19:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC232B829EA
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 02:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77B51C4347C;
        Fri, 23 Sep 2022 02:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663900820;
        bh=scJXSenv1p90RM/ME4c6n9tK80D/FFo6jp5PPKu2EIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MBcN+NoQ7rQQ9MB/6yXHUB4nj9WMjhyeHk4ttmk69bPMbApG/xnJd9v9N9S00s88o
         s8wovAM0+ObQAWHc864LflbH9DZplLpGFEDi3q4LlHkIElJ/cHOXFPpV83V16cWLh+
         njBxVuxiwJTkbCi6UZRZvzN6+b4PF0molttKieQTA6QLYNq3SpLYIA/CrIsyv8yt6P
         nfTAUM088qnyo13hnxB8+VLhg7TuHYxFq/LkT6oPS/9P1/lq2R28ppWK28SEENe1jR
         iq+5cZZqvD2Etg0cCXYCtLNiQPB/8P+s/L7eCr3O7HiIVGDNUIY60JyJvrGneLNZxB
         RT2VYwMRJ/VZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 500C3E50D6B;
        Fri, 23 Sep 2022 02:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] ethtool: tunnels: check the return value of
 nla_nest_start()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166390082032.27582.9058046418787346317.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 02:40:20 +0000
References: <20220921181716.1629541-1-floridsleeves@gmail.com>
In-Reply-To: <20220921181716.1629541-1-floridsleeves@gmail.com>
To:     Li Zhong <floridsleeves@gmail.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 21 Sep 2022 11:17:16 -0700 you wrote:
> Check the return value of nla_nest_start(). When starting the entry
> level nested attributes, if the tailroom of socket buffer is
> insufficient to store the attribute header and payload, the return value
> will be NULL. It will cause null pointer dereference when entry is used
> in nla_nest_end().
> 
> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] ethtool: tunnels: check the return value of nla_nest_start()
    https://git.kernel.org/netdev/net-next/c/05cd823863fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


