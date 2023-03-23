Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44176C5E79
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCWFKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCWFKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B951EFC6;
        Wed, 22 Mar 2023 22:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E34BE623EB;
        Thu, 23 Mar 2023 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EACFC433A4;
        Thu, 23 Mar 2023 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548219;
        bh=5Ci4fSBv262mq9/QZFWd0DUIJ/u9QOz238jcTR8fk6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bvj9SbxQ6L/c2Hep6dSUcxDaWgZbzeD4MrLaxXXtwrmcKF+rdkJhbtkpIOjIuLgRd
         pslep+HX+h7d+0iMNOe/ymZiyYYGJvyOh7ih3RTL/+XX6tXp4LKqt8/fI9kdquCxVV
         i7gXi0jVjcOd9H3ogDBYVcWV1Ojorosvx+GF4F8ECoruEAjAhVNQgl7XBvUvmiIgZP
         ya/eRzIwe6Qo6u0EYnY6nO++GpmaC1P8R6JU1Pfw0tziJhijI60Ta0OR07Xa6y56NN
         GeHDNcKpFYtYD9KhAt37BlQdrYvwDdgikmWTmyjGrLMvNeUYusjLWEeWkHDoO5xZRC
         sGbOdTpRL0vKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 355B4E4F0D7;
        Thu, 23 Mar 2023 05:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] liquidio: remove unused IQ_INSTR_MODE_64B function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954821921.28676.7103831036112762133.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:10:19 +0000
References: <20230321184811.1827306-1-trix@redhat.com>
In-Reply-To: <20230321184811.1827306-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 14:48:11 -0400 you wrote:
> clang with W=1 reports
> drivers/net/ethernet/cavium/liquidio/request_manager.c:43:19: error:
>   unused function 'IQ_INSTR_MODE_64B' [-Werror,-Wunused-function]
> static inline int IQ_INSTR_MODE_64B(struct octeon_device *oct, int iq_no)
>                   ^
> This function and its macro wrapper are not used, so remove them.
> 
> [...]

Here is the summary with links:
  - liquidio: remove unused IQ_INSTR_MODE_64B function
    https://git.kernel.org/netdev/net-next/c/603c3345589d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


