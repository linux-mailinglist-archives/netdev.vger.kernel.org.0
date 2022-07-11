Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB5E57009F
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiGKL3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiGKL2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:28:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F6C24F0D;
        Mon, 11 Jul 2022 04:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EE0BB80EBF;
        Mon, 11 Jul 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3F73C341C0;
        Mon, 11 Jul 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657537812;
        bh=woKfRlYHE/JalE0K0VARx7uvTGgdKxCKEBUwiIxfqNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DVDPWrF/64PtUWU4WQPtL8GgGcFSVGUgb83di+gJZCIvyoCctwjzODP+P0hEMsQSr
         2qloHXN+CWTid1fEGRV+EKfWfbLHu1MtsKDXjxQIInh4GD/hGJ3ZS9ZqsOc/j+igMZ
         AGkPO+JZh5bZGOC7Z+uwvNU5JGUm3+WFVrq3TMSYtNXLX7hAD6mcVHaWRlZwhlaqwi
         1pmkIzI7g/bqwRS6uiifFuWJyqyzZZaht88EVpmjrugdW5iz8Ossl4CawNixGOGWqk
         g/yLa5apasrdn6/69rlQzqbDUpgktRIB7P+RAx39Vdbq7Dm/4kbZHn1HxVBATWZu1S
         XWZaSXWdNybwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B90E2E45229;
        Mon, 11 Jul 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: conntrack: fix crash due to confirmed bit
 load reordering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165753781275.22782.1054032536535408834.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jul 2022 11:10:12 +0000
References: <20220711093357.107260-2-pablo@netfilter.org>
In-Reply-To: <20220711093357.107260-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
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

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 11 Jul 2022 11:33:55 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Kajetan Puchalski reports crash on ARM, with backtrace of:
> 
> __nf_ct_delete_from_lists
> nf_ct_delete
> early_drop
> __nf_conntrack_alloc
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: conntrack: fix crash due to confirmed bit load reordering
    https://git.kernel.org/netdev/net/c/0ed8f619b412
  - [net,2/3] netfilter: nf_log: incorrect offset to network header
    https://git.kernel.org/netdev/net/c/7a847c00eeba
  - [net,3/3] netfilter: nf_tables: replace BUG_ON by element length check
    https://git.kernel.org/netdev/net/c/c39ba4de6b0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


