Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DA5598A99
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345231AbiHRRkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345205AbiHRRkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:40:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BBE67475
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBF21B82371
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F01CC433D7;
        Thu, 18 Aug 2022 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660844436;
        bh=koYa1W4C98vFOHutP4xLmkXmJ7nhmSq1mGwp11npmro=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dNdjB8wmt+IwuJP9syIgFw2YrHa8lmEtGppIk5S0Kijhbun5xfCwujm31UIzDCGwY
         7GAyE36tBGXSDjJXm4rb+yTpWeK79ddy91ti+lCxtgZJFNT74fP2f/FAwFaC3+SC0V
         XGpeRgzpkT9lCO04KTbdWfyl97uRp/3HZm2ge5R1agrsdRTiJReo9CNS88UsiX6pTj
         GvuRn3haNInYV5aQDxkXXNyF3sJQ1JGRxvHKIEXcDvVYxYBcuzFAaXhG2P/sFQZ2Aq
         jnkSOCXs+zYuHxU8GqHOOYI6u2EJ/aYPDmb4fJKwOcN+nsJAs8Tt+leEyxD7DP+zaY
         oSIHeFiXlFZEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54513E2A04D;
        Thu, 18 Aug 2022 17:40:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: genl: fix error path memory leak in policy
 dumping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166084443634.19225.9191540052371490972.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 17:40:36 +0000
References: <20220816161939.577583-1-kuba@kernel.org>
In-Reply-To: <20220816161939.577583-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com,
        johannes.berg@intel.com
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

On Tue, 16 Aug 2022 09:19:39 -0700 you wrote:
> If construction of the array of policies fails when recording
> non-first policy we need to unwind.
> 
> netlink_policy_dump_add_policy() itself also needs fixing as
> it currently gives up on error without recording the allocated
> pointer in the pstate pointer.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: genl: fix error path memory leak in policy dumping
    https://git.kernel.org/netdev/net/c/249801360db3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


