Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC225EC743
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiI0PKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiI0PKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C53CDB977
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D51361953
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4336C433B5;
        Tue, 27 Sep 2022 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664291415;
        bh=fcCKbL0/w94eXzuJOhJbNIWLfbt8RJclSnicaKcFo2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GpTf2zOlHgUu6A4W1Hf0xqfN1gXprXcqW6FOoq4MlD/ulF1D3NkqYAiy/lM5Y5spO
         T3NkWkhvhMxk0f/GiEclvPt7TsGgJgQmPjP4QFIPGF0Mbv/2JYbazHkOxKsVHMZbiq
         CKTwl/Mv5tHFsH094xkDtdL+LP9Z4PQ0LN1pZOu0/PFyr0+QExEYWTTT1qIH2hSSO8
         bELLVgs96gOh9M0NaBnZb2b/lmWdm1pZMYOy8pX9k4xn3R+lP54qYqBhUlTaKGdPEA
         n6NQA7CMdQvjAayZ4ma5g3Edj0jrR6edNrOnDIa9Guq5ojE2KXxj5BzOVirsI/44vb
         MGcaPg0JCoUYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4070E21EC5;
        Tue, 27 Sep 2022 15:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH for-next] selftests/net: enable io_uring sendzc testing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166429141479.885.4194378853159393934.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 15:10:14 +0000
References: <28e743602cdd54ffc49f68bbcbcbafc59ba22dc2.1664142210.git.asml.silence@gmail.com>
In-Reply-To: <28e743602cdd54ffc49f68bbcbcbafc59ba22dc2.1664142210.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 26 Sep 2022 11:35:36 +0100 you wrote:
> d8b6171bd58a5 ("selftests/io_uring: test zerocopy send") added io_uring
> zerocopy tests but forgot to enable it in make runs. Add missing
> io_uring_zerocopy_tx.sh into TEST_PROGS.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  tools/testing/selftests/net/Makefile | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [for-next] selftests/net: enable io_uring sendzc testing
    https://git.kernel.org/netdev/net-next/c/7bcd9683e515

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


