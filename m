Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36CF59FF02
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbiHXQAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbiHXQAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EC274E1B
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6525F619E6
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 16:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC05FC433C1;
        Wed, 24 Aug 2022 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661356815;
        bh=V6jU51XvFBOF+DZJziiIDJULZiA7cCemezdxkvqFmR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kave9auiqd7PjXihRhwaDdZAK1aYd3ccGBeJUTq3xJttxf//0HswWsYomN290xP15
         3awV45y1MAozZyABVE511x+XEE9HFjoM3KUYFzQ5OImta7fTwr47DEqXeFUFVTqOLM
         fceRKSN10030q48sgLk5z9MW/P2pwxc6uLoOTtyBTLvnH9YQILu33bdSg12Rjr6tT8
         /e3mXsLbbe6JUe0J5H5BvazHTT8j7RZkBS2PISl8RGIV3izaXp44Om6T8RxEnJinus
         2rLoO6F8tAe9ujN6F7UGgEXVcF4CM/K/bXa/hr2wYgIiaCNf225vPN/nLXWpZFKsR+
         x+vdUsvIpW9wA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86344E2A03C;
        Wed, 24 Aug 2022 16:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [iproute2-next 0/2] devlink: remove dl_argv_parse_put
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166135681554.11375.11013152056749467118.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 16:00:15 +0000
References: <20220818211521.169569-1-jacob.e.keller@intel.com>
In-Reply-To: <20220818211521.169569-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, corbet@lwn.net, jiri@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, stephen@networkplumber.org
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

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 18 Aug 2022 14:15:19 -0700 you wrote:
> This series removes the dl_argv_parse_put function which both parses the
> command line arguments and places them into the netlink header.
> 
> This was originally sent as an RFC at
> https://lore.kernel.org/netdev/20220805234155.2878160-1-jacob.e.keller@intel.com/
> 
> Since there is some ongoing work around policy code being generated from
> YAML, I thought it best to wait on the devlink policy portion of this series
> for now.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] devlink: use dl_no_arg instead of checking dl_argc == 0
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0ce6ae80c380
  - [iproute2-next,2/2] devlink: remove dl_argv_parse_put
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=8ed3d1687dc1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


