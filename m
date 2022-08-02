Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573A4587806
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 09:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiHBHkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 03:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbiHBHkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 03:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B1DE1
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 00:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EB796141D
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 07:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4EC4C433D7;
        Tue,  2 Aug 2022 07:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659426012;
        bh=N85Ph2bMXyjQe4tZPmer5kHa5sBc9aSNWTJ5BfltsWk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N+oUT3Uh2SN0rvIs9zetalZn87abSMIrdOaNTva8sE1YZ0MgL47fpbsYD2vrAAfCp
         jmahLTxIoBRCS2an50Kwd6OfBRRf/xezr2vnc5i14cusVNm2XUwfrcC2XiMIG6kzCu
         5mKUmNG3vcEd6cA9Mjn3exFRkRb7sTj5nNoD5awrazXCjX5ArG/mbsKcg/DgQzRAZQ
         TDD/W5IyCCBd+RpZ8K7WjBq66KrIC49DzCNtuOCI70XfvTCfLu/AlqUq6FJqJUeSJv
         aco0phTasf5jTBurX2qASO+DlSDEhWJlq1T3QfhqhQm6s+XeOcxalMEmj7iZGaLqXS
         WP+3J7/7uwA5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B966CC43142;
        Tue,  2 Aug 2022 07:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: make USB_RTL8153_ECM non user configurable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165942601275.26547.3446508868569891428.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Aug 2022 07:40:12 +0000
References: <20220730230113.4138858-1-zenczykowski@gmail.com>
In-Reply-To: <20220730230113.4138858-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, netdev@vger.kernel.org, geert+renesas@glider.be,
        gregkh@linuxfoundation.org, hayeswang@realtek.com, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 30 Jul 2022 16:01:13 -0700 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This refixes:
> 
>     commit 7da17624e7948d5d9660b910f8079d26d26ce453
>     nt: usb: USB_RTL8153_ECM should not default to y
> 
> [...]

Here is the summary with links:
  - net: usb: make USB_RTL8153_ECM non user configurable
    https://git.kernel.org/netdev/net/c/f56530dcdb06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


