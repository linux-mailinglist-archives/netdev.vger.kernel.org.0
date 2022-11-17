Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF1362DC2A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiKQNAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbiKQNAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:00:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E6D686A8
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73676CE1AAA
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6CA3C43470;
        Thu, 17 Nov 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668690015;
        bh=6dVApBS9qd5BM7fZ46YkeLyZBW4aqHR4hkN6YbMUNyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KmP46InovoW9wfDGZgQ+fJKJGb1fSGGrFagVBFUpuCXsQdB5zR0HJAly72gECpWDk
         0dvz240UxcrBpUx/mj2DPIl4MQrNZKGTIy7Nrd/WMPyf7oF+SKfZIGusSmVYrzaXul
         p12qfFYWczYMArSGHIXkpQKS04DCa1q55zmmbQWDGMzXkW8aifUDdaNRNRwj3WWaTL
         2R+1E4w4A15m8um2TtxGTLwkwKbUhWAbA4m8zCxmM0BvXRCyUA4Y7K+X1VQ5xV9SoO
         szdbYKvxvxnaXLsDhW7UwUe7nOTJnutxpIHFGhQlGjQ0Z6MTSxknR1xS8cFgFltHbW
         JLHdxPrehTn0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DD3EE29F44;
        Thu, 17 Nov 2022 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] NFC: nci: Allow to create multiple virtual nci
 devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166869001557.27089.10646495920834045912.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 13:00:15 +0000
References: <20221115100017.787929-1-dvyukov@google.com>
In-Reply-To: <20221115100017.787929-1-dvyukov@google.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     leon@kernel.org, bongsu.jeon@samsung.com,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        syzkaller@googlegroups.com, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 15 Nov 2022 11:00:17 +0100 you wrote:
> The current virtual nci driver is great for testing and fuzzing.
> But it allows to create at most one "global" device which does not allow
> to run parallel tests and harms fuzzing isolation and reproducibility.
> Restructure the driver to allow creation of multiple independent devices.
> This should be backwards compatible for existing tests.
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Reviewed-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - [net-next,v4] NFC: nci: Allow to create multiple virtual nci devices
    https://git.kernel.org/netdev/net-next/c/b2e44aac91b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


