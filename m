Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E3D52CA13
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiESDKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiESDKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6401DE315
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 139EE6190F
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 709CAC34100;
        Thu, 19 May 2022 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652929813;
        bh=245prJWn1rlZriErUJ/z90OJPalVP+KXyZZL9sJN9hU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JY20wFmL9MJ84lo2/525f6MCXdkRB7toRaNsthvRHmNaYXDbuh2bztm4DyfmSXo2h
         E43PM2Nlo4Wxb/x6WOQINq6dagCGAWysgwpV45VxsY1y0wu3VuTly6pOoqmqbocc9W
         1UCH3pB0tmYlz/pX98kyo/1Spd2YaxgRx6+eMC6upx0t+QM8qsGVNsjcMfh0dqIKiw
         GXcmia7/6DCORK5Cq7m+fgFSq7Yb3iX6JhShY8guR1ZXUCa6/JQMhzNXC0I8NI4HbM
         syj3y1NC5hClDZXw0YAqLziovQEJPuviO0xNx1d+6YPfixmXQtZbwkiiW+mM0p7AUb
         Df6tUd8UhPqQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BF27F0393A;
        Thu, 19 May 2022 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/3] adin: add support for clock output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165292981330.2906.12801797819265056306.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 03:10:13 +0000
References: <20220517085143.3749-1-josua@solid-run.com>
In-Reply-To: <20220517085143.3749-1-josua@solid-run.com>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, alvaro.karsz@solid-run.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 May 2022 11:51:36 +0300 you wrote:
> This patch series adds support for configuring the two clock outputs of adin
> 1200 and 1300 PHYs. Certain network controllers require an external reference
> clock which can be provided by the PHY.
> 
> One of the replies to v1 was asking why the common clock framework isn't used.
> Currently no PHY driver has implemented providing a clock to the network
> controller. Instead they rely on vendor extensions to make the appropriate
> configuration. For example ar8035 uses qca,clk-out-frequency - this patchset
> aimed to replicate the same functionality.
> 
> [...]

Here is the summary with links:
  - [v5,1/3] dt-bindings: net: adin: document phy clock output properties
    https://git.kernel.org/netdev/net-next/c/1f77204e11f8
  - [v5,2/3] net: phy: adin: add support for clock output
    https://git.kernel.org/netdev/net-next/c/ce3342161edc
  - [v5,3/3] ARM: dts: imx6qdl-sr-som: update phy configuration for som revision 1.9
    https://git.kernel.org/netdev/net-next/c/654cd22227e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


