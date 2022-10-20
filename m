Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0BE6055CC
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 05:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiJTDKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 23:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiJTDKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 23:10:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51102B44B4;
        Wed, 19 Oct 2022 20:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D746EB8267A;
        Thu, 20 Oct 2022 03:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BD1CC4314B;
        Thu, 20 Oct 2022 03:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666235417;
        bh=DLmJbCWm+8J3OOBfb+g83kn7KJJ+LObNdGTvbZBxvpk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b+3lRG5zHjB43z0WDX2NmVFjNjyXwHEXKUx2tt3x3wp388pcAO58FLeTPQOH/hJlL
         25ftJ4QliL4o2pNr0yawGIY6Lxagh/ZKTa7AGIamCKFBAvsghOXuPfSdiP5XR9y104
         C5kBLiAqTB3XswTyaAq54QnvdW972NN1ozHeHNsL3WcSiM3wsVEUATcH1PHRsSAET8
         JQvB0O95n5q0uj2wp5lsDN4cDpOLI8iTcl0GYfGoGHdS2HxnVDYYg1g02kqlwmpuZM
         dAsebSZrGv8+v5JPjJnzUds0C9j8DgVA4H1LgO94FuRkiIHteXZfAJgKf9SxLRiDm5
         nZ6NLH2Evzx6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78602E4D007;
        Thu, 20 Oct 2022 03:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: dp83822: disable MDI crossover status change
 interrupt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166623541748.4513.6862768242982620991.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Oct 2022 03:10:17 +0000
References: <20221018104755.30025-1-svc.sw.rte.linux@sma.de>
In-Reply-To: <20221018104755.30025-1-svc.sw.rte.linux@sma.de>
To:     Felix Riemann <svc.sw.rte.linux@sma.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, felix.riemann@sma.de
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

On Tue, 18 Oct 2022 12:47:54 +0200 you wrote:
> From: Felix Riemann <felix.riemann@sma.de>
> 
> If the cable is disconnected the PHY seems to toggle between MDI and
> MDI-X modes. With the MDI crossover status interrupt active this causes
> roughly 10 interrupts per second.
> 
> As the crossover status isn't checked by the driver, the interrupt can
> be disabled to reduce the interrupt load.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: dp83822: disable MDI crossover status change interrupt
    https://git.kernel.org/netdev/net/c/7f378c03aa49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


