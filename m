Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AF74D544A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344265AbiCJWLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244338AbiCJWLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:11:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339E711AA15;
        Thu, 10 Mar 2022 14:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6BFEB827DC;
        Thu, 10 Mar 2022 22:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F757C36AE3;
        Thu, 10 Mar 2022 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646950210;
        bh=Y/hF0VrYruSIEIRvf6uGszF9zpLWltOKsy0/1rq3reo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RkerN/oX4HB5CEHqfBlzfAEh8FWgmq/XSGUl5JNbBuXil0hKwTVx4qmU0qD9gJHOS
         MvaJ7mECDEhXvn8dK3r05Zgy1QX0PY3Vo/L0WD8ebQzIDKNzRc8a++OrMi4TIj4mqQ
         vSpFTgAIjENtreSlEtsR1OVixYvZZlioGftShmn4ThQUBehla51cG/ik0cUk/u7tXT
         JFD4Lxh9pE1l3eyG61lxEZ5GMtKv1wuBM3YZebpjLt+KfuR2gvVIEf70tSoPf7qOYR
         +AJ6SgViXvQyJVm+olZP4bsdb2iKNIk6wIycFNSHSxs4bNQpifDXtpsb8Yr8KnzUwQ
         QJzUyj0Ojqc4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35623E8DD5B;
        Thu, 10 Mar 2022 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Use offsetofend() to simplify macro definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695021021.12374.9551574095266283613.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 22:10:10 +0000
References: <20220310161518.534544-1-ytcoode@gmail.com>
In-Reply-To: <20220310161518.534544-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 11 Mar 2022 00:15:18 +0800 you wrote:
> Use offsetofend() instead of offsetof() + sizeof() to simplify
> MIN_BPF_LINEINFO_SIZE macro definition.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  kernel/bpf/verifier.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf: Use offsetofend() to simplify macro definition
    https://git.kernel.org/bpf/bpf-next/c/1b773d0003aa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


