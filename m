Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B5509FCE
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385259AbiDUMnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 08:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385061AbiDUMnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 08:43:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4BD1CFEA;
        Thu, 21 Apr 2022 05:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49A2B61C5A;
        Thu, 21 Apr 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A79B4C385A1;
        Thu, 21 Apr 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650544811;
        bh=W830rsXdVoz6lGkLr6jz/XzdBaWMYcxDel5ra7LJO3I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=np8KbkB0CuWJSnDyEtWq9lIDu9iGdDihH9vlphk/9CiKjmUBY07helW6DRA4DTiht
         6ft88xPDrmjvSuJYSMHuhEvtxw6kOzAxWZ05vbnc4MtGPNNAhhk0Rsc+B1kEzlBvDk
         +lQo259F0CJ8vgYyffcUe/eyQWJm42da85stthOAxEUO1oIwEEErYv2LIVJ2Ia4fyj
         jkCeHdrcbAIRLHFsczGlU+38OIQ1D+QY3vT4zQkAxoSomKnWhOllDb4HucfdoXbUO/
         CvZn5FudSKhCsBOQMum2bOTcOaS6Pk4F6laLcArvOrFc87rCb4GN18b/UAe/0gk+oa
         VyKG52+Ma4iTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86F04EAC09C;
        Thu, 21 Apr 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: davinci_mdio: using pm_runtime_resume_and_get
 instead of pm_runtime_get_sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165054481154.27620.9902312033676025709.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Apr 2022 12:40:11 +0000
References: <20220418062921.2557884-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220418062921.2557884-1-chi.minghao@zte.com.cn>
To:     Lv Ruyi <cgel.zte@gmail.com>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 18 Apr 2022 06:29:21 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - drivers: net: davinci_mdio: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
    https://git.kernel.org/netdev/net-next/c/4facbe3d4426

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


