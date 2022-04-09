Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76DD4FA212
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 05:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbiDIDms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 23:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbiDIDmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 23:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67ABEAC928;
        Fri,  8 Apr 2022 20:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0570FB82E45;
        Sat,  9 Apr 2022 03:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE6B4C385AF;
        Sat,  9 Apr 2022 03:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649475612;
        bh=7/3DSqLv3DrlPV8HSV1xwDdNBsRFdP7C28ZPt9gLqKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bk9fpzuIG+JTorzGy14qMyyLkWEhCyZDnJqhewXNYugYJBBIqoi69SLCaa/TWK5uo
         h0VHuDPyTOKeW5DBB1jKqO2lgtfjZNa+XooaldrdLNK8wmQZ2kXVYQZg93MvPWSrSk
         KH6OmSKsb9B2OfHKmDK57Cdwamzo0O2zYI4rpOMSEo1qZ7lyNAr+aonM5uxToVML0h
         nv92/TPetj2O05MBe+QqAea/YIBJ3dFnESKKDOZDXtyDCEltK4zLWG0Bj8Ewh9NoMT
         XHF+bNNvhS03YLeVkE17c/OJU3OW5hwxgtHmW6NUHiGrDDaA4s+erI2r7yM1dtEltH
         ujsVqDJz0uZpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8EFDE8DCCE;
        Sat,  9 Apr 2022 03:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/1] mscc-miim probe cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164947561268.6004.16808779070989074436.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Apr 2022 03:40:12 +0000
References: <20220407234445.114585-1-colin.foster@in-advantage.com>
In-Reply-To: <20220407234445.114585-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        vladimir.oltean@nxp.com, f.fainelli@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Apr 2022 16:44:44 -0700 you wrote:
> I'm submitting this patch independently from my ongoing patch set to
> include external control over Ocelot chips.
> 
> Initially the sole patch had reviewed-by tags from Vladimir Oltean and
> Florian Fainelli, but since I had to manually resolve some conflicts I
> removed the tags.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/1] net: mdio: mscc-miim: add local dev variable to cleanup probe function
    https://git.kernel.org/netdev/net-next/c/626a5aaa5067

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


