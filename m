Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2A5808EE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 03:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiGZBKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 21:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiGZBKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 21:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A912650;
        Mon, 25 Jul 2022 18:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFF93B8116B;
        Tue, 26 Jul 2022 01:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63809C341C8;
        Tue, 26 Jul 2022 01:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658797813;
        bh=r0Lq7oKCtzNVIU0N4Ux4OuVGBTbQIOccs43EHtMEXik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=onUQu0WrosCKTEtORzF8bZoPmO1Yy9a+XvjGcul2Tax0cdYFMROuKDBQPvr9MdLmb
         xm5Ik636gF6Ow+qwwDkfaP16ueZhT9zIuFb8UHBR9goSybLH+39jo9UHzTXd1D9hxZ
         rXeHAp/GFrxM+gDPItNjABSS8DjREQhmw8tJG0Y+E8W3NnwOQwqz04d2eQaa0IPp+5
         lrqFGGDEN6UcYm8cjtPohy0/OAoeYYDAviB1IUsRLv1tji19WofNmHa/dvdkyXe/4n
         z5Ti4oEb+hISBcqcwvGOX/H0/RH+NO94JODgjMzO963WOKm9w0sLDbYyzYi7rNuJIJ
         uvyHs6JFNKHzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49661E450B6;
        Tue, 26 Jul 2022 01:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/1] dt-bindings: net: fsl,fec: Add nvmem-cells /
 nvmem-cell-names properties
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165879781329.30024.16383625265240805609.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 01:10:13 +0000
References: <20220720063924.1412799-1-alexander.stein@ew.tq-group.com>
In-Reply-To: <20220720063924.1412799-1-alexander.stein@ew.tq-group.com>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 20 Jul 2022 08:39:24 +0200 you wrote:
> These properties are inherited from ethernet-controller.yaml.
> This fixes the dt_binding_check warning:
> imx8mm-tqma8mqml-mba8mx.dt.yaml: ethernet@30be0000: 'nvmem-cell-names',
> 'nvmem-cells' do not match any of the regexes: 'pinctrl-[0-9]+'
> 
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> 
> [...]

Here is the summary with links:
  - [v3,1/1] dt-bindings: net: fsl,fec: Add nvmem-cells / nvmem-cell-names properties
    https://git.kernel.org/netdev/net-next/c/5030a9a03f01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


