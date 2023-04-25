Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169FB6ED94A
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 02:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjDYAU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 20:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjDYAUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 20:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A00E5585;
        Mon, 24 Apr 2023 17:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A70662005;
        Tue, 25 Apr 2023 00:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8215FC4339B;
        Tue, 25 Apr 2023 00:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682382023;
        bh=c8BupQSu+EGB9AJDFgvpVtU7tG+b4PHYDhjVTVKKGFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZennQLRa+8UWMQ1td49BSe+Ui89L0lhZkEe+YxCrFrPtIAQNYpeZjszoHK3PwNcaM
         plY8md8rE+X0to8W1TuOc3YvYvq1kxNunF4n2t/LDUIPIsXY/viiyvWBrAV/hsYX1e
         Op1ztjrH0D8BU8C2nLDn5Z/sVrqnWOvxA9uljNifASXkTtGPBP3ag+5JxoiZSYWDF0
         v6NPLjsHG0zBW9fFYHkRxXfXgqF4oNpCqBI4qm/9BlCfpe/a2l42cWi8r7HZsR9M1V
         yOsqCdNmsGUOGSyRjiG/wyS2SzLg6lron/2bwc88ED8ZOExPpMxgR79kjnkNbIYQDG
         WYp+9ggsfBFIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65F90E5FFC9;
        Tue, 25 Apr 2023 00:20:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/19] netfilter: nf_tables: merge nft_rules_old
 structure and end of ruleblob marker
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238202341.15505.3012924229620032855.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 00:20:23 +0000
References: <20230421235021.216950-2-pablo@netfilter.org>
In-Reply-To: <20230421235021.216950-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sat, 22 Apr 2023 01:50:03 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> In order to free the rules in a chain via call_rcu, the rule array used
> to stash a rcu_head and space for a pointer at the end of the rule array.
> 
> When the current nft_rule_dp blob format got added in
> 2c865a8a28a1 ("netfilter: nf_tables: add rule blob layout"), this results
> in a double-trailer:
> 
> [...]

Here is the summary with links:
  - [net-next,01/19] netfilter: nf_tables: merge nft_rules_old structure and end of ruleblob marker
    https://git.kernel.org/netdev/net-next/c/e38fbfa972eb
  - [net-next,02/19] netfilter: nf_tables: don't store address of last rule on jump
    https://git.kernel.org/netdev/net-next/c/d4d89e6546e0
  - [net-next,03/19] netfilter: nf_tables: don't store chain address on jump
    https://git.kernel.org/netdev/net-next/c/63e9bbbcca60
  - [net-next,04/19] netfilter: nf_tables: don't write table validation state without mutex
    https://git.kernel.org/netdev/net-next/c/9a32e9850686
  - [net-next,05/19] netfilter: nf_tables: make validation state per table
    https://git.kernel.org/netdev/net-next/c/00c320f9b755
  - [net-next,06/19] netfilter: nf_tables: remove unneeded conditional
    https://git.kernel.org/netdev/net-next/c/2a1d6abd7ebe
  - [net-next,07/19] netfilter: nf_tables: do not store pktinfo in traceinfo structure
    https://git.kernel.org/netdev/net-next/c/698bb828a6c2
  - [net-next,08/19] netfilter: nf_tables: do not store verdict in traceinfo structure
    https://git.kernel.org/netdev/net-next/c/0a202145d5f9
  - [net-next,09/19] netfilter: nf_tables: do not store rule in traceinfo structure
    https://git.kernel.org/netdev/net-next/c/46df417544f4
  - [net-next,10/19] ipvs: Update width of source for ip_vs_sync_conn_options
    https://git.kernel.org/netdev/net-next/c/e3478c68f670
  - [net-next,11/19] ipvs: Consistently use array_size() in ip_vs_conn_init()
    https://git.kernel.org/netdev/net-next/c/280654932e34
  - [net-next,12/19] ipvs: Remove {Enter,Leave}Function
    https://git.kernel.org/netdev/net-next/c/210ffe4a74ca
  - [net-next,13/19] ipvs: Correct spelling in comments
    https://git.kernel.org/netdev/net-next/c/c7d15aaa105a
  - [net-next,14/19] netfilter: nf_tables: extended netlink error reporting for netdevice
    https://git.kernel.org/netdev/net-next/c/c3c060adc024
  - [net-next,15/19] netfilter: nf_tables: do not send complete notification of deletions
    https://git.kernel.org/netdev/net-next/c/28339b21a365
  - [net-next,16/19] netfilter: nf_tables: rename function to destroy hook list
    https://git.kernel.org/netdev/net-next/c/cdc325466323
  - [net-next,17/19] netfilter: nf_tables: support for adding new devices to an existing netdev chain
    https://git.kernel.org/netdev/net-next/c/b9703ed44ffb
  - [net-next,18/19] netfilter: nf_tables: support for deleting devices in an existing netdev chain
    https://git.kernel.org/netdev/net-next/c/7d937b107108
  - [net-next,19/19] netfilter: nf_tables: allow to create netdev chain without device
    https://git.kernel.org/netdev/net-next/c/207296f1a03b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


