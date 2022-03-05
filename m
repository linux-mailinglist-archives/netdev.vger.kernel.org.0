Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA73D4CE286
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 04:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiCEDvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 22:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiCEDvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 22:51:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD63248CCA;
        Fri,  4 Mar 2022 19:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F4F1B80D07;
        Sat,  5 Mar 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51BACC340F1;
        Sat,  5 Mar 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646452214;
        bh=9Noe74znUTlSQ2LVYZqmqxjISIBD6ymH+uFe+CwXJK4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jrX7LGcYO2xP8rpMwd/C2sKqODmA78csTLYr0UL4BZiGwsBisjnIB7PYyMNQPaLrD
         kV3KLcISaGpEo3BzS3BZDFRrDw4dVjL7yxJo/UO7w4+0byLxdjS4DFafwreigTloZu
         MJdWKL7c37ysDwD65jRa+BWfm/bDs4gX3OkOaET7YY3UGv2sxeGsKb9ewFycmY2poz
         KQ3H2TiEHbEg3gr83Ig/gveH+u+pfmC+AmljxfdVm4AJT1LfcnBS7mc/222KVvJtFI
         ZZZRpJEdRrRCBbU3J/LeoLmZaHdnvPzdD0RRd8NzhkNbf6QGrg+U4GTG7iZzJJnqGJ
         6osi9L1pAZnfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B3D3E7BB18;
        Sat,  5 Mar 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-03-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164645221417.2975.11319882682056680040.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 03:50:14 +0000
References: <20220304164313.31675-1-daniel@iogearbox.net>
In-Reply-To: <20220304164313.31675-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
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

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  4 Mar 2022 17:43:13 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 32 non-merge commits during the last 14 day(s) which contain
> a total of 59 files changed, 1038 insertions(+), 473 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-03-04
    https://git.kernel.org/netdev/net-next/c/6646dc241dd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


