Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E48F520A26
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiEJAeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiEJAeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:34:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9232A0A6D
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 17:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB93961535
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28C5DC385CD;
        Tue, 10 May 2022 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652142614;
        bh=9kTb507ekonyxK52aiGLodBPOptPsvZk8VYmo3ISKX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WpsmPY+RJ2mXFyjnIbC//7j25l8CUXh7aDXxOkxwzSjc5lm3XIPcPjENn+7HkMIEL
         qvGCTau83rW85GFLNe7Umc0CqvBxhHRnpMpnI//0nMXm7vBU50HtuQQvDRA0KHtf8G
         LVd6kDOCBNkm2WEF/zWZvfgmiA6hAmLhkHV0v7w+sgS1C5a7kmB3LqQsE1+HG8SvO6
         tA3N8Y57cJT7gQuFTzBxpNaJOT3kUs30DQD+oAcx4tDKx4+QcPXm5l+WAtb+DK12p4
         McyOqs2kgSxmBPTjpFzYNw+H/M2cBdbOzS2Bd8HISFhBxZaFZ6CX1jR3HNbq427Uj4
         1/oNEfisCpUjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F980F03876;
        Tue, 10 May 2022 00:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net RESEND] ptp: ocp: Use DIV64_U64_ROUND_UP for rounding.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214261405.23610.9810026932927620162.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 00:30:14 +0000
References: <20220506223739.1930-2-jonathan.lemon@gmail.com>
In-Reply-To: <20220506223739.1930-2-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  6 May 2022 15:37:39 -0700 you wrote:
> The initial code used roundup() to round the starting time to
> a multiple of a period.  This generated an error on 32-bit
> systems, so was replaced with DIV_ROUND_UP_ULL().
> 
> However, this truncates to 32-bits on a 64-bit system.  Replace
> with DIV64_U64_ROUND_UP() instead.
> 
> [...]

Here is the summary with links:
  - [net,RESEND] ptp: ocp: Use DIV64_U64_ROUND_UP for rounding.
    https://git.kernel.org/netdev/net/c/4bd46bb037f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


