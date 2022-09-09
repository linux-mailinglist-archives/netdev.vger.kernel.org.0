Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F2C5B34C5
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiIIKAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIIKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C564E1AAC;
        Fri,  9 Sep 2022 03:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27C5BB82488;
        Fri,  9 Sep 2022 10:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4C80C4347C;
        Fri,  9 Sep 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662717615;
        bh=R9HoZkbyWxn4PuY/EGkdbHSP+SI2XIe1jypjIPMcctk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HBbU8sCsNaTEB6DpP5uoIFyO4kgenhzHXOn4HBMEAUsyaf41fNpa39W3cT5w6Dhxk
         Zgm6inKPuXV6tGtv4zoVQfsnJRY58ugQwIiaSe37QJZurrgo0EhMHihngkIDIHJWnG
         O1VMmuYlC+dXaBLZXv257m9ViG4GNQpzN8L9g5CMAPyk4Uga6XKLh4FXqajKN7urbP
         769YgTR2Y5huITDyJ2gkVdaIHrXPB+6xmU4LOPFAR2wiQKGGbVzq88FomnM1x+1/pH
         IyrNfrNZbXxS2hiEBa3qct5d/jIuru1FwtBx5uIqCpfcpUoEskyz9Dvk+ilYb/0vLb
         L39paMzQN8VAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A264EE1CABD;
        Fri,  9 Sep 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166271761566.31452.4750616270687780718.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 10:00:15 +0000
References: <20220908095757.1755-2-fw@strlen.de>
In-Reply-To: <20220908095757.1755-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, iryzhov@nfware.com
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

This series was applied to netdev/net.git (master)
by Florian Westphal <fw@strlen.de>:

On Thu,  8 Sep 2022 11:57:54 +0200 you wrote:
> From: Igor Ryzhov <iryzhov@nfware.com>
> 
> ct_sip_next_header and ct_sip_get_header return an absolute
> value of matchoff, not a shift from current dataoff.
> So dataoff should be assigned matchoff, not incremented by it.
> 
> This issue can be seen in the scenario when there are multiple
> Contact headers and the first one is using a hostname and other headers
> use IP addresses. In this case, ct_sip_walk_headers will work as follows:
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
    https://git.kernel.org/netdev/net/c/39aebedeaaa9
  - [net,2/4] selftests: nft_concat_range: add socat support
    https://git.kernel.org/netdev/net/c/25b327d4f818
  - [net,3/4] netfilter: nf_conntrack_irc: Tighten matching on DCC message
    https://git.kernel.org/netdev/net/c/e8d5dfd1d874
  - [net,4/4] netfilter: nfnetlink_osf: fix possible bogus match in nf_osf_find()
    https://git.kernel.org/netdev/net/c/559c36c5a8d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


