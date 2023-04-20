Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107E56E87AA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjDTBu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDTBu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22191992;
        Wed, 19 Apr 2023 18:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 380F66445D;
        Thu, 20 Apr 2023 01:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 893FAC4339B;
        Thu, 20 Apr 2023 01:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681955419;
        bh=08x8V/Hbh8jFZgsR0YwijzD98zdRZ3gaZMAH0sj9+/k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gE4oypqmwGwEDBYp+eQx0ZEhgWz9N1uxBrLBB7fvXH/3Ja4KGqeyn8SdWHImobH0W
         jmfDYm6OMltEDueJ/nyZen2lf6MDxodDzchuvc2dwSDzh8DJZFpFVbSFuTMlsJXXYC
         PzBti1PSlZ0ebxgWCE3NvTngtCPE4moWTGDKLeBdl3wIF5hFNgiYSOoFDzjI/DmQ8a
         zuUfNfQu8AEnpthxvkL8ImTpMsb6Tfub6zXChDMH3Vl9NzPXQHp8iBSXUG3C1b5rxW
         q0guVBIDEeFsX4ZiTmV2EoXcZW/Q4PGj98lmK33/BzlEuu1ZJs9Wa3aT8RLP2BwlNs
         Q8GH+/n+DS/Gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6609CE5245A;
        Thu, 20 Apr 2023 01:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: ethernet: Fix JSON pointer references
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195541940.13596.9940364656287084713.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 01:50:19 +0000
References: <20230418150628.1528480-1-robh@kernel.org>
In-Reply-To: <20230418150628.1528480-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 10:06:27 -0500 you wrote:
> A JSON pointer reference (the part after the "#") must start with a "/".
> Conversely, references to the entire document must not have a trailing "/"
> and should be just a "#". The existing jsonschema package allows these,
> but coming changes make allowed "$ref" URIs stricter and throw errors on
> these references.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: ethernet: Fix JSON pointer references
    https://git.kernel.org/netdev/net-next/c/84ce730f82df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


