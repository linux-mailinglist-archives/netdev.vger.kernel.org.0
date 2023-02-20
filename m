Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F269C925
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjBTLAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjBTLAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE2813DCE;
        Mon, 20 Feb 2023 03:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D9C7B80C75;
        Mon, 20 Feb 2023 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B923C433EF;
        Mon, 20 Feb 2023 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676890818;
        bh=MP3Q3ATHzGxMJjJ1srWwkTI6vMVKWvjxmqO9F2ostjA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ic2kw+5U9MblNccGoDWTn77vkgtxcmq/1snaEYjHhyVtpxvlLbD1GExM0kbKxIYTQ
         qkHPg4CE2Pd8JSweQrSJERJIEE4gR5cExLbzF7Urh8vZv9WCg4v1JsjzZvnec6ZWiK
         0+dVdjig9VPYeCLTlMk9G1lYFi6s6IqENmeBGtuPD09rNv1565hhvUrwDbVGU9QTit
         SQzNxfZyCMeoN29RVZ31V5o0FADEtXYoo7B5/7bfOd0XcuOI8WkJxh9xVMNkyo8/94
         5pBR+ECCFHZGtwIUz/kiDvJdnJ09uLsEAgnulOEA0BOMQHAeByfLS4LG0QWfXUxryE
         xUQ3yzuIVX87A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0CEDE68D20;
        Mon, 20 Feb 2023 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/6] netfilter: nf_tables: NULL pointer dereference
 in nf_tables_updobj()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689081798.18600.7449667914076688550.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 11:00:17 +0000
References: <20230217122957.799277-2-pablo@netfilter.org>
In-Reply-To: <20230217122957.799277-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 17 Feb 2023 13:29:52 +0100 you wrote:
> From: Alok Tiwari <alok.a.tiwari@oracle.com>
> 
> static analyzer detect null pointer dereference case for 'type'
> function __nft_obj_type_get() can return NULL value which require to handle
> if type is NULL pointer return -ENOENT.
> 
> This is a theoretical issue, since an existing object has a type, but
> better add this failsafe check.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()
    https://git.kernel.org/netdev/net-next/c/dac7f50a4521
  - [net-next,2/6] netfilter: nf_tables: fix wrong pointer passed to PTR_ERR()
    https://git.kernel.org/netdev/net-next/c/1fb7696ac6c3
  - [net-next,3/6] netfilter: conntrack: udp: fix seen-reply test
    https://git.kernel.org/netdev/net-next/c/28af0f009dde
  - [net-next,4/6] netfilter: conntrack: remote a return value of the 'seq_print_acct' function.
    https://git.kernel.org/netdev/net-next/c/f6477ec62fda
  - [net-next,5/6] ipvs: avoid kfree_rcu without 2nd arg
    https://git.kernel.org/netdev/net-next/c/e4d0fe71f59d
  - [net-next,6/6] netfilter: let reset rules clean out conntrack entries
    https://git.kernel.org/netdev/net-next/c/2954fe60e33d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


