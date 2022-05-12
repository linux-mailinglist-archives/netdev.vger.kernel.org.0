Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4189E5248F4
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 11:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbiELJaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 05:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiELJaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 05:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07FC496BE
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 636EAB8271B
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA13FC34100;
        Thu, 12 May 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652347812;
        bh=J0ndGc5kgAa7XcHUugLBWJQg5zkwwGHM8WDRXF6rrIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CIkihvBoFmb/uRkdHap22Nd/3wBN/jD5URUGV3PEitoCP6i86C/PdahPkAE5YX5Pk
         5EbLNevwsyrkE1Ba80QiGTVUiLfXC5oJVDYLKebPbvJjQx0cEWO4+xUsfD/EZZvBV3
         nihjnXfso9w6HENcEUpMmJyhvQt9WALpVQK3vu0lZndFIM5exR/1ge176gB9lEoYGc
         KF46wrGLwT+7oAG3p/JeqyDBcDzuQd4EgnXMh1qmGScucPJ7Xwh+lcdFZJ69Aq6l2r
         H71rQ4Hv+LgxQSz9dL/o+f1IG4oVC59DpzkUMdzJ+OJfN8KNmde2HjGvjCa5nszggx
         Ro0np/ElM4wjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD0E6F03935;
        Thu, 12 May 2022 09:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: enetc: kill PHY-less mode for PFs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165234781183.20356.8084203949340679535.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 09:30:11 +0000
References: <20220511094200.558502-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220511094200.558502-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, claudiu.manoil@nxp.com,
        michael@walle.cc
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 11 May 2022 12:42:00 +0300 you wrote:
> Right now, a PHY-less port (no phy-mode, no fixed-link, no phy-handle)
> doesn't register with phylink, but calls netif_carrier_on() from
> enetc_start().
> 
> This makes sense for a VF, but for a PF, this is braindead, because we
> never call enetc_mac_enable() so the MAC is left inoperational.
> Furthermore, commit 71b77a7a27a3 ("enetc: Migrate to PHYLINK and
> PCS_LYNX") put the nail in the coffin because it removed the initial
> netif_carrier_off() call done right after register_netdev().
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: enetc: kill PHY-less mode for PFs
    https://git.kernel.org/netdev/net-next/c/0f84d403b8e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


