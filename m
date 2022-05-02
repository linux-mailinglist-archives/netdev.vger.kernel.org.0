Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732F5517056
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 15:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385256AbiEBNdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 09:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352768AbiEBNdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 09:33:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD25933E
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 06:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F2B2B817B5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF209C385AE;
        Mon,  2 May 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651498212;
        bh=uCkc226G430b5OezcABSthToSQt3EsM5ZWhZBQOwu2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U1tkjHAwHmx6PMiKB19ehYGUaUelfpn97Ok9OBIXxmTaQaS7VSJqD0/uXgxGS0htJ
         CeBa4BQ19wRrVS09AinT29S+UtqFC/GF9Q2IYe5LRPPrPgBWD0kBHFOwupnKDeA1fR
         y3hCv0wCxnwBd1ZusAa61tEmB//iH1HtFVeb6tdoHxJAYYWY6WbzFKNoQ4TSG/2kLx
         1W37b3bG67ZewAFVdiIWj/ucnshNgWJinLk409qqZM7CMvyV+rkCHcgFEIO9G2QVwv
         5gAkmhakbt595XBzc3Aedf2bqDGRnXuZqRMTiMGQqXxXGUB5O4witYir6JmKK2twRx
         b6nfM2GTyMSig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB407E6D402;
        Mon,  2 May 2022 13:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: more heap allocation and split of
 rtnl_newlink()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165149821176.2157.6275685774105765145.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 13:30:11 +0000
References: <20220429235508.268349-1-kuba@kernel.org>
In-Reply-To: <20220429235508.268349-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 29 Apr 2022 16:55:05 -0700 you wrote:
> Small refactoring of rtnl_newlink() to fix a stack usage warning
> and make the function shorter.
> 
> Jakub Kicinski (3):
>   rtnl: allocate more attr tables on the heap
>   rtnl: split __rtnl_newlink() into two functions
>   rtnl: move rtnl_newlink_create()
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] rtnl: allocate more attr tables on the heap
    https://git.kernel.org/netdev/net-next/c/c92bf26ccebc
  - [net-next,2/3] rtnl: split __rtnl_newlink() into two functions
    https://git.kernel.org/netdev/net-next/c/63105e83987a
  - [net-next,3/3] rtnl: move rtnl_newlink_create()
    https://git.kernel.org/netdev/net-next/c/02839cc8d72b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


