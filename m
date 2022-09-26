Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A95EAFA9
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiIZSXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiIZSXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:23:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A161FC55
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27E91611C6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85614C433B5;
        Mon, 26 Sep 2022 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664216415;
        bh=VYB/5dym9Yiwie3/Gg3Hlntt5mxVmFrQNGl7qqm36jk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gzpENh2gNfRpTtG8AXZ6Pr3b5utMg0KUVVQGW+p61Nxphe4eVAyaMLIALjJPWyiNQ
         3uBFxXOKKLrVhoUPMCjItlUrlR1y44Z7GOyY7i8Bp+QJj+ztdRcdOjFH1uDDp9NZqH
         n4ftl5FCMGoZG6o3YZPfz5Gsadj9G2hKlodaxWzdFbbptSP2SAh2cZJc/QHcxqDvhp
         yceNioDvv519E/js46wc7Be4TbBQJuUrQP1fd87MyQIX+VRQ4f3qvAyeihqkzQC8Xs
         1/t6L0LZBRBCb3yNOBRZn5qIk/c97UMyvAyeJU1s5x/5Z27W3lku2G8cNCJ1Si7U1Y
         l4W6+4ujdQ41A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A9D4C04E59;
        Mon, 26 Sep 2022 18:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] macsec: don't free NULL metadata_dst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166421641543.6513.1281254546537565542.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 18:20:15 +0000
References: <60f2a1965fe553e2cade9472407d0fafff8de8ce.1663923580.git.sd@queasysnail.net>
In-Reply-To: <60f2a1965fe553e2cade9472407d0fafff8de8ce.1663923580.git.sd@queasysnail.net>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, liorna@nvidia.com, raeds@nvidia.com,
        saeedm@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 23 Sep 2022 11:07:09 +0200 you wrote:
> Commit 0a28bfd4971f added a metadata_dst to each tx_sc, but that's
> only allocated when macsec_add_dev has run, which happens after device
> registration. If the requested or computed SCI already exists, or if
> linking to the lower device fails, we will panic because
> metadata_dst_free can't handle NULL.
> 
> Reproducer:
>     ip link add link $lower type macsec
>     ip link add link $lower type macsec
> 
> [...]

Here is the summary with links:
  - [net-next] macsec: don't free NULL metadata_dst
    https://git.kernel.org/netdev/net-next/c/c52add61c27e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


