Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9996C7B18
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbjCXJUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbjCXJU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:20:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C199B23324;
        Fri, 24 Mar 2023 02:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31C5AB82350;
        Fri, 24 Mar 2023 09:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C78F5C433A4;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679649620;
        bh=8FwmIpt8pelwGKmBKKYDfVHKI+jYtA4KRI1dwVdX60s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KTGt/Kh6Anv7fvZLeq01fhaA/ljteD8Kynwlmw+H0F8fPGq3YdELFeTpbG82tSBgo
         +gwLykjAZV8sOb7zXvkWYRcm92qr0WgfeIr+XIdRZqKLwIHfQgyZ674SdoNO7QviG/
         +9wCMi9AeYsKHMnxAMYKDgQ36y1iM41v5E6bt8syDgxMxvcGIG0IwlnaW72kNzM0ah
         p5mcGoRXp5hkPuFptvMQOniECA2OWyVr2+zRwYeSuXRlVOV9mKhvLm21wv4wpbENqd
         rcvVzgK2tYZ1wffC6dEMgOtTw1Apg+QIeYMxFx9LGHHnB7AjSMHnX2bwy74zYzyi/v
         /0U8BxbDB7yPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93BD9E52505;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: mISDN: netjet: Remove redundant pci_clear_master
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167964962060.21111.12070428001601420604.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 09:20:20 +0000
References: <20230323115912.14443-1-cai.huoqing@linux.dev>
In-Reply-To: <20230323115912.14443-1-cai.huoqing@linux.dev>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     isdn@linux-pingi.de, yangyingliang@huawei.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 19:59:11 +0800 you wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
> 	u16 pci_command;
> 
> [...]

Here is the summary with links:
  - isdn: mISDN: netjet: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/950bfdcf17ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


