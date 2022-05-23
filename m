Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8D9531A24
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiEWUKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiEWUKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:10:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A9F9858C;
        Mon, 23 May 2022 13:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90427B815C3;
        Mon, 23 May 2022 20:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49CF4C385A9;
        Mon, 23 May 2022 20:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653336611;
        bh=t9ed7xwBhw3HzY0r4U+A4ALzGc8ApH2AjH9dQPtOGUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MdefCYG1oiwzFjXK5Mn04e3xtjZ8uIaM5MdwBLAtUzhEEEpvHUXtIxhRlM2roiXRH
         WnC4XP/sCvCRn+FUopdfBjacmiZraEuyMH8SVfLqMo6uHu4f73hD4Xu3idaPxmlAU7
         /9UHhWdw4YLnVUJKRbfBzbZEHJFybD3GLA0YgWrRQzgN6BFQIZ4sXVob1tWIJ2XLjq
         lshvLo56LJ8NnFJ10vUqMOiIRuPwiiM09LcZM3xN2znD6NVRTJrwAXMIQc6Mcv5a6L
         EkubBBbJcVvfYcGd/5dw3I9kPIbcChpZfxd/Y6McC+VPp9LyYinsdi6HU9BchCOuBf
         GPTub+sHBebYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AEB1F03938;
        Mon, 23 May 2022 20:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] selftests/bpf: Fix spelling mistake: "unpriviliged" ->
 "unprivileged"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165333661117.30857.3574938614262437532.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 20:10:11 +0000
References: <20220523115604.49942-1-colin.i.king@gmail.com>
In-Reply-To: <20220523115604.49942-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 23 May 2022 12:56:04 +0100 you wrote:
> There are spelling mistakes in ASSERT messages. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/unpriv_bpf_disabled.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [next] selftests/bpf: Fix spelling mistake: "unpriviliged" -> "unprivileged"
    https://git.kernel.org/bpf/bpf-next/c/f9a3eca4bc04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


