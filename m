Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2193539BF5
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 06:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiFAEKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 00:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiFAEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 00:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDF771DA1;
        Tue, 31 May 2022 21:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1683B817DF;
        Wed,  1 Jun 2022 04:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50AE3C3411A;
        Wed,  1 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654056613;
        bh=cudR3AmrMMpq0flpl7nw1YP9b0I8Sex8DswpaTr3OGg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=opZ9V0C15lOrasyD/L8mV7AENsxDUBzTFHusOxs7Al8B7ddElu3YJHqmfPeVQNosr
         PkPb1Ixwtkx5ubqvHPEPB38MXzQogyhUoJmPAhm/TOUTZM+nrV5MKfHFjg94wHaWd8
         ujGkC34gfu7ku9bM1bOm1iN/pQW040NL1c3WoC68ALL0KA08CW7IlkU7MslSz44yF6
         CY0V8RrGRh0MVv12yw32GvTDUXGSXqUA9dcZbdhHoBMb27Wann7TApdiJs6Ts0gtKV
         s+3ZNLmztCQkOnFy28vXvalV1NCtRkAbVmV8G6PhuMsb499uN5LnCS/LaO3OEin7Iv
         2sBq9VgRG4gDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34407F0394D;
        Wed,  1 Jun 2022 04:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: nf_tables: sanitize
 nft_set_desc_concat_parse()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165405661321.30810.1706401303605363331.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Jun 2022 04:10:13 +0000
References: <20220531215839.84765-2-pablo@netfilter.org>
In-Reply-To: <20220531215839.84765-2-pablo@netfilter.org>
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

On Tue, 31 May 2022 23:58:35 +0200 you wrote:
> Add several sanity checks for nft_set_desc_concat_parse():
> 
> - validate desc->field_count not larger than desc->field_len array.
> - field length cannot be larger than desc->field_len (ie. U8_MAX)
> - total length of the concatenation cannot be larger than register array.
> 
> Joint work with Florian Westphal.
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: nf_tables: sanitize nft_set_desc_concat_parse()
    https://git.kernel.org/netdev/net/c/fecf31ee395b
  - [net,2/5] netfilter: nf_tables: hold mutex on netns pre_exit path
    https://git.kernel.org/netdev/net/c/3923b1e44066
  - [net,3/5] netfilter: nf_tables: double hook unregistration in netns path
    https://git.kernel.org/netdev/net/c/f9a43007d3f7
  - [net,4/5] netfilter: flowtable: fix missing FLOWI_FLAG_ANYSRC flag
    https://git.kernel.org/netdev/net/c/f1896d45fee9
  - [net,5/5] netfilter: flowtable: fix nft_flow_route source address for nat case
    https://git.kernel.org/netdev/net/c/97629b237a8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


