Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FBB5ACEBD
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiIEJUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbiIEJUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CC41EEEE
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 02:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 534AA61196
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 09:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAF75C43151;
        Mon,  5 Sep 2022 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662369614;
        bh=RCCV5oL5XnH8hnlFvUNa6JVYeWdvMCjlTm4W0lwUtXs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bwrcAjVxmxreoeYg2PtM3fg67syG1+TSFYwHrhGAR+e3EblMx5g/g7rWyziTW6zGe
         WxhZB3OhAilGHjwCQiXTvWDV9XmwdsmNrDULABPFehEyc+5DDeEHvSIEHIml/+pXwx
         MzJEPTQ6YgewqIhCkLVN5gkwLhQvDBtZ6SLkkdTRMr0ZRwY36TrD8OcP73WRQ3AOYo
         zOWMF7UQrWl2IGJuKYUkm4gs3JWukPQvzCx9MAc6CIWiGQ86dnvs6tBVonwjMl6zSL
         myS9P3xUkSvyJoVW3t1nmeT4bsLIM45svg7asxciyI5MIBQGvLRZ/xUIUuYtxu4BA3
         cKHaKWY3QLxMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79A4AC4166E;
        Mon,  5 Sep 2022 09:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net 0/3] bonding: fix lladdr finding and confirmation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166236961448.25096.10408618632391937070.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 09:20:14 +0000
References: <20220830093722.153161-1-liuhangbin@gmail.com>
In-Reply-To: <20220830093722.153161-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        jtoppins@redhat.com, pabeni@redhat.com, dsahern@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Aug 2022 17:37:19 +0800 you wrote:
> This patch set fixed 3 issues when setting lladdr as bonding IPv6 target.
> Please see each patch for the details.
> 
> v2: separate the patch to 3 parts
> 
> Hangbin Liu (3):
>   bonding: use unspecified address if no available link local address
>   bonding: add all node mcast address when slave up
>   bonding: accept unsolicited NA message
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/3] bonding: use unspecified address if no available link local address
    https://git.kernel.org/netdev/net/c/b7f14132bf58
  - [PATCHv2,net,2/3] bonding: add all node mcast address when slave up
    https://git.kernel.org/netdev/net/c/fd16eb948ea8
  - [PATCHv2,net,3/3] bonding: accept unsolicited NA message
    https://git.kernel.org/netdev/net/c/592335a4164c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


