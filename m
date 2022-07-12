Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D762657112E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 06:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiGLEUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 00:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGLEUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 00:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370E31EAED;
        Mon, 11 Jul 2022 21:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B4A36173E;
        Tue, 12 Jul 2022 04:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 033EAC341C0;
        Tue, 12 Jul 2022 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657599613;
        bh=4H0bkGxWSSsie0BVeoNJnqRB/SBsjox3JB5tCjMiNes=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jTU3aHGqBansHKLzRi3uBpKvjSmAnfSUnXaObmwFYpHux02+ih4zJtYyHM8psGUI/
         QSLuTJmWZMJmuZy1KHmH7WJWHcuwBM6CWmcOpsn5UUFq0l1VppNhKWRTz2ZSDbKXdp
         zIsxOaF7tzrq6eDmQRxd7PxjHpgPLrPXv83vJicUM3qon7qYfsI8CfldhENsUcmbyW
         3C+AMiSnbrTZoZrzAoRozEq1sFF6XAZ5W1nsq+Dk+vttJN8Ds0edcjEiPhJ+eIwyrx
         7y87eYagwE4N7pseQzWg1lhjoNQ9F7wXZ/u7rZ44qWokPIbI2H5zT1dcsMtz2bDOwz
         wos2wTOxgZ/Yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5765E45221;
        Tue, 12 Jul 2022 04:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [bpf-next PATCH] samples/bpf: Fix xdp_redirect_map egress devmap prog
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165759961286.28741.8864645229977611264.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 04:20:12 +0000
References: <165754826292.575614.5636444052787717159.stgit@firesoul>
In-Reply-To: <165754826292.575614.5636444052787717159.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, tstellar@redhat.com
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 11 Jul 2022 16:04:22 +0200 you wrote:
> LLVM compiler optimized out the memcpy in xdp_redirect_map_egress,
> which caused the Ethernet source MAC-addr to always be zero
> when enabling the devmap egress prog via cmdline --load-egress.
> 
> Issue observed with LLVM version 14.0.0
>  - Shipped with Fedora 36 on target: x86_64-redhat-linux-gnu.
> 
> [...]

Here is the summary with links:
  - [bpf-next] samples/bpf: Fix xdp_redirect_map egress devmap prog
    https://git.kernel.org/bpf/bpf-next/c/49705c4ab324

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


