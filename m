Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA87606F39
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJUFLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJUFKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7509760E5
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 22:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC603B82AD2
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83E73C433B5;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329020;
        bh=PSgnbyDEPKTqFLJRnRcCCbYN2gyf81Ap8Fm0FHpcl/I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iSzhq/wgLAG6XNaqthlbWRZiXW+uysewMhG0PYRzul4y2mkKvbMLGHuwdPVhNZf+M
         3F8ZFuASAmAZeu6zZXMSOSQUiJpv3ZzfXTNig7irakstqy8/BBXIzqRPXiC2d8i1Kw
         a8RNI2IvcexXyUz4hCBIOftzrsdjTmrZ2hbPorLHCLd/aBvyKnAMhgHPEnSBYPRbbp
         cF9OzyGZW4m6A7ipuXuU6FBL9fKEO+HV5zsChZGcqEeGRLop40/bpam2l6cS57qOMX
         2wQvjtQ/PhO1yMHazOUtZfsrxNKP0IGGTLW/WElYq7G4LmRsXbjurJ2CDrU0F3F+iB
         QoIIrhnXgMqSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66CA4E270E1;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: netsec: fix error handling in netsec_register_mdio()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902041.25874.12951829962393837413.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:20 +0000
References: <20221019064104.3228892-1-yangyingliang@huawei.com>
In-Reply-To: <20221019064104.3228892-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, ard.biesheuvel@linaro.org,
        jaswinder.singh@linaro.org, davem@davemloft.net
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Oct 2022 14:41:04 +0800 you wrote:
> If phy_device_register() fails, phy_device_free() need be called to
> put refcount, so memory of phy device and device name can be freed
> in callback function.
> 
> If get_phy_device() fails, mdiobus_unregister() need be called,
> or it will cause warning in mdiobus_free() and kobject is leaked.
> 
> [...]

Here is the summary with links:
  - [net] net: netsec: fix error handling in netsec_register_mdio()
    https://git.kernel.org/netdev/net/c/944235896891

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


