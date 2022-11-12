Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E0B62671B
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiKLFKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbiKLFKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7429732B9F;
        Fri, 11 Nov 2022 21:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21490B828B1;
        Sat, 12 Nov 2022 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CCFEC43470;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668229817;
        bh=O1wmr6uzpURPK6728SCLlN76Lo1/fJ6B2XDnMBoE5a4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K/kJ9fCDjl+WAQb35Y+if1lLS0dU3X4PQamQSvNTG5wz5BFP6z5zra1Ycb42ZnAMf
         9Eh2TVch/w3TvXG1otWRnZCjoOzqnPQhqNEhKxqoaSHyu7T28xJGFZqwTfFJchiIiY
         Jv0bsnhivZ7qYS7aPgNMXtX2IaWfpUizebO6xPb36w2R999yzBGUoQwCpvv9O+1dVp
         aKG6bbmvvIGbx5D8aXOh6g0ypIpZ0GL0jcn1PsEj8oYkQP4QEOC33K5x++eM+c4zmy
         euMcq6H2tj9vn/oHwLZUXQY952dZvujZN+LdfvaGlaD+2xM7Z4a5VxRTx7P53nJuhc
         MKhsXM0hoalIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D5C8E524C4;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 RESEND 1/1] net: phy: dp83867: Fix SGMII FIFO depth for
 non OF devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822981737.20406.12251689549170298755.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 05:10:17 +0000
References: <20221110054938.925347-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20221110054938.925347-1-michael.wei.hong.sit@intel.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tee.min.tan@intel.com,
        kuan.loon.lay@intel.com, boon.leong.ong@intel.com,
        hong.aun.looi@intel.com, weifeng.voon@intel.com,
        muhammad.husaini.zulkifli@intel.com, yi.fang.gan@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 10 Nov 2022 13:49:38 +0800 you wrote:
> Current driver code will read device tree node information,
> and set default values if there is no info provided.
> 
> This is not done in non-OF devices leading to SGMII fifo depths being
> set to the smallest size.
> 
> This patch sets the value to the default value of the PHY as stated in the
> PHY datasheet.
> 
> [...]

Here is the summary with links:
  - [net,v2,RESEND,1/1] net: phy: dp83867: Fix SGMII FIFO depth for non OF devices
    https://git.kernel.org/netdev/net/c/e2a54350dc96

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


