Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B094A60419F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 12:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbiJSKqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 06:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiJSKor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 06:44:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592E71187A9;
        Wed, 19 Oct 2022 03:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF3B5B82456;
        Wed, 19 Oct 2022 09:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A62EAC43145;
        Wed, 19 Oct 2022 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666170018;
        bh=viZDxavZnRqc957bc2vu0sL+ofeuUR6wPVOAvv3CN0o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qwVWZPkgo6wM2jsy691PS2yoU4KgKXd9Ka2/9cvWgSwR9S4uUBsLpsqZWMQddI6sm
         omgziXwqd7EBl3eIjozII5i7a0Z1PlN/ZR4q3uAXF+QblVN6rSPhMmkJ8gRsOukDfY
         ERcUTq17oRQfsW3GbSRAqNAPQyyVHjMQ0z0hKk8tFRfhMlOva+CdCE7bXuvYAjpRWY
         O7u4cHYVB3AOs3ClsT/V1PHInpR7qS0BTqwdMciYjtTVdzlLa/D2lmQE+eqtCjxaGZ
         MPfx24g9f19+yThTqOx/llXidyEI713MmktAlQ4lKuJJ4lTOE4K2/DidFFLK9749or
         ZGNkEDbvrvnDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B4EBE4D007;
        Wed, 19 Oct 2022 09:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/3] further improvements to marvell,pp2.yaml
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166617001856.30948.3459906903176615096.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 09:00:18 +0000
References: <20221014213254.30950-1-mig@semihalf.com>
In-Reply-To: <20221014213254.30950-1-mig@semihalf.com>
To:     =?utf-8?q?Micha=C5=82_Grzelak_=3Cmig=40semihalf=2Ecom=3E?=@ci.codeaurora.org
Cc:     devicetree@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, upstream@semihalf.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Oct 2022 23:32:51 +0200 you wrote:
> Hi,
> 
> This patchset addresses problems with reg ranges and
> additional $refs. It also limits phy-mode and aligns examples.
> 
> Best regards,
> Michał
> 
> [...]

Here is the summary with links:
  - [v5,1/3] dt-bindings: net: marvell,pp2: convert to json-schema
    https://git.kernel.org/netdev/net-next/c/c4d175c323e3
  - [v5,2/3] arm64: dts: marvell: Update network description to match schema
    https://git.kernel.org/netdev/net-next/c/2994bf7705b4
  - [v5,3/3] ARM: dts: armada-375: Update network description to match schema
    https://git.kernel.org/netdev/net-next/c/844e44988fa8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


