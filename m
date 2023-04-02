Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07186D37D6
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjDBMaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBMaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC4FE1B6
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2447FB80E5D
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 12:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BF49C433A0;
        Sun,  2 Apr 2023 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680438617;
        bh=ZmbTJGeLyaOeYn0nH/2TK6WqCSE5oeWazJeXyH0vKxs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZIBmuXZFlSY7t2oD1gRuXfEfm8Hk8keKPSI6zVlqO2653y+eGwB77YL3eDe6vLqlG
         tHKux6OBmCtrOoYcCo+Bira0QEDYLupeFU9FcSkwfmVz06KPTEBin6jaU7it4IWbu1
         6sloVRnIM8Ta48RAKPuyK7WLQlqvPF5D5vlsCLwGFbobyBkE7pRJ4K679h4Hpj/WCr
         LBR6pg7TAQnaTgAqrfLoGMroyBVId2gPouCa9Kae9594XqXxESZeZOdSqOv5kBTSmh
         7HtcZc+dFHgK85s/oseL9zS0H4giV6Iq9x5CtoRsrGhRR+3FL/wWVTAfsMf/6213J5
         I3DrHZKEQerbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87827C73FE0;
        Sun,  2 Apr 2023 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: minor reshuffle of napi_struct
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168043861755.6785.1258865011097824583.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Apr 2023 12:30:17 +0000
References: <20230331044731.3017626-1-kuba@kernel.org>
In-Reply-To: <20230331044731.3017626-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
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

On Thu, 30 Mar 2023 21:47:31 -0700 you wrote:
> napi_id is read by GRO and drivers to mark skbs, and it currently
> sits at the end of the structure, in a mostly unused cache line.
> Move it up into a hole, and separate the clearly control path
> fields from the important ones.
> 
> Before:
> 
> [...]

Here is the summary with links:
  - [net-next] net: minor reshuffle of napi_struct
    https://git.kernel.org/netdev/net-next/c/dd2d6604407d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


