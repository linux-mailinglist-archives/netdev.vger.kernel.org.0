Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0A55900E
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiFXEkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXEkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2479051598
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 21:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7787B8266D
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 04:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56126C341C8;
        Fri, 24 Jun 2022 04:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656045612;
        bh=l2k5XgcIJO22hLXLvf0SYahAPqArunUmMJM/XV2EIj4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GDHngmy8E0fFminG7aL6xya2jPFapZAbnQ52eqHsK1tHHr8c997fQru+dcmcuoSaD
         PoPj4rJxUkst9JYXbngK7AFM5S0o5aDEg/+LAaKW3NwAxDfMT0YQS7ZWCLfkVmtJV3
         vYJJmjUtATx/RkTbXbTMiHLkqKA88qnq2/ZophgYpnhhJTVgsZ5VzMIjYx16Yq+ND5
         +TVqZmbvbrJ4UFMH6dFN6VBSFkP0jaBNoVKw/AJcpHdceYeIcdNoQGrAOqt5/xPbDx
         PIGBZL++G+/FGUJch/nIdICm9jexH2+SwrDeYhCu0PyRTQL0RM7pSlogLNmUsi9mSp
         5CEEw/EVeFOQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D820E8DBCB;
        Fri, 24 Jun 2022 04:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP
 test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604561224.12661.4099812222999550952.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 04:40:12 +0000
References: <20220623000234.61774-1-dmichail@fungible.com>
In-Reply-To: <20220623000234.61774-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, willemb@google.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 17:02:34 -0700 you wrote:
> udpgso_bench.sh has been running its IPv6 TCP test with IPv4 arguments
> since its initial conmit. Looks like a typo.
> 
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> Cc: willemb@google.com
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> 
> [...]

Here is the summary with links:
  - [net] selftests/net: pass ipv6_args to udpgso_bench's IPv6 TCP test
    https://git.kernel.org/netdev/net/c/b968080808f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


