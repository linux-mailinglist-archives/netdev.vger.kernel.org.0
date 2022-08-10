Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FB558E6AC
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 07:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiHJFUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 01:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiHJFUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 01:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA5911827;
        Tue,  9 Aug 2022 22:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31AA46139D;
        Wed, 10 Aug 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8056FC433B5;
        Wed, 10 Aug 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660108814;
        bh=wsNTGS5mqawU5IBn8lD522AphvbQgN0m47XyTT02jME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fC1RxVpl3lCXzffaQdNSdbbaPk04qCWVcAzfZdNxRdmpCI549djwSug5eXGWFqkGi
         hz46D1kCCb10AO5+WmWYyk12GwvVSJVYGxbf1Z/dsxO3Rw+vp2l0P0DwODcyhdyVp1
         bJ8/dYS0dwrTEfzWE25w3i7TnFEf/YF67aLtVK0xMxzK12hXBYd5ZfV86fsDRSrEn2
         MwkyciUM7/4E6qRibHgXbi685QesKRNnsIINWok1016WzSg87R34xG+wZit9mh8nr7
         WJOgoyKwawsgovUe7obOOI+O2tJ5LGfFszpNl0WvIpp4YuH+u/Q8ShdJpMDbKXk4Hu
         PhSBFp9tzGqkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60C33C43143;
        Wed, 10 Aug 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net] geneve: fix TOS inheriting for ipv4
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166010881439.23810.10295800280748066950.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 05:20:14 +0000
References: <20220805190006.8078-1-matthias.may@westermo.com>
In-Reply-To: <20220805190006.8078-1-matthias.may@westermo.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, linux-kernel@vger.kernel.org,
        jesse@nicira.com, pshelar@nicira.com, tgraf@suug.ch
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 5 Aug 2022 21:00:06 +0200 you wrote:
> The current code retrieves the TOS field after the lookup
> on the ipv4 routing table. The routing process currently
> only allows routing based on the original 3 TOS bits, and
> not on the full 6 DSCP bits.
> As a result the retrieved TOS is cut to the 3 bits.
> However for inheriting purposes the full 6 bits should be used.
> 
> [...]

Here is the summary with links:
  - [v4,net] geneve: fix TOS inheriting for ipv4
    https://git.kernel.org/netdev/net/c/b4ab94d6adaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


