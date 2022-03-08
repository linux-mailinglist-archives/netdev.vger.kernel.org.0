Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09FF4D1048
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244660AbiCHGbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243525AbiCHGbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:31:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6EC3C731;
        Mon,  7 Mar 2022 22:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 993A2B8163C;
        Tue,  8 Mar 2022 06:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 416C2C340F6;
        Tue,  8 Mar 2022 06:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646721011;
        bh=amHobqnmxSrruYg/xzEG3Ri5SrOTXrYTuXAU8nd4rr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AlrsDfjMwD7rQUt6T8Jfcm8D44C/yMEgmkHTMnemGD1d1pDOi8hwJSPKAkKCIOQqe
         7SpNNWpiROf+GO549DQJpaVM5OVTSo1bYmbjDo6JBr8PUZvIfMjLESnX359l7Wo8Rv
         VMc8alpm2VsEr+eV8h11xGSKiWq0ks+PCnEftuXX/Z/O7tgfsKciH6mBq1Pn5nEj7/
         9XTyZn1y3f/tjDb5ah1qSg0sn4AT+S9nCuO4SAnHAE8wCBso0KxDGjfdXinaay4a3M
         xUCcHrLdtOhGqoo447MfyeusxfSEWAp5mz3Q2SBP6Cl+H76LDpgJDhdJ+dwoeh2BPE
         LMLaewMTXgcvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AEB5E6D3DE;
        Tue,  8 Mar 2022 06:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: cxgb3: Fix an error code when probing the driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164672101117.16776.14954414066959843384.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 06:30:11 +0000
References: <1646546192-32737-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1646546192-32737-1-git-send-email-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     andrew@lunn.ch, rajur@chelsio.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun,  6 Mar 2022 05:56:32 +0000 you wrote:
> During the process of driver probing, probe function should return < 0
> for failure, otherwise kernel will treat value >= 0 as success.
> 
> Therefore, the driver should set 'err' to -ENODEV when
> 'adapter->registered_device_map' is NULL. Otherwise kernel will assume
> that the driver has been successfully probed and will cause unexpected
> errors.
> 
> [...]

Here is the summary with links:
  - [v2] net: cxgb3: Fix an error code when probing the driver
    https://git.kernel.org/netdev/net-next/c/69adcb988a06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


