Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B554513A63
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350094AbiD1Qxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245310AbiD1Qxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495D017E16
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 406E5620DD
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96ABAC385AE;
        Thu, 28 Apr 2022 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651164612;
        bh=Z4INFzG9setL3n9yqsbTFBGFAfvYmvKAfSZTxrWEkqI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o0BIxnoceertPzoSxTl7D4hEhaeDFsz/scL577ECDC71yb9tfl/AS9wHP++PYIIWC
         jlKUAyVVZQj2gDKsuQ7aFrzcvwcHUvXo1liz6uKssEbJmwMMBYqE2suB+DKcN8iG3O
         JNRmNP9iWWhqzHc8PyA+bQ40omv9guec4BvE8WBRUuaqilY9ut68s5LoOrng7RZWjU
         lLQOtqWRUqRtmVkNCp/j5Z9pp0PH1P0YVpkyt94/WlR3neyrfpksswM8+/ZtpZZVek
         EqmXq4X2aZW6Q5/+5+oIoEvTDqPbLux3660VxmN2xZ/T9WTFY2fNRt13cjLUM4lnkj
         5fDkoqXGrYVQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D375E85D90;
        Thu, 28 Apr 2022 16:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: allow tc-etf offload even with
 NETIF_F_CSUM_MASK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165116461250.18870.3559010123385422525.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 16:50:12 +0000
References: <20220427203017.1291634-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220427203017.1291634-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, ioana.ciornei@nxp.com, claudiu.manoil@nxp.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Apr 2022 23:30:17 +0300 you wrote:
> The Time-Specified Departure feature is indeed mutually exclusive with
> TX IP checksumming in ENETC, but TX checksumming in itself is broken and
> was removed from this driver in commit 82728b91f124 ("enetc: Remove Tx
> checksumming offload code").
> 
> The blamed commit declared NETIF_F_HW_CSUM in dev->features to comply
> with software TSO's expectations, and still did the checksumming in
> software by calling skb_checksum_help(). So there isn't any restriction
> for the Time-Specified Departure feature.
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: allow tc-etf offload even with NETIF_F_CSUM_MASK
    https://git.kernel.org/netdev/net/c/66a2f5ef68fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


