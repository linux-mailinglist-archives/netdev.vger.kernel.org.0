Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE34516463
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347025AbiEAMdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 08:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346975AbiEAMdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 08:33:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03732CEE;
        Sun,  1 May 2022 05:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B666B80D39;
        Sun,  1 May 2022 12:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4209BC385A9;
        Sun,  1 May 2022 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651408212;
        bh=fbgICJHMyi+PJLgMW4ywEn4tsp6nyzCg/096sp1Xdz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k7pPi1lDlbo274WbeJec2G3wTZbigFuwDcWoweZo+unCzhkx3d/TVggZmF4Re1dg0
         lBSU1lViYqU+S/jiU/Y5BHYfbVjbAkvs599vSSu4N1pYhwqXhrxBdOnhbBusWkeEUd
         H6QbPSjkTtDFvuhRcfnUIbdkdgKh+ouPYEAQshIE6qjnEEAuwFCDI7xvM4dw2mm40H
         SC7m9Ow6zPto3+kBRfM0uXxTwOqaJc+PPNuU6j1vQ8ijWaiifoQ6iyxr52+zIGbEp5
         XeBivddtb85tpTI1BvKLGL1p+CGu2qFyPw+5CJ/SDtpPYbkm31I6IC6tj6Ez9phB30
         XHHUi8KSONN0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23921E8DBDA;
        Sun,  1 May 2022 12:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v6 0/2] Replace improper checks and fix bugs in nfc
 subsystem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165140821214.17181.2516718625750053871.git-patchwork-notify@kernel.org>
Date:   Sun, 01 May 2022 12:30:12 +0000
References: <cover.1651235400.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1651235400.git.duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, alexander.deucher@amd.com,
        broonie@kernel.org, linma@zju.edu.cn
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 20:45:49 +0800 you wrote:
> The first patch is used to replace improper checks in netlink related
> functions of nfc core, the second patch is used to fix bugs in
> nfcmrvl driver.
> 
> Duoming Zhou (2):
>   nfc: replace improper check device_is_registered() in netlink related
>     functions
>   nfc: nfcmrvl: main: reorder destructive operations in
>     nfcmrvl_nci_unregister_dev to avoid bugs
> 
> [...]

Here is the summary with links:
  - [net,v6,1/2] nfc: replace improper check device_is_registered() in netlink related functions
    https://git.kernel.org/netdev/net/c/da5c0f119203
  - [net,v6,2/2] nfc: nfcmrvl: main: reorder destructive operations in nfcmrvl_nci_unregister_dev to avoid bugs
    https://git.kernel.org/netdev/net/c/d270453a0d9e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


