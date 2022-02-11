Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9DE4B251D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349817AbiBKMA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:00:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239402AbiBKMA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:00:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E912F4E;
        Fri, 11 Feb 2022 04:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A23F8B82963;
        Fri, 11 Feb 2022 12:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB443C340F5;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580814;
        bh=fOys6QnTDTRCo5I3/Wrb/J4asiTQG4aJqxGwoWTg1m4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QlMoUVwHLpXahhpW4FvTif/XzGh3ezwqmRw7BYpnDv3RPHgFreWRmGmvItSKicRRE
         Epi++wJ/bqleTOH+Y36S63iaN0Tyxd5khT1QMuSERbn71xYHuxntgtJt2rnss31BUm
         LZUL0siDuYgiXUqTk/rqYxuL3dlRQVfEXc54SgdXae2IB4lc8VYtbAF2wJVVq77oah
         lHzKzQygDm+gJ9DW5mYWKrEIVDpoll+SKK2LOHdsnMDNVWKIktHBOcD6jlk/Ssfc1u
         qG5m6t6Jp/NZ7vbJkw2tgeG+MoFGb8uABeCtxmhDHNnlKxEalQ49HRv81FkBDOv4/e
         grNrlcyiiPHHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D38E2E5D09D;
        Fri, 11 Feb 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: Reject routes configurations that specify
 dsfield (tos)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164458081385.17283.4661621446713469533.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 12:00:13 +0000
References: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
In-Reply-To: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, toke@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 16:08:08 +0100 you wrote:
> The ->rtm_tos option is normally used to route packets based on both
> the destination address and the DS field. However it's ignored for
> IPv6 routes. Setting ->rtm_tos for IPv6 is thus invalid as the route
> is going to work only on the destination address anyway, so it won't
> behave as specified.
> 
> Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: Reject routes configurations that specify dsfield (tos)
    https://git.kernel.org/netdev/net-next/c/b9605161e7be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


