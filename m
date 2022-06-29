Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6273155F559
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiF2EkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2EkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FC02C64A;
        Tue, 28 Jun 2022 21:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF7D1B81DDC;
        Wed, 29 Jun 2022 04:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73282C385A5;
        Wed, 29 Jun 2022 04:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656477612;
        bh=PNwcF0O168MtCTazXKm04c/BZMLcOcqYp+e+xZ8ONJY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MJ40pluLhHYv7izM3tukeFjk5taZiuRZYXswkHEjjH2jh3KK8IB5KuJW79Fvvc13H
         +Ws8OqGE5E1Clv90n6rGNrjJ3PXl65N01CYH+QviKsFIhr6yOFfpptA+CzANUgC+j1
         t3gnrWjGV/NhcXnZ+u1WmSn15Ax5Q61nKfSlF8FrT+hknAKcJVXtVA1r6o+Az/v9PK
         97mcXNwMMvOul9jcoZ8nlm7kjBagqPN5sxi700UTHb+BYVcqjUoSqXHJTLkJjAarha
         4ckZFcFMKPdMqnaG1qJXgTCHNBfFI9b0N6q8ZEO076Rc235oPEgvJd+3KEJQrd6LHm
         cb9c2hPAqHMig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58132E49F61;
        Wed, 29 Jun 2022 04:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: nfcmrvl: Fix irq_of_parse_and_map() return value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165647761235.961.8244726128649577438.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 04:40:12 +0000
References: <20220627124048.296253-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220627124048.296253-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     sameo@linux.intel.com, cuissard@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lv.ruyi@zte.com.cn
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 27 Jun 2022 14:40:48 +0200 you wrote:
> The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.
> 
> Reported-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> 
> [...]

Here is the summary with links:
  - [v2] nfc: nfcmrvl: Fix irq_of_parse_and_map() return value
    https://git.kernel.org/netdev/net/c/5a478a653b4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


