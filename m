Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239105F1880
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiJABuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiJABuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123A2979E1;
        Fri, 30 Sep 2022 18:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97C46623C1;
        Sat,  1 Oct 2022 01:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE655C43470;
        Sat,  1 Oct 2022 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664589019;
        bh=ZvE5fLUL200qmwnMejCG1XR6hmYECrC8OFd0e/9Qo14=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mW85VL6ZNhfWL9W2/ZzUC5QSLYNz/N0YnEQ/yj43fYy/IqXkh8EdvhaMiiUzyDG0y
         SMfcCMw5lLdGIL42KQ1B0iKTU/XjcfbSw5iolMDeLfK7BTK5r7rtmko+b+XqPCmLvl
         /vVXpf/XYS6iVy5Gle+sqadPKjwtAcHyws7RAmwyarstN2hYBWBEv0npx9Cs9i2hbi
         bL7hdq7A9cUr5NpEKFCDqTeZG1CfE/H4EBa9J4fdh7TLRFUE7V8T643R55zA6hZD7/
         o7skLRFgDqNz06HQVSQ3jubYnsQ2vsZmZtDG2FHxyK35XII15jZ9rz9WcDOlR6ul5+
         g1e475S5QX73A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3A44E52501;
        Sat,  1 Oct 2022 01:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: nfc: marvell,nci: fix reset line polarity in
 examples
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166458901885.12957.13702237029386370655.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Oct 2022 01:50:18 +0000
References: <YzX+nzJolxAKmt+z@google.com>
In-Reply-To: <YzX+nzJolxAKmt+z@google.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Thu, 29 Sep 2022 13:22:55 -0700 you wrote:
> The reset line is supposed to be "active low" (it even says so in the
> description), but examples incorrectly show it as "active high"
> (likely because original examples use 0 which is technically "active
> high" but in practice often "don't care" if the driver is using legacy
> gpio API, as this one does).
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> [...]

Here is the summary with links:
  - dt-bindings: nfc: marvell,nci: fix reset line polarity in examples
    https://git.kernel.org/netdev/net-next/c/70d5ab532059

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


