Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014B2544244
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbiFIEAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiFIEAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29F2762A9;
        Wed,  8 Jun 2022 21:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21BE561C55;
        Thu,  9 Jun 2022 04:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 767DFC341C0;
        Thu,  9 Jun 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654747213;
        bh=rgxr/4Tg9HNdxH5XrOALkDvI51/BEua6RuB+OZ6OEiM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oAn+zPQIlxWAoI0Dy4rOU19MmE2GslFtIawKdbrPcVQwU+d/92x0DrBIDX2liMIuG
         FxHWONm4v3okaVEikoGPC5j6C8bzz6+h0pDHXF1b+IfRrVdx5naeNLFU0N3XZLDuvg
         S777DUerYOomSJV0b77ICbgloNngg0PmNSpK1EiapBF206mkrj9jVtEon9HEYRAlVc
         WeBeioNXUaxR9hN7P1321fvu6pWCOmFVjbmXqL6SGvJoC/nVPv9KyqpZIm6hx2Jtm1
         BujCtKrg2GFyfcJaPvyHHrT9QuLBkbUbJ5dx1hFQK0Dw8xm6rwpMy5QXJz3mikvHzr
         cCzGwS5Uuub0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58669E73803;
        Thu,  9 Jun 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: openvswitch: fix misuse of the cached connection on
 tuple changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474721335.28317.13891596289407193107.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:00:13 +0000
References: <20220606221140.488984-1-i.maximets@ovn.org>
In-Reply-To: <20220606221140.488984-1-i.maximets@ovn.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        aconole@redhat.com, pvalerio@redhat.com, stable@vger.kernel.org,
        frode.nordahl@canonical.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  7 Jun 2022 00:11:40 +0200 you wrote:
> If packet headers changed, the cached nfct is no longer relevant
> for the packet and attempt to re-use it leads to the incorrect packet
> classification.
> 
> This issue is causing broken connectivity in OpenStack deployments
> with OVS/OVN due to hairpin traffic being unexpectedly dropped.
> 
> [...]

Here is the summary with links:
  - [net] net: openvswitch: fix misuse of the cached connection on tuple changes
    https://git.kernel.org/netdev/net/c/2061ecfdf235

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


