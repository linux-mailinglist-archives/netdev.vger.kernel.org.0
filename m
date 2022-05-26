Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C1D534A13
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 07:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345547AbiEZFAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 01:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243334AbiEZFAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 01:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCCC3584D;
        Wed, 25 May 2022 22:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40D0CB81F53;
        Thu, 26 May 2022 05:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7C7AC34118;
        Thu, 26 May 2022 05:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653541213;
        bh=mOCH4xn2m5JiBHeYWV/Xw2hOX3OBziv01IaGGG6OoAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LWCN1bkB6ZEZGa0iBgfTGNVZLec6iCZj/MHemqHEj5gtnYl96Ie/SoHebKJcLwHmd
         jCH73nSSz5iGZMLdzZ5n/WEubmdZg/nzcDlMyzDvTkWWuwpZiq7ZdLL3UOAkMASAQW
         h0gZ9dg4UeO4y9W4Gv7Et7uC3W3D6sfa+e5WMsbk32x6e/i2jEkVtGLjFJjtLKJI/+
         Akw+8Js9uT2leoMMmMfwvZbLG0bWN0vllH4ZyZFTjsfBAAloOlXhWiqtHiZScD/cZd
         7w2l932qv1HE7h8f5a90JnPUSrSQjd4p7wFWx55H9Pl4axBzmxY8d6+TA81T5d0NCg
         giVdHfTJC/m3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C841DF03938;
        Thu, 26 May 2022 05:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw: Fix fwnode passed to
 phylink_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165354121281.19512.8393354174937220094.git-patchwork-notify@kernel.org>
Date:   Thu, 26 May 2022 05:00:12 +0000
References: <20220524062558.19296-1-s-vadapalli@ti.com>
In-Reply-To: <20220524062558.19296-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, vigneshr@ti.com, grygorii.strashko@ti.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 24 May 2022 11:55:58 +0530 you wrote:
> am65-cpsw-nuss driver incorrectly uses fwnode member of common
> ethernet device's "struct device_node" instead of using fwnode
> member of the port's "struct device_node" in phylink_create().
> This results in all ports having the same phy data when there
> are multiple ports with their phy properties populated in their
> respective nodes rather than the common ethernet device node.
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: am65-cpsw: Fix fwnode passed to phylink_create()
    https://git.kernel.org/netdev/net/c/0b7180072a9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


