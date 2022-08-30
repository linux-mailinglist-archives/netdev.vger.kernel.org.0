Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6535A609F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiH3KVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiH3KUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:20:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEB44056E
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 03:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 092B4B811B2
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2685C43149;
        Tue, 30 Aug 2022 10:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661854815;
        bh=c1Hak9CInte0VtZGDEcevKGmy7MyqEggjIccxGMuiKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LMleuPDbrx5z31qz3Nvuvq9ZQNtFIxidmgxhavZACLfCaZ9uFHgU/2Eh/F0If9qgT
         TtFZy2dr73prWEQF1BgPorl/8OW2to7j35bhdQ4eT+NGrQJroqhSjeNfyytQ4DT1rf
         UHf1sH6YiNeVDoLUz+I0vHniQMNyZQV7oethyMEe5R5BGS0yW4pgqwUNPki0hSyd58
         6vKExLr8WEGfP15tUdunJhNNqUy6aPdvs2DObkM6sdxBppn0N4uUps215wiA8xFqHM
         SIh9bmI4Vez496/7ga55oMMXL6RlV6vazPBE3VYIP5tOTJN5deVO5hS4XLupTjlg2k
         6mocO2iI2TURA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8427DE924D4;
        Tue, 30 Aug 2022 10:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: unify alloclen calculation for paged requests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166185481553.698.6855177771939951127.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Aug 2022 10:20:15 +0000
References: <b0e4edb7b91f171c7119891d3c61040b8c56596e.1661428921.git.asml.silence@gmail.com>
In-Reply-To: <b0e4edb7b91f171c7119891d3c61040b8c56596e.1661428921.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 25 Aug 2022 13:06:31 +0100 you wrote:
> Consolidate alloclen and pagedlen calculation for zerocopy and normal
> paged requests. The current non-zerocopy paged version can a bit
> overallocate and unnecessary copy a small chunk of data into the linear
> part.
> 
> Cc: Willem de Bruijn <willemb@google.com>
> Link: https://lore.kernel.org/netdev/CA+FuTSf0+cJ9_N_xrHmCGX_KoVCWcE0YQBdtgEkzGvcLMSv7Qw@mail.gmail.com/
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: unify alloclen calculation for paged requests
    https://git.kernel.org/netdev/net-next/c/47cf88993c91

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


