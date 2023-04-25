Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F16B6EE458
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbjDYPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbjDYPAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0994C0C
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 08:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91BBE61791
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F086DC4339B;
        Tue, 25 Apr 2023 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682434820;
        bh=5ocGzOe5VJa+ACjrOHaSG3wWI82wJq8YMsKVZNax/+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sRRy1V9ZHkiHgpdRY909ZNyVaQVp0K3eTj3RDD6ILqoH9crZqtHbFbV3SHHlr2WUy
         +9yKa7cDYGkBtIWg4gQ2oF9RUj+fN9DNGX5lGKXpb/TNDkY6sJr/iBeitjSgN3+Uix
         sGOqigqZ/9vYrMPf69PI0wm4VJTPKBKTrDD8tJfsedeoq8jhTUcYF+B/+MQ2Q3Qnv3
         JVbXk/IxwkAOnagiqeBKZdFfbfwCdzhuX2YYVlGTgaSQ2jN61DrvluVeS2fORdyidv
         8LytoIIzjAd6f3W76VUz1wPzTA9dtH4WaoTv1ZiO4C0MuSsXdpSjroi0qEneTL719B
         ltwg68R9Ynqiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6D75C395D8;
        Tue, 25 Apr 2023 15:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/2] bridge: Add support for per-{Port,
 VLAN} neighbor suppression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168243481986.8853.9982934533845896183.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 15:00:19 +0000
References: <20230424160951.232878-1-idosch@nvidia.com>
In-Reply-To: <20230424160951.232878-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, razor@blackwall.org,
        liuhangbin@gmail.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

On Mon, 24 Apr 2023 19:09:49 +0300 you wrote:
> See kernel merge commit 25c800b21058 ("Merge branch
> 'bridge-neigh-suppression'") for background and motivation.
> 
> Patch #1 adds support for a new "bridge vlan" option, "neigh_suppress".
> 
> Patch #2 adds support for a new "bridge link" option,
> "neigh_vlan_suppress".
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] bridge: vlan: Add support for neigh_suppress option
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5fe0aeb88427
  - [iproute2-next,2/2] bridge: link: Add support for neigh_vlan_suppress option
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9c7bdc9f3328

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


