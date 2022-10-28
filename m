Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7000610EC7
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiJ1Kky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJ1KkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0610532DAE;
        Fri, 28 Oct 2022 03:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFE87B8293F;
        Fri, 28 Oct 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 583FCC43143;
        Fri, 28 Oct 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666953616;
        bh=IJyBYDxay90ZJp+1StFmm1xZPl7zZsGLnqmrtCAMJiw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AR9hsocZvfcrG58GeeGITrqgmdsnRlaB6Gg6PZSXxHDT3NPRP54Ed+0mGUx5iXI4K
         XPaJP7i2RqfaxvCU2GsgvHZ+826hgFbWW1IVAzSqxYf2f/AYqYeVJFTP1fjNVPNORc
         WjBdZ7tuKn31Lj5mWhT35SeaHc0RCgZLwfa6nabuPG68vBcQ4v4YypBR0Irrx0XI0C
         GS7ntzXgqHO9UygVVambe7hbRGTtndoy0YD7s+KQR1G1PFU3ZADmPwl1MPNyfXYS0o
         EmDgRtwYRQ11hjczu3P/gtBJNDVrkj/vdDRRX5SiDOujCBJEedgen6wUlyCr6yoVLq
         mHgeRQlkCOa8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F2B0C4314C;
        Fri, 28 Oct 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] nfc: s3fwrn5: use
 devm_clk_get_optional_enabled() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166695361625.9848.5067044718345042459.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 10:40:16 +0000
References: <Y1o0ahD+AisRA+Qk@google.com>
In-Reply-To: <Y1o0ahD+AisRA+Qk@google.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 00:34:02 -0700 you wrote:
> Because we enable the clock immediately after acquiring it in probe,
> we can combine the 2 operations and use devm_clk_get_optional_enabled()
> helper.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [net-next,v2] nfc: s3fwrn5: use devm_clk_get_optional_enabled() helper
    https://git.kernel.org/netdev/net-next/c/f8f797f35a9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


