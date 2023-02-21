Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE11569D788
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbjBUAa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBUAa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:30:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342451E5F8;
        Mon, 20 Feb 2023 16:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C771460F59;
        Tue, 21 Feb 2023 00:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A956C433EF;
        Tue, 21 Feb 2023 00:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676939425;
        bh=N4UMs9K3Q6FcoB3O3WnUZxZAbNJLgrg1AGUpLiW3hhQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YOPab8DASIgcFXkrU2x6y+YORDfX9mmbWCmquks6wth/VbpSLTI/sKU9CxgsdjTjJ
         bJ7DKigqLGAuu0Cs0NCWT4A36hZAAe6ZCcpJnW2XUUwEsR0juodxBxof+8egmx7vJ6
         7eFk+v3TrPPXjiFFZ4OC8g9O8egehgtYaaE7iMtjQ3TcofzDWLxzSO5O2w+H/TBJir
         IPeeptixOvldmtgHEZmiufKP0omxseAN6W2yExH7sEpudQUUAyUSO0dVL8OfrK05dQ
         EuyTWWeYx/SXkUAlfwoKNWfI/XwYiaQd9TLcVu2ClSjiJlmc77HtYufm0u9813Lkqz
         qdbUC66VqZOJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D469C43161;
        Tue, 21 Feb 2023 00:30:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-02-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167693942504.32365.4790420951036402826.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 00:30:25 +0000
References: <20230217221737.31122-1-daniel@iogearbox.net>
In-Reply-To: <20230217221737.31122-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org,
        aleksander.lobakin@intel.com, maciej.fijalkowski@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Feb 2023 23:17:37 +0100 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 64 non-merge commits during the last 7 day(s) which contain
> a total of 158 files changed, 4190 insertions(+), 988 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-02-17
    https://git.kernel.org/netdev/net-next/c/7b18fa097af1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


