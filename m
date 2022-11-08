Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313EA6215FA
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiKHOUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiKHOUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:20:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5730E1706D;
        Tue,  8 Nov 2022 06:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07DE4B81B05;
        Tue,  8 Nov 2022 14:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0583C43470;
        Tue,  8 Nov 2022 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667917214;
        bh=5l+HsKCJrO1h6TA3UO9lDuwqz2hJWvy1Fpw5exmv914=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qkhbt5VD/NOhzI7jLSVfUbHbL2j/OfXe44bwZoZSTgHxrvci1K7sPQM53vKOh8V33
         X5rZhfg/UzyvSEwg1QP1pdZi1YlL6GXewPgaH9oBNp0Cf8eqffputauob9iJTX//ys
         t9MqgSUa2NiPuQS4j7J3lXaG720a1sPkkHL7HZ+76Nc34/u3O5M/aP7pLjc9KB2xS2
         BP+w7uJJGjw3ahQirNHqI6e1ZMsrAmw7nYh+mCQk0xo4d0hZbrLpmPupg12p4Z4QJD
         F2llZ7YVgSFouyrlp5KFjuDcDxXcIPBjM2+2BQR3LEcsIqFcOfMrBVVT39VF2g6Pe5
         pswskrJ9RaV3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 843E5C4166D;
        Tue,  8 Nov 2022 14:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net,v1 PATCH] octeontx2-pf: Fix SQE threshold checking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166791721453.30112.15738048991535500400.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 14:20:14 +0000
References: <20221107033505.2491464-1-rkannoth@marvell.com>
In-Reply-To: <20221107033505.2491464-1-rkannoth@marvell.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 7 Nov 2022 09:05:05 +0530 you wrote:
> Current way of checking available SQE count which is based on
> HW updated SQB count could result in driver submitting an SQE
> even before CQE for the previously transmitted SQE at the same
> index is processed in NAPI resulting losing SKB pointers,
> hence a leak. Fix this by checking a consumer index which
> is updated once CQE is processed.
> 
> [...]

Here is the summary with links:
  - [net,v1] octeontx2-pf: Fix SQE threshold checking
    https://git.kernel.org/netdev/net/c/f0dfc4c88ef3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


