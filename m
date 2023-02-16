Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B50C698C30
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjBPFkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBPFkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353CC8684
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 21:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E0A61E43
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FACBC4339B;
        Thu, 16 Feb 2023 05:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676526018;
        bh=+OcfM+vQkfup84pnqc6c4+7USEtZidYZVNRXmzW6sr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dQbZotZ4/4cj5gTpT9PjI7F/kmF/zOrb3YGH2Vz6h9CfcpvJa5+V+MDJDhriDKp7e
         DM6VIzhTB2Ca9fCSnbCMXnaT1OH9Pep2P5EJOcyDESiG7DHX7R5OUD0S4AP7G8WpnW
         kkSGlh5cYBi8giKcN6WlSeKSp+rNdHnpx80zZ18a9OIK4mdxuIidQN0x9+439p7V3F
         38EYyI+WSi2yXhJskFyKvrb8f1z8wP5UmHXJdF7ChWGi1OsXeI5de2JBeu49a4gcRO
         OnUb593MaACzZUK+yAPLm+fnbXkmDFfZhWz0+5f/59ThOLA39oGvdrjhwc8kPtvy5H
         80i0/mByOTusQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 183B8E4D026;
        Thu, 16 Feb 2023 05:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: wangxun: Add the basic ethtool interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167652601809.11549.2070247181996428312.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 05:40:18 +0000
References: <20230214091527.69943-1-mengyuanlou@net-swift.com>
In-Reply-To: <20230214091527.69943-1-mengyuanlou@net-swift.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Feb 2023 17:15:27 +0800 you wrote:
> Add the basic ethtool ops get_drvinfo and get_link for ngbe and txgbe.
> Ngbe implements get_link_ksettings, nway_reset and set_link_ksettings
> for free using phylib code.
> The code related to the physical interface is not yet fully implemented
> in txgbe using phylink code. So do not implement get_link_ksettings,
> nway_reset and set_link_ksettings in txgbe.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: wangxun: Add the basic ethtool interfaces
    https://git.kernel.org/netdev/net-next/c/1b8d1c5088ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


