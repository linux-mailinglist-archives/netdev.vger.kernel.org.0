Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987B3590493
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbiHKQc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238944AbiHKQbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DC329C;
        Thu, 11 Aug 2022 09:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB6236141C;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C481C433D7;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234215;
        bh=HXAbDfVeXmIO5DEFlIxEcJYO7aeSrFuwHUb0hgRFnoA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uv3O1Kt1q6z/eN1cEL2/BHFpyxBdegNZvreMLJr/KyXa+ZRT/eHBGb4xi3jdEOOtR
         Wm0+pHPzrqQm81UjWFJFyqGeF9kvdIUeGm3HJ7t8rsM/L2TGpgR9HpA+GiBmhiJwd/
         PAwCPS6TxrCXAVfkYXyxSpyHeu7C2DP5w+fESSp0RW0yYHyN60BO8SViml1wLOgQKd
         G43la+Af9BoRscgBqnv8VVhQskvczXqpeGhWliEXyD2y5wTHdYKhn0monw3dYLM4NQ
         NKdux0pc2CDi+e/kSK4mkGWTt8onL3a3GM2gz3ryynukA7TclWg9JK4ixYKXunS0Ks
         8t9s3BYFoSF9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C2F0C43143;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: fix reference count leak in balance-alb mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166023421511.9507.3349317019551791684.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 16:10:15 +0000
References: <26758.1660194413@famine>
In-Reply-To: <26758.1660194413@famine>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, sunshouxin@chinatelecom.cn,
        vfalico@gmail.com, andy@greyhouse.net, razor@blackwall.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 Aug 2022 22:06:53 -0700 you wrote:
> Commit d5410ac7b0ba ("net:bonding:support balance-alb interface
> with vlan to bridge") introduced a reference count leak by not releasing
> the reference acquired by ip_dev_find().  Remedy this by insuring the
> reference is released.
> 
> Fixes: d5410ac7b0ba ("net:bonding:support balance-alb interface with vlan to bridge")
> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> 
> [...]

Here is the summary with links:
  - [net] bonding: fix reference count leak in balance-alb mode
    https://git.kernel.org/netdev/net/c/4f5d33f4f798

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


