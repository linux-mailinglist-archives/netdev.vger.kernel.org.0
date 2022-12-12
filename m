Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A90564A93F
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbiLLVL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiLLVLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:11:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD38186D2;
        Mon, 12 Dec 2022 13:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58FF361237;
        Mon, 12 Dec 2022 21:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B44D2C433F0;
        Mon, 12 Dec 2022 21:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670879472;
        bh=eNAFHLoYV9t7lzJIhDLruB9kABFes4YL2YZMSfG6ibA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OxIOOfb4DWldn+Rth+u+Rx5MhuwuInRAh6WI2IfAwkUyokP1FBh/yYyl0cjuEFLL0
         TplcKMOrLlBskQ/VNjjBo58EOp/hKRSLHy4Zr4eeDjrHsRqAefq5eDM1Lus/M3FA0m
         aTxfDDjqdSQ9D04sinR7M4Wa91JqFXf3Ls5W0mb5vOFJjC5mZKxbLVTtH4uhbEd2zm
         AVxDxGn5EyOwRQZOeRdNXuF21ZL2LwwZFQ0S9iw2z6p7wkX7x4xrrSrbqecIUCh6Fw
         j52b5bdUAlxZJIGdj4pSCIosO1e2+qIQV7CIx3ZcUykBDZtNrw1cglUuIVJIQeVtQs
         Cn8pfzj0A2J1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B7BCC41606;
        Mon, 12 Dec 2022 21:11:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: Convert Socionext NetSec Ethernet to DT
 schema
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087947263.28989.14967575841484892448.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:11:12 +0000
References: <20221209171553.3350583-1-robh@kernel.org>
In-Reply-To: <20221209171553.3350583-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        ardb@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Dec 2022 11:15:52 -0600 you wrote:
> Convert the Socionext NetSec Ethernet binding to DT schema format.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../net/socionext,synquacer-netsec.yaml       | 73 +++++++++++++++++++
>  .../bindings/net/socionext-netsec.txt         | 56 --------------
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 74 insertions(+), 57 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/socionext,synquacer-netsec.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/socionext-netsec.txt

Here is the summary with links:
  - dt-bindings: net: Convert Socionext NetSec Ethernet to DT schema
    https://git.kernel.org/bpf/bpf-next/c/15eb16217621

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


