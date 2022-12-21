Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65693652A68
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 01:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiLUAUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 19:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiLUAUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 19:20:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84351581B;
        Tue, 20 Dec 2022 16:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A905DB81ACB;
        Wed, 21 Dec 2022 00:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B096C433F1;
        Wed, 21 Dec 2022 00:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671582015;
        bh=GBgXJ0eNjms6bEdYiPtwyKF8/tDAfHuc3twUO9yHbXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sljVEFYVt2WMd90v10j1MNCaXODzL2RKRe/v2odh0euZKLQe3PGJMy599BK0Mnfdb
         rTQSd0zbNLo6CILt1BgCPBtUTyBJn5PSloQHvVT9uLM6K5GReWghRyjCPWBj0I7zvH
         oxl0oUhpL5Rhvd6zuwxWGyVYXERsg6yKJuViA/mDujRZrbmgibjL3tT/vN3SNer7BX
         dNlJA6ZeOW7MdcIcsFGFvkyZmvZSicjvO5K8DtAai9ITpUqZAT3vJJi1SF1AdfFkWv
         BYg8DHW5XQpxbyP0GOpzPvcra7nenEXRWrjdGOwsJCXIqDt8KYGRkvg7g1k882otgB
         1KHwcjLGJAknw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E54CC5C7C4;
        Wed, 21 Dec 2022 00:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf 1/2] bpf: pull before calling skb_postpull_rcsum()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167158201525.10746.9294452133702952539.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Dec 2022 00:20:15 +0000
References: <20221220004701.402165-1-kuba@kernel.org>
In-Reply-To: <20221220004701.402165-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        anpartha@meta.com, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, sdf@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Mon, 19 Dec 2022 16:47:00 -0800 you wrote:
> Anand hit a BUG() when pulling off headers on egress to a SW tunnel.
> We get to skb_checksum_help() with an invalid checksum offset
> (commit d7ea0d9df2a6 ("net: remove two BUG() from skb_checksum_help()")
> converted those BUGs to WARN_ONs()).
> He points out oddness in how skb_postpull_rcsum() gets used.
> Indeed looks like we should pull before "postpull", otherwise
> the CHECKSUM_PARTIAL fixup from skb_postpull_rcsum() will not
> be able to do its job:
> 
> [...]

Here is the summary with links:
  - [bpf,1/2] bpf: pull before calling skb_postpull_rcsum()
    https://git.kernel.org/bpf/bpf/c/54c3f1a81421
  - [bpf,2/2] selftests/bpf: tunnel: add sanity test for checksums
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


