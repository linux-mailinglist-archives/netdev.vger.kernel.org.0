Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51504E24CF
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346556AbiCULBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346553AbiCULBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:01:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB60589321;
        Mon, 21 Mar 2022 04:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3280FB8124B;
        Mon, 21 Mar 2022 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAE19C340F3;
        Mon, 21 Mar 2022 11:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647860410;
        bh=n6qC4hmVpj4wVG8saQK+2Vx0mlcjl2MotPLnb9j2Ah4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e9jjBk/m4GcECe2Y/ELBhccRNWRsggoHb9n/NvAs8SdSKbjwLgU4xAtBnWR7jb2Z5
         ZsJin8g4vLzmxXAFKL1/ugRQdXiOauwKfjhdGjx/+n8P/jGcsXYpaJVdwc70GGhyXp
         8nQ8U7w3EhsIqdaeyHA83+eAxi2qUHsGCA2O1MOPtrErBFDNs3B1F0CauGH1eLm4x4
         PC8tPELsAwIulIaqylAHHvSsh//ZVf9He70DXExzhoXGV6SJcjjBnr8RRE8zaIDreG
         1tkMlK20Oz4pFYkS0bN+VSHrQH+sNYpVscu6mTe44NR/qvlmry0bbfTq3qHf9rapDH
         F02hvaR8vsjBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C01BCEAC081;
        Mon, 21 Mar 2022 11:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V5 0/2] Fix refcount leak and NPD bugs in ax25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164786041078.7161.8989814381753324978.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 11:00:10 +0000
References: <cover.1647563511.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1647563511.git.duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, jreuter@yaina.de, eric.dumazet@gmail.com,
        dan.carpenter@oracle.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Mar 2022 08:54:03 +0800 you wrote:
> The first patch fixes refcount leak in ax25 that could cause
> ax25-ex-connected-session-now-listening-state-bug.
> 
> The second patch fixes NPD bugs in ax25 timers.
> 
> Duoming Zhou (2):
>   ax25: Fix refcount leaks caused by ax25_cb_del()
>   ax25: Fix NULL pointer dereferences in ax25 timers
> 
> [...]

Here is the summary with links:
  - [V5,1/2] ax25: Fix refcount leaks caused by ax25_cb_del()
    https://git.kernel.org/netdev/net/c/9fd75b66b8f6
  - [V6,2/2] ax25: Fix NULL pointer dereferences in ax25 timers
    https://git.kernel.org/netdev/net/c/fc6d01ff9ef0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


