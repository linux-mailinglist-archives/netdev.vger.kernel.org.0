Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0200B4B04C4
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiBJFK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:10:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiBJFK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:10:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF631290;
        Wed,  9 Feb 2022 21:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E7BF61BD6;
        Thu, 10 Feb 2022 05:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA581C340ED;
        Thu, 10 Feb 2022 05:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644469826;
        bh=jG+8oN4LoHSZaWsKjrfIIlQ8K2xsMFTYI+sx+Tegzr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jg3CGmG417EMQhS5eTlxcKBLR73TM83CNBEmrlLM8uj9ceFjyV6EdZU9By8XWvCbe
         27Ec7AijeTnoiAKh6AChvj25s23He2QS+aYBOlf2GPDDlW4OumM+OxY/1fMZ8uokpi
         kriMbK9S+pnK39hDm7DjeLqfCi/eEfLBLpJ33ryx5P4TTk9NBTSOu3G40KLvEyi0s6
         nnPlb5Gbwno2PHMEWN3vjINV96gOXggGR70YiYoastyNKpejvCezNCLFsy1LxSMBX3
         ho++CQIFgJdWeyaHEUtak/pzW6N83ha/Ht47IDFpxAMNODOV76mV7p7pWmCfy6lnfE
         zpsLIKHKRGD3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE103E6BB38;
        Thu, 10 Feb 2022 05:10:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-02-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164446982583.17467.10287224557605402281.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 05:10:25 +0000
References: <20220209210050.8425-1-daniel@iogearbox.net>
In-Reply-To: <20220209210050.8425-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Feb 2022 22:00:50 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 126 non-merge commits during the last 16 day(s) which contain
> a total of 201 files changed, 4049 insertions(+), 2215 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-02-09
    https://git.kernel.org/netdev/net-next/c/1127170d457e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


