Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D98603819
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 04:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiJSCa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 22:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJSCaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 22:30:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67736BC45C
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC4FCCE2009
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 02:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EADEC433C1;
        Wed, 19 Oct 2022 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666146619;
        bh=rqQosRbRCzHe1nqOWJ3OBbhDd++MD11oWbSNyfS3dJ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b3QluKTMBYmnD4o6H9YEOYK7UKFrA3/s74FHYXUzrHT6ZBZHASCOTAXVgZI51Hh3X
         ssnHxFgnM+c/ISo0XfU1ELCF9jYlbX3O2ASPwnP8xjh2LXHgtFZ0lKqpMLF145TuXd
         Jtonw/DD4ROTX/Vme/9rxwqkeBngUQ9g4YuUY+vSvKDps3gAuUDXhfa5pohKDSU7km
         OoFhdpV3Z0OEiMYOkmtTRH/Xbr3F8vxzlQ27eMkCk3VI7tkgbT8LWqI/gA42SJY8em
         rriKyY774gOynW3cBwcLZS2gusTVFtWBx5JQOKFfdhs/99gVxo399oMzikaT2D3ovL
         0B76r9JAtPVxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8750E21ED4;
        Wed, 19 Oct 2022 02:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hsr: avoid possible NULL deref in skb_clone()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166614661887.8072.13155281035587226747.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 02:30:18 +0000
References: <20221017165928.2150130-1-edumazet@google.com>
In-Reply-To: <20221017165928.2150130-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ennoerlangen@gmail.com, claudiajkang@gmail.com,
        george.mccollister@gmail.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Oct 2022 16:59:28 +0000 you wrote:
> syzbot got a crash [1] in skb_clone(), caused by a bug
> in hsr_get_untagged_frame().
> 
> When/if create_stripped_skb_hsr() returns NULL, we must
> not attempt to call skb_clone().
> 
> While we are at it, replace a WARN_ONCE() by netdev_warn_once().
> 
> [...]

Here is the summary with links:
  - [net] net: hsr: avoid possible NULL deref in skb_clone()
    https://git.kernel.org/netdev/net/c/d8b57135fd9f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


