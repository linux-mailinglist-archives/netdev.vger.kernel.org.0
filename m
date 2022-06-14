Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0425554A955
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350741AbiFNGUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350462AbiFNGUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9787D37A84;
        Mon, 13 Jun 2022 23:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35D5C60B6A;
        Tue, 14 Jun 2022 06:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C884C36B09;
        Tue, 14 Jun 2022 06:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655187613;
        bh=OH604z9q8hs1FJx9AZ0a8xeYy+Ho3/Eyv1sdOh/pIgs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=USVibk77FxLf57AJ44EBVYk09eG3MnCS4JlzpptKKzAnX5alS8abFHrI89Mx56TfS
         5OtppB6MFmoqu61R05mdhr4ffr7ZjBsqAFa3eGtHC2K1YhYkPYBq1zsNdkSdiMW0s/
         7bwYTst3jkyI4vP1Mo0XPMXdrHblRbaQLRze6XLtDCKdxxHs/xJDzs8R5PCFow4a6S
         iZCLMaLaP5rCUxqFPqygLZJ2Z6LgKDysV0outGVHz1OHo52ao5T4wSqxm2tFQX6Q+P
         hmAvurKHKwVC0rpyHp1Zpzg3cdDDNYzF0t5SqHmAMzsDnxhaJSY9d56IgC2E+AC74+
         BuM8AueNrd9pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F9F3E6D482;
        Tue, 14 Jun 2022 06:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] docs: networking: phy: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165518761345.22663.1630253826572230261.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Jun 2022 06:20:13 +0000
References: <20220610072809.352962-1-j.neuschaefer@gmx.net>
In-Reply-To: <20220610072809.352962-1-j.neuschaefer@gmx.net>
To:     =?utf-8?q?Jonathan_Neusch=C3=A4fer_=3Cj=2Eneuschaefer=40gmx=2Enet=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 10 Jun 2022 09:28:08 +0200 you wrote:
> Write "to be operated" instead of "to be operate".
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  Documentation/networking/phy.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - docs: networking: phy: Fix a typo
    https://git.kernel.org/netdev/net/c/9cc8ea99bf7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


