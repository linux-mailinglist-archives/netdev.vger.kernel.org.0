Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A86578026
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbiGRKuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiGRKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1381EEC0;
        Mon, 18 Jul 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5F18B81122;
        Mon, 18 Jul 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61D94C341CA;
        Mon, 18 Jul 2022 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658141413;
        bh=5oSvx7kLd/T0lLOy1aU5/GsDPDl7H8NGjto/IHYUaJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vr1Dr/Meqmp42ztJ3qXFvYAcjbE8sbjYiBaO2vtROKXzd3JAW14PjiMXSexJXzIXN
         vCwSzA45Z5iGjikG1K3ls+5ppr9DIx9beNdMBblv1FLzRJZrKlYMkfWNAaWBtEKEox
         1N0CiZvH1RjebC7ZooMfoxCdD5sv8CmsNkH7OIwOheIZnHcCQ+y5jTcA27HX9hFCLE
         lc/DzF+objZ66kvoAr/ipObfUcK6ul5rRMBP7EP6rK9FSA4TPK4h38HU+HwHBGuUVB
         FOWgPZqzvROFlkD4pyg5X/zWduxX1VRcWVEbhp4FuP41BmY38W3ONuEXYaEXgDjYe6
         lpHPjpKaqVLwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43A17E451B0;
        Mon, 18 Jul 2022 10:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: prestera: acl: use proper mask for port selector
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165814141327.26482.4290812400617870214.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 10:50:13 +0000
References: <20220715125550.19352-1-maksym.glubokiy@plvision.eu>
In-Reply-To: <20220715125550.19352-1-maksym.glubokiy@plvision.eu>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, yevhen.orlov@plvision.eu,
        vmytnyk@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Jul 2022 15:55:50 +0300 you wrote:
> Adjusted as per packet processor documentation.
> This allows to properly match 'indev' for clsact rules.
> 
> Fixes: 47327e198d42 ("net: prestera: acl: migrate to new vTCAM api")
> 
> Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
> 
> [...]

Here is the summary with links:
  - [net] net: prestera: acl: use proper mask for port selector
    https://git.kernel.org/netdev/net/c/1e20904e4177

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


