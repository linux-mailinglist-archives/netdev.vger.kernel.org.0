Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13F554C3AE
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346109AbiFOIkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345319AbiFOIkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8664A3F7
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD798619B3
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A146C385A5;
        Wed, 15 Jun 2022 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655282414;
        bh=1j1QlHsweRQpSIOaeIQBsKEDbgMrSyrzc3tKZkj01H8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=roFPwdylpj8k5wOUNUIw6kRjxY4Ja4UmUGFwuQ3K8gRfapYOPYH7XnUKKMauOEml5
         oBq9tnoD7wpwTZT0XnLeK3r42+XqscrPH/ECZDimRC3ovozzAbvQ8Co/NMjLYHzLID
         epDDZvPmrOU59XYPTQ5oRo8fqruYw7hDjcbhmMp6L3uMrZ4KAXrV+1W4Qr9kyTgqzi
         OLLT8tgfzXSbKhAMtmwu+dNl1XAa/DAuxMp8keMVPvxxLHGMb5629mwTeKXP4CyvM8
         7Mn4/IjEo4teKNRKoN9+bpxujQKswNg4m8Oh+aITrnhOwJ6g1bDZv2Xd/Piw2z1cms
         jpXejrhaA/stA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27FF9E73856;
        Wed, 15 Jun 2022 08:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: allow add/remove permanent mdb entries
 on disabled ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165528241416.21469.7301652675572375354.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 08:40:14 +0000
References: <20220614063223.zvtrdrh7pbkv3b4v@wse-c0155>
In-Reply-To: <20220614063223.zvtrdrh7pbkv3b4v@wse-c0155>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        roopa@nvidia.com, razor@blackwall.org, edumazet@google.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        tobias@waldekranz.com, troglobit@gmail.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 14 Jun 2022 08:32:23 +0200 you wrote:
> Adding mdb entries on disabled ports allows you to do setup before
> accepting any traffic, avoiding any time where the port is not in the
> multicast group.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  net/bridge/br_mdb.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] net: bridge: allow add/remove permanent mdb entries on disabled ports
    https://git.kernel.org/netdev/net-next/c/2aa4abed3792

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


