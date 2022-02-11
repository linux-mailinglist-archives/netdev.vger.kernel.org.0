Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502F04B253F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349836AbiBKMKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:10:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349830AbiBKMKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:10:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5145D5A
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 04:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3717D61C17
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 918EEC340F0;
        Fri, 11 Feb 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644581410;
        bh=cM9Inm/yaUYpHAdhChoHnd/8NgSezw4HNCDl0S8cU40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZSgWtR1yZLcPrJ84z4P4XvS4fIbVF8VSWWTESnBS9ljPvhkYVZH1oRZO83XxCDfLn
         f7x4bX0DwNe1jQwrCyaMZ2G5gOY88h6skOK0fxTdfKWByFFzoiWt43GXx9XzNNTj54
         BlX9OxpN6p04oAyni7QpYtYQffKxPRdL3MZEsYef/37cNGcS1/Vg0HzgiYZKYPYDcg
         ZCvTyLtw5M8raj5QAPl8jXm4pbSB4n1A5GzDyEA3M2psfhfiMRfhwHM7/cdaBa3zCD
         1smfdrujIAXf6lpfI1TrpyTJZCGLqzWWwqIaaEOsKplW5RbR2Mh1hZ5AdbOFPkoUul
         8RZLNqMF2ql7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 779E8E6D3DE;
        Fri, 11 Feb 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] drop_monitor: fix data-race in dropmon_net_event /
 trace_napi_poll_hit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164458141048.22011.7576149530061831253.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 12:10:10 +0000
References: <20220210171331.1458807-1-eric.dumazet@gmail.com>
In-Reply-To: <20220210171331.1458807-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, nhorman@tuxdriver.com,
        syzkaller@googlegroups.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 09:13:31 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> trace_napi_poll_hit() is reading stat->dev while another thread can write
> on it from dropmon_net_event()
> 
> Use READ_ONCE()/WRITE_ONCE() here, RCU rules are properly enforced already,
> we only have to take care of load/store tearing.
> 
> [...]

Here is the summary with links:
  - [net] drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit
    https://git.kernel.org/netdev/net/c/dcd54265c8bc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


