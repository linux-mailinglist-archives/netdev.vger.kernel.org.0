Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C61631EED
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiKULAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiKULAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B1A9E965
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F535B80E62
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C958C433C1;
        Mon, 21 Nov 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669028416;
        bh=4gRzlbZ8GwT7XghZPR/3NusHylpofUupI5eWZizBeQI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EmU45h6VDH1q77xCZgAiUcoY7yDRrDRLduqwFf/1oxmSuIbcmFBn2hb3p5cENrqsM
         E8x5gu6Y2x7+MfRzBVOsQu0QBInmVnmbYwz+aCGQE31hw6mb3JdwVuPKa+SasAbi7x
         89KE+1N9RDmhqbFxHPVjE3CsLH6I6fW/AjyChoAs1cYwzCGLuGIhHmeSfzkTI6rso1
         oVLfsTh7PBpbhcwI3LyfatZ1wzZk9GG3K+iPwhEuZeJtlq7BdaSfydHPVIb16ocQyu
         g19MDKDKaJ2rPdRDsiUozgRrhSQLirdkpSLKxEvucbxSmxBZw05ct2NjKEpwosrU72
         c+xOKMwJfCaqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B89DC395FF;
        Mon, 21 Nov 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] NFC: nci: Extend virtual NCI deinit test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902841603.19060.9689760254139925657.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 11:00:16 +0000
References: <20221117162101.1467069-1-dvyukov@google.com>
In-Reply-To: <20221117162101.1467069-1-dvyukov@google.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     pabeni@redhat.com, bongsu.jeon@samsung.com,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 17:21:01 +0100 you wrote:
> Extend the test to check the scenario when NCI core tries to send data
> to already closed device to ensure that nothing bad happens.
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - [net-next,v2] NFC: nci: Extend virtual NCI deinit test
    https://git.kernel.org/netdev/net-next/c/d9e8da558580

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


