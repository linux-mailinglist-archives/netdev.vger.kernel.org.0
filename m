Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922CC55C8F9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbiF0LAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiF0LAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B0010FE
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2E4861378
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04400C341C7;
        Mon, 27 Jun 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656327613;
        bh=R/Pifoto1pZVjob/g6TARWK7EJHOGdUrZ11AKPTOXtw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gBLTW21wYbx34IAxg1UCTbv+JoH7AhrIqu0cr/Sq+gb+0CVKiZOa+e4X4PWkgXIhx
         GN3eQPIx8NJVSK6BCI42wH9h4wFADQ2dires0D9vgPbC0ZvxeB4Xr13huAoyURErNo
         mXXhDdMaoQdGUniC6WLE4iH0M9+cmXqpBhFM/U69HvfNYHib3SWguB4kTa0vgnbpZH
         1QZ1P7tT+XB3EMfuy0idXVuyS86Ny0HyZmERF4u3brjgn4HUtl16nmG1Jblcszq3v7
         Z0weetbmlcknNLWds44TZ2EaoC8wzEEei02IhANQZMY/xh5I51iEIEzsemy5Q+qWNv
         KEuKhbtSvKFOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE38AE49BB9;
        Mon, 27 Jun 2022 11:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tunnels: do not assume mac header is set in
 skb_tunnel_check_pmtu()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165632761290.13770.11448157520735942903.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Jun 2022 11:00:12 +0000
References: <20220624153020.3246782-1-edumazet@google.com>
In-Reply-To: <20220624153020.3246782-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, sbrivio@redhat.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 24 Jun 2022 15:30:20 +0000 you wrote:
> Recently added debug in commit f9aefd6b2aa3 ("net: warn if mac header
> was not set") caught a bug in skb_tunnel_check_pmtu(), as shown
> in this syzbot report [1].
> 
> In ndo_start_xmit() paths, there is really no need to use skb->mac_header,
> because skb->data is supposed to point at it.
> 
> [...]

Here is the summary with links:
  - [net] tunnels: do not assume mac header is set in skb_tunnel_check_pmtu()
    https://git.kernel.org/netdev/net/c/853a76148802

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


