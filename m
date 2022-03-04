Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861D14CD8FC
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbiCDQVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiCDQVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:21:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EF6160409;
        Fri,  4 Mar 2022 08:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDDD061D7E;
        Fri,  4 Mar 2022 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53219C340F2;
        Fri,  4 Mar 2022 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646410811;
        bh=0CgI4EyPQ3DSrNgA4EAA+Bcj2udpKg57T6VI4Q17lW8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mbCIYPc9uC+t+PrLOKazYEkrO67jPoHNt8uIe9SJ5t5xmbTYOl9JIT7dkGYecJ+w+
         lC5+upOS31pP12Zu9AszERqNrpDA1zIQDgifRtxQ5IKIj+Zm50xhXF0V02c6VrJ6Ct
         UmtFzDXAsBPw75JerRvgfl6Yb4/YXCmGemlNvGfn9OJxPJF6Ej2t3B20voFGJfai+d
         qE6i+HOcrKerdZkb99K3L/AB9Sh083CHcGc3BH5tRg0wGkYVh85N0umf8971Rt22UN
         I7CWHLKpY0Dfg59l9wQiNQekRjjNFgZUSRbPmw/sq21ocKKrAAv+v/Dind4xL95n2h
         G+M1nk0OvpoCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37F9CEAC081;
        Fri,  4 Mar 2022 16:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next V2 0/4] Add support for locked bridge ports (for
 802.1X)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164641081122.17358.2982887378090859629.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 16:20:11 +0000
References: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
In-Reply-To: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        schultz.hans+netdev@gmail.com, stephen@networkplumber.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 28 Feb 2022 14:36:46 +0100 you wrote:
> This patch set is to complement the kernel locked port patches, such
> that iproute2 can be used to lock/unlock a port and check if a port
> is locked or not. To lock or unlock a port use the command:
> 
> bridge link set dev DEV locked {on | off}
> 
> 
> [...]

Here is the summary with links:
  - [iproute2-next,V2,1/4] bridge: link: add command to set port in locked mode
    (no matching commit)
  - [iproute2-next,V2,2/4] ip: iplink_bridge_slave: add locked port flag support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=092af16b7eed
  - [iproute2-next,V2,3/4] man8/bridge.8: add locked port feature description and cmd syntax
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=d4fe36736dfb
  - [iproute2-next,V2,4/4] man8/ip-link.8: add locked port feature description and cmd syntax
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0a685b987c06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


