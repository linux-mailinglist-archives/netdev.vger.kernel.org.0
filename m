Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0916B8607
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCMXUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCMXUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAEF59417
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADD1061552
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11BA1C4339B;
        Mon, 13 Mar 2023 23:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678749618;
        bh=wS2yyNYTZuA4Q/mmHf+Y46aW2zaP2IbSLf6oWqb5qr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NbKgpGb4hoZi+qHaOx2QQARUQSxsuh63IHycPC/zkFfMp/2B5wCIh7+DrQ6Nm65mP
         U//77j1s2qzvgLP+XrQdhkoXrj3IPUhmt2JCPqsBwgvpJ5N4Kcmr9hekAH5odQ1vSH
         TBhNSxFNU81BxqKS7KWscGtKRXpRa4UwfM4pv4RE+IMgshzBz8TOA+n8BPi2KjofsZ
         E7h4Qi4Qz3JxstP6STlrjbUpwGgdpn/0vPc6YkSN2l4YjoAidhP/qozzVwbJrCLdVj
         Ju4H5RU7dvTuh7emkk32OUeN6zf8tTmYB5CntKQ5qo5dSQVGU+CgXdiTuOqkRwREu+
         zfaCADRFb3AlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2F56E66CBF;
        Mon, 13 Mar 2023 23:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: smsc: use device_property_present in
 smsc_phy_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167874961792.24202.9061823773020541798.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 23:20:17 +0000
References: <a969f012-1d3b-7a36-51cf-89a5f8f15a9b@gmail.com>
In-Reply-To: <a969f012-1d3b-7a36-51cf-89a5f8f15a9b@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, pabeni@redhat.com,
        edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 8 Mar 2023 21:34:13 +0100 you wrote:
> Use unified device property API.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/smsc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: smsc: use device_property_present in smsc_phy_probe
    https://git.kernel.org/netdev/net-next/c/90c7dd32652b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


