Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5DB530669
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 00:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbiEVWKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 18:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiEVWKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 18:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A89381A5;
        Sun, 22 May 2022 15:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47B2460F26;
        Sun, 22 May 2022 22:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98320C3411B;
        Sun, 22 May 2022 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653257412;
        bh=yCY4qZavqdaJeDtnafKRpTaB5MGOUOTX+E4lV1m5ksE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u+f7U1YTUrOjj+CgBQ7DinKaYM8vPWJbgcyU7QA/Cjxj6QzNMEIww7kqBC2vmYYGM
         JMn1eKB2CUH1g2mHDWu1DHlcZGFW7dG5yee/X3KpUURJAlj2q1KE1TgvRP9zNKtIZ5
         /9Wz1pdWA7pAmYIJE15uXQk9thZG9UUBLv/Adk1nH7Ma0CPmHk5CGaGTc0NHlui2hv
         qWZddXkNXo3BqjgKgArIkV4OwmntcwL6dcBvHMSgfxrPViskMvqHnpfwouK/Umx1nz
         HBIlXKjR7DOB7Vyehx02PCaObBwkUYPBtgy/AM+u79S0+Q/ZKnnJpp8Leyf4YwBXPi
         fo++2+tD9T4Xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 760E3F03944;
        Sun, 22 May 2022 22:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: toshiba,visconti-dwmac: Update the common
 clock properties
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325741248.24339.2578226589844996998.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 22:10:12 +0000
References: <20220520084823.620489-1-nobuhiro1.iwamatsu@toshiba.co.jp>
In-Reply-To: <20220520084823.620489-1-nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, yuji2.ishikawa@toshiba.co.jp,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, robh@kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 20 May 2022 17:48:23 +0900 you wrote:
> The clock for this driver switched to the common clock controller driver.
> Therefore, update common clock properties for ethernet device in the binding
> document.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> Acked-by: Rob Herring <robh@kernel.org>
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: toshiba,visconti-dwmac: Update the common clock properties
    https://git.kernel.org/netdev/net-next/c/17155d5db7ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


