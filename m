Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749DD4BA7CE
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240946AbiBQSK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:10:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiBQSK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:10:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13FE1728AE;
        Thu, 17 Feb 2022 10:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47ADE61A0D;
        Thu, 17 Feb 2022 18:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3856C340ED;
        Thu, 17 Feb 2022 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645121411;
        bh=WZd206Q6M+236kpARfk6Nd2RbCGgBa5GJlk1ZQTn4WU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m1AQeFTssf5h6LGCMQ3rxEVgvD7WFTpDOSDn2DPRipDNEJKcAQCpqDfGoGMyMThd3
         HgqeotnPQQuK7MkEXVzYtqjRmyWvCl2uvBWZ52xtmb1uUxb8FM9+gjv5W/jqKfY9U0
         AuaGwDpLN13eTcNK9FLslQLxiGBxuW+YY8pVdG5MqfqUNoZjM83KdyinQ3405D84HD
         doG8pV/OrexmoN7V16GMiJzKw9WEtHCx1VkGNhQeoph5tcLnSzFFGL1/qRVFqbvMJk
         6850iVnvi7SmR8gNz3s3gzSWtG0OG75qsR82pUJzBzEykxusJVc+o1aklNj1UkI2vt
         /yyuKdnfXYgrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F516E6D446;
        Thu, 17 Feb 2022 18:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: lan9303: add VLAN IDs to master device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164512141158.19163.7628868229359172313.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 18:10:11 +0000
References: <20220216204818.28746-1-mans@mansr.com>
In-Reply-To: <20220216204818.28746-1-mans@mansr.com>
To:     Mans Rullgard <mans@mansr.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Feb 2022 20:48:18 +0000 you wrote:
> If the master device does VLAN filtering, the IDs used by the switch
> must be added for any frames to be received.  Do this in the
> port_enable() function, and remove them in port_disable().
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---
> Changes:
> - Fix dependency on VLAN_8021Q
> - Add missing #include
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: lan9303: add VLAN IDs to master device
    https://git.kernel.org/netdev/net/c/430065e26719

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


