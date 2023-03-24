Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A11F6C7A9D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjCXJA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjCXJAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010DD10F9
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90936629C4
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 09:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD563C433D2;
        Fri, 24 Mar 2023 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679648417;
        bh=8WjUkVCxv20ohschq7cmonRNvxtHEImYIntPN+2ukdA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uJFIqni5aSzToQz9O+1b3zSTLjZ+bJBh3On2c6iDRkt9kxhbqQ8WB5OwzNTk/Bzpc
         qChjGeV1/jXpp6PtmEUYgsG/eXBCWq/hs6NV/dsfDA9GB6eh0d124y4L9yTfEarOL0
         tugrWKymxiayohZvICyqlGzcYVvvS0w0CjoLV+ci63JD2cZMBzCqgb++WLAtmFlt+m
         rq+VvN7Dd1sYkiGD3d8BE5+DKvOHS2j0D+Nu23klArJ7aQZil2c4zLVkXQCKqhKDbY
         zh/kwt6wolx3wukXmZxeoBeaYI9E5fOu8rgkvXuMqBodzGEIDKKSyDWO62a/gJ8AAu
         ZaB+RX+K4kc3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFA70E2A039;
        Fri, 24 Mar 2023 09:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: prevent router_solicitations for team port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167964841778.27836.1645024158050945471.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 09:00:17 +0000
References: <7c052c3bdf8c1ac48833ace66725adf1f9794711.1679528141.git.lucien.xin@gmail.com>
In-Reply-To: <7c052c3bdf8c1ac48833ace66725adf1f9794711.1679528141.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@resnulli.us
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Mar 2023 19:35:41 -0400 you wrote:
> The issue fixed for bonding in commit c2edacf80e15 ("bonding / ipv6: no
> addrconf for slaves separately from master") also exists in team driver.
> However, we can't just disable ipv6 addrconf for team ports, as 'teamd'
> will need it when nsns_ping watch is used in the user space.
> 
> Instead of preventing ipv6 addrconf, this patch only prevents RS packets
> for team ports, as it did in commit b52e1cce31ca ("ipv6: Don't send rs
> packets to the interface of ARPHRD_TUNNEL").
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: prevent router_solicitations for team port
    https://git.kernel.org/netdev/net-next/c/2df9bf4d04d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


