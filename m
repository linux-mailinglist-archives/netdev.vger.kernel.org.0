Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545B64D6D26
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiCLHBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiCLHBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:01:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEFE26C29B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 23:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1069D60C13
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 07:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6941BC340FC;
        Sat, 12 Mar 2022 07:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647068411;
        bh=XbGhhuRuWJ1Zqzbn8XR3W/pzC0aiOsElXIjERvnD9JI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RvLCSw6aX29Hnh4XncwDrV/qV0QkYpRkftdfHQ2oZ+71nN0QiTh8M1gpK2V4fJWoi
         iXvobFekkF9sm6X/u+EyIhsZV1oqMmkRSr7VV//DzQz08oSLPz0bKfG6BlOI0xaFZm
         r2A7XdJm1VxD5oiR7MOPpTKIB/Q+ZyPS+UmB2gTIguw+piQp0k/hIz2CITfd7zWyee
         xPzhX6ZJjO/8VrITrBXus48f9JKy0tWVG6VHW8DOejJRtBiOdoxCel0scw3GOnETYI
         f/KpSbyB5opIAZAMyBhAgIkEKhkGr5I0BETlI4aaLlg/5qXIXoLpy9r69VKGlZ3cJG
         znCN/WYc2yoHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 495FBEAC095;
        Sat, 12 Mar 2022 07:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: remove exports for
 netdev_name_node_alt_create() and destroy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164706841129.27256.12259173997856018240.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:00:11 +0000
References: <20220310223952.558779-1-kuba@kernel.org>
In-Reply-To: <20220310223952.558779-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dsahern@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Mar 2022 14:39:52 -0800 you wrote:
> netdev_name_node_alt_create() and netdev_name_node_alt_destroy()
> are only called by rtnetlink, so no need for exports.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/dev.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: remove exports for netdev_name_node_alt_create() and destroy
    https://git.kernel.org/netdev/net-next/c/2387834dd228

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


