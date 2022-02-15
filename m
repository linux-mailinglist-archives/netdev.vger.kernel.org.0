Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C1B4B6F0F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbiBOOkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:40:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbiBOOkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B644102429
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C265CB81A65
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D723C36AE2;
        Tue, 15 Feb 2022 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936011;
        bh=2pWXvIYc5BMqHgedXAQ3xy308zVIOyzShoIa+Jx2OB8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qWvAyKbMAxfvT3Ufe5uPxjX5R75UqD7DgRiGbEnlQBMgtIxLsQ5QXmroio+UksfD7
         TF1XRyIKrEWOsIezDXYTa0RiMweLh5r23iZRDFoyNEPAmyIqwvXtLDLTXUhQe3oMI3
         WpwY0/UNyZ5TTgYIzG25xsOr61PEj/o0zZ5GnHJgbEwFc07a009cen/0rFIwB3+t2R
         UKsHsPPD1UKoU70wAji2KRp/Pcn7F11Q//u9xbg/mEPAbHd9Loc9qSFy3je2/PAffu
         OCfIwsLiVgS9iBUOzubfJIqmJN8/6dLEQVsStt0Vj7im3+K98ZboV4inoDAfhqvMhb
         FSH5eC7gSuidg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F057FE7BB03;
        Tue, 15 Feb 2022 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: fix data-races around agg_select_timer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493601098.31968.7341649847340107428.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:40:10 +0000
References: <20220214191553.806285-1-eric.dumazet@gmail.com>
In-Reply-To: <20220214191553.806285-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com,
        j.vosburgh@gmail.com, vfalico@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 14 Feb 2022 11:15:53 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported that two threads might write over agg_select_timer
> at the same time. Make agg_select_timer atomic to fix the races.
> 
> BUG: KCSAN: data-race in bond_3ad_initiate_agg_selection / bond_3ad_state_machine_handler
> 
> [...]

Here is the summary with links:
  - [net] bonding: fix data-races around agg_select_timer
    https://git.kernel.org/netdev/net/c/9ceaf6f76b20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


