Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B15677A09
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjAWLUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjAWLUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:20:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BCD23668;
        Mon, 23 Jan 2023 03:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE1B3B80D35;
        Mon, 23 Jan 2023 11:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 771B0C4339B;
        Mon, 23 Jan 2023 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674472817;
        bh=LKlHSxZU3iVSWcUpLvbc/tVcJeUoPLixwFBliQ5yQHA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=laSFsYMlepytkKmzZ5suzIeLiKXmeM5GVCgsfykskvMSmKzYUMkA5vXZxqmdvNot5
         fU+LnHu9o0Wd4ksbM89ovBHQ/4lj1EesWCXh+RvjWr6gT9+UhKNaH5YlvmvAznzMpY
         IEuXOavn/NQnK/KDl8z0vGMOaDvdDG6wht4X36xM4QrMGRNdFTD46EPvweuZ7bUxBy
         2HvzIg5Oq0WqdW+ozjwDGqIUcehlkcQfQOQ6X4zY386Y7v7/R3QY9YsyZT+b8MOGix
         wcnluNP8c14Yl+toZiR2oJqLo0EduEloGUd/iowGI4ww3vUv4BVJNAT9YhGP4tBI9w
         oKijZGDKPH/Eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B397C5C7D4;
        Mon, 23 Jan 2023 11:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: fix reachability confirmation with proxy_ndp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167447281736.14272.18315324318489774078.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 11:20:17 +0000
References: <20230119134041.951006-1-gergely.risko@gmail.com>
In-Reply-To: <20230119134041.951006-1-gergely.risko@gmail.com>
To:     Gergely Risko <gergely.risko@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 19 Jan 2023 14:40:41 +0100 you wrote:
> When proxying IPv6 NDP requests, the adverts to the initial multicast
> solicits are correct and working.  On the other hand, when later a
> reachability confirmation is requested (on unicast), no reply is sent.
> 
> This causes the neighbor entry expiring on the sending node, which is
> mostly a non-issue, as a new multicast request is sent.  There are
> routers, where the multicast requests are intentionally delayed, and in
> these environments the current implementation causes periodic packet
> loss for the proxied endpoints.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: fix reachability confirmation with proxy_ndp
    https://git.kernel.org/netdev/net/c/9f535c870e49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


