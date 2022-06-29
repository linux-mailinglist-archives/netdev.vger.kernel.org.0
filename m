Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B6F55F589
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 07:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiF2FKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 01:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiF2FKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 01:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701112E086;
        Tue, 28 Jun 2022 22:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A74761629;
        Wed, 29 Jun 2022 05:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62457C3411E;
        Wed, 29 Jun 2022 05:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656479413;
        bh=fH3KHSSPf/f1Sz+0BB9KsOfbCTRq1jMyu37S09YyXIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bGpHiYwPHhEmiSgprJfcxktSY55yfG020yZtSnhmEP1vmvF+eio7enY0xaLp7vuG6
         k/33HOzkFH7g2DIWHSz4jYwUrAypLyIob+Duh66f2QwAGLZHvPGEi7oPiLJC0ng9r+
         /zndPUshYw+NSp3NWic67y0zhy7crTPwjdacmT6uXlPQrPF7vpaO0TMPJzJzoyNBEi
         bGvGFXrqI8y+wrPrm6OvlQf5eicB1rXPDvIw+4DG6QVjb2z5+fGtY8W3axiOXs9vzt
         1ba72ZvypwxcVlrsj10Rdc3ovbl9bAxhSTQhGsOVOasAr7zPm6JTgjL6OxhfQsFazj
         hjAp/6iRIttOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43CA2E49F61;
        Wed, 29 Jun 2022 05:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert the ARM/dts changes for Renesas RZ/N1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165647941327.13568.9977362848658590724.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 05:10:13 +0000
References: <20220627173900.3136386-1-kuba@kernel.org>
In-Reply-To: <20220627173900.3136386-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, geert+renesas@glider.be, magnus.damm@gmail.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Jun 2022 10:39:00 -0700 you wrote:
> Based on a request from Geert:
> 
> Revert "ARM: dts: r9a06g032-rzn1d400-db: add switch description"
> This reverts commit 9aab31d66ec97d7047e42feacc356bc9c21a5bf5.
> 
> Revert "ARM: dts: r9a06g032: describe switch"
> This reverts commit cf9695d8a7e927f7563ce6ea0a4e54b8214a12f1.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert the ARM/dts changes for Renesas RZ/N1
    https://git.kernel.org/netdev/net-next/c/eba3a9816ad1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


