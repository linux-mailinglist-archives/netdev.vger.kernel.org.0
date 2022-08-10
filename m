Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1A758E6A1
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 07:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiHJFKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 01:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHJFKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 01:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21AC13D27;
        Tue,  9 Aug 2022 22:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E066B81A3E;
        Wed, 10 Aug 2022 05:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1382EC433D7;
        Wed, 10 Aug 2022 05:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660108216;
        bh=5v0egdSR1GmcZh8QABz56AeIL05FbW7ZDDp8Y7hHgyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YocZmMrxH/QGihgUHVHrkkOuMMxw8yEjlg7B1jfK1DX8ulyISGIABbT8gLMgY5lwH
         Efu0hs2EmKvhfmtP2gD12E/H4FDel0bi7vbBCLc7KZV9qWUsfz/b1VngFn1FPZXSEk
         kALxSsIuGtnT8vJX88VJVHnV3Fr3hW1O90aL6pnYpFk45YVzhhEGLk0TQMQ1vDH5y9
         v5RjCvHTJYYGpRBMVRWEpOeulw42aYMzHl6rL7fSBElJbDq48T8m1hy/EbCLDjCtHn
         AtPn6iIqgLkbS+xr5hu7+rcxU+KvqvDq5UE+S6xDprFcSELOnmQC0O3/WBtle/NdIo
         GG+3cCWKlOyjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8DAAC43143;
        Wed, 10 Aug 2022 05:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: nf_tables: validate variable length
 element extension
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166010821595.18792.3808704425767973984.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 05:10:15 +0000
References: <20220809220532.130240-2-pablo@netfilter.org>
In-Reply-To: <20220809220532.130240-2-pablo@netfilter.org>
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

On Wed, 10 Aug 2022 00:05:25 +0200 you wrote:
> Update template to validate variable length extensions. This patch adds
> a new .ext_len[id] field to the template to store the expected extension
> length. This is used to sanity check the initialization of the variable
> length extension.
> 
> Use PTR_ERR() in nft_set_elem_init() to report errors since, after this
> update, there are two reason why this might fail, either because of
> ENOMEM or insufficient room in the extension field (EINVAL).
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: nf_tables: validate variable length element extension
    https://git.kernel.org/netdev/net/c/34aae2c2fb1e
  - [net,2/8] netfilter: nf_tables: do not allow SET_ID to refer to another table
    https://git.kernel.org/netdev/net/c/470ee20e069a
  - [net,3/8] netfilter: nf_tables: do not allow CHAIN_ID to refer to another table
    https://git.kernel.org/netdev/net/c/95f466d22364
  - [net,4/8] netfilter: nf_tables: do not allow RULE_ID to refer to another chain
    https://git.kernel.org/netdev/net/c/36d5b2913219
  - [net,5/8] netfilter: ip6t_LOG: Fix a typo in a comment
    https://git.kernel.org/netdev/net/c/134941683b89
  - [net,6/8] netfilter: nf_tables: upfront validation of data via nft_data_init()
    https://git.kernel.org/netdev/net/c/341b69416087
  - [net,7/8] netfilter: nf_tables: disallow jump to implicit chain from set element
    https://git.kernel.org/netdev/net/c/f323ef3a0d49
  - [net,8/8] netfilter: nf_tables: fix null deref due to zeroed list head
    https://git.kernel.org/netdev/net/c/580077855a40

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


