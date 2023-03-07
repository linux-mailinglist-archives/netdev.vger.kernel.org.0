Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8906AD63B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 05:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjCGEfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 23:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjCGEfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 23:35:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4279E49893;
        Mon,  6 Mar 2023 20:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD04B815B3;
        Tue,  7 Mar 2023 04:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B4EAC4339C;
        Tue,  7 Mar 2023 04:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678163720;
        bh=DJhWYYmH2FfF7Qp3fzUUG3PNXIpTjkaC4Hj8bOWkuI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LhGb0dW+ruGdpIS5uHBRqG09t9xSRV6FCmPkOQV+KtnWD56SZE8uKLNQijkurVTU8
         biO3Ywb31RbkvlttFjZGFwYZHWnGdDmAasnr/87FTvZ3I8hJXWFBuInhhTH3EPNu8A
         W1eCpt68tZcPWoRJzd0WnUPEI7ooFVmW8ItG5Tg/SpaJk++8IxMyM9xqBUhjXqMVfZ
         U/efTJP1OhK+Ic/Sg4A/9q0VflkWgHf8LLA778h1TiXUFPMgVvKQyyDr9ASJkJZRft
         hkxIm2g8wyBqn6V53F5JcC4V9jZa4fSgM/msOIc8H9zsnNimA5lmeIRWoOWusUeljG
         p7vo+X/sBh8Ig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7EF04E61B63;
        Tue,  7 Mar 2023 04:35:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-03-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167816372051.12713.8574521202926153502.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 04:35:20 +0000
References: <20230307004346.27578-1-daniel@iogearbox.net>
In-Reply-To: <20230307004346.27578-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 01:43:46 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> There is a small conflict once net tree gets merged into net-next
> between commit b7abcd9c656b ("bpf, doc: Link to submitting-patches.rst
> for general patch submission info") from the bpf tree and commit
> d56b0c461d19 ("bpf, docs: Fix link to netdev-FAQ target") from the
> bpf-next tree. Follow Stephen's resolution:
> https://lore.kernel.org/bpf/20230307095812.236eb1be@canb.auug.org.au/
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-03-06
    https://git.kernel.org/netdev/net/c/757b56a6c7bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


