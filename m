Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD776320E1
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiKULlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiKULkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:40:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EC612603;
        Mon, 21 Nov 2022 03:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 575F461093;
        Mon, 21 Nov 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3569C43470;
        Mon, 21 Nov 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669030815;
        bh=iz91hJ9SkNZPDFAotXScCr4KI624iw9t5ejxFcTcP5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kZ6qLrrPkq6OfNuyuIwX4LuCsECuZ/BtK8wYXwjV6jnVQcFLsAztFeMOqfH14TVOR
         AblP4AIkGA2MxzoX+BWyBE7qnWMqOu13bG6XmjhiiwoMS/mPPpG0Sv0eV8ZIz+cUkA
         YMmGewHReDM8MWYqfHej60P4DU0iU/cNhTgJoecGwLluCVEaxTXS6i7f1ef0ye+Gkg
         payJUs1F275WiqfEQtzh7PrE0BhjV34AKWgtzVVRvLPYAgzjlInrJdjStnaFuk/fBB
         WjogbF4LrcBmEK/ktX5i1kdT0Jdf5Tm+mHf8/7PqLbkiJHu0uFrpfLrgRgFDp7l17R
         hL7UISRa/NIAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 871BDC395FF;
        Mon, 21 Nov 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: conntrack: Fix data-races around ct mark
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166903081554.14617.12247850127073077689.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 11:40:15 +0000
References: <20221118142918.196782-2-pablo@netfilter.org>
In-Reply-To: <20221118142918.196782-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 18 Nov 2022 15:29:17 +0100 you wrote:
> From: Daniel Xu <dxu@dxuuu.xyz>
> 
> nf_conn:mark can be read from and written to in parallel. Use
> READ_ONCE()/WRITE_ONCE() for reads and writes to prevent unwanted
> compiler optimizations.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: conntrack: Fix data-races around ct mark
    https://git.kernel.org/netdev/net/c/52d1aa8b8249
  - [net,2/2] netfilter: nf_tables: do not set up extensions for end interval
    https://git.kernel.org/netdev/net/c/33c7aba0b4ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


