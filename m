Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DC94E1E49
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 00:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343804AbiCTXlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 19:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243703AbiCTXlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 19:41:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9030C12AD7
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 16:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF5961277
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 23:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5612AC340F0;
        Sun, 20 Mar 2022 23:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647819610;
        bh=vZiiA+8ubsF39Io/mWZI7vjibw4gCVG86bX8eet12+k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DIBKiu3sUFXo6nufuiUICrejQ2NzFESQnYSjlPDWFJ5MMSqJWRmBR1YBxHxj1kytC
         53Lhc6lvg3rPaqP74XY3wpdaxn5eDE9Xtzk80IB4eI0lddi9urgWquYJFAhLb5DmzZ
         jcpEeTuh4aa72FIVspBTSMqTp9W8EAjtxx5vhhrOD/I1xXZPPb4M6jhZ2UAxCmel2Q
         W/6a756lRuoD9ZtN3IDE0JsCZjdKOGJdVb+x+0R8iMSW7lk5Sxudc8n3PKyVx1Kvjj
         rm+Pr70zHEilUgu2SRv9OilnK+PtyW8jB1eC7ykdtC+2dwh/d2G+MMzVtT5XdwJPY7
         xkpB3v2zLwwHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35565EAC09C;
        Sun, 20 Mar 2022 23:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/2] bridge: support for per-port mcast_router
 options
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164781961021.5687.13605478498204363634.git-patchwork-notify@kernel.org>
Date:   Sun, 20 Mar 2022 23:40:10 +0000
References: <20220316090257.3531111-1-troglobit@gmail.com>
In-Reply-To: <20220316090257.3531111-1-troglobit@gmail.com>
To:     Joachim Wiberg <troglobit@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, razor@blackwall.org
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 10:02:55 +0100 you wrote:
> Hi,
> 
> this patch set adds per bridge port mcast_router option.  I.e., the
> ability to control how IGMP/MLD snooping learns of external routers
> where both known and unknown multicast should be flooded.  Similar
> functionality per-port and per-vlan setting already exist.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] bridge: support for controlling mcast_router per port
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9e82e828764a
  - [iproute2-next,2/2] man: bridge: document per-port mcast_router settings
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=e48808692b6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


