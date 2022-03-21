Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054374E2506
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346668AbiCULLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346571AbiCULLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:11:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8F7393CC
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 04:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8BAD60AD3
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3858CC340F2;
        Mon, 21 Mar 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647861010;
        bh=8kJilW8Je+DcllpXcxQjXaYxldoXrQazFQXLHnnw9p0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BQOw5ahjjiEToj7qoGZirn77YyvYmLV236zbx74GjdmNBr7a6KI7yDW+GTBEKHezP
         mFgah/1xJjCUPnr/qjbZNamSoeuwqR933v8os0Mg37CpgdsU+/0M3QT4/vxWtagMHR
         032tdU3asMjsIThS+lPqU7CLdZk1Rg9B1HvKmKulvjoQX49Ufum51CdwoGdN6+GWer
         s8ZrMrfG+2m+cJEBepauW+zh6PRHruAXWPpQef7ABY8cxJ0vRHdINsrNWy99xWgSyn
         KYMOhcmSSgXCAm9SpcYHrUg13gKl9bjkErjx2qh34+ikgwMQozm+aOpsko4xVJXkI6
         7sc52WSdg1cxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CB00EAC081;
        Mon, 21 Mar 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sparx5: Use vid 1 when bridge default vid 0 to
 avoid collision
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164786101011.12168.9558918046953074788.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 11:10:10 +0000
References: <20220318125331.53mdxhtrrddsbvws@wse-c0155>
In-Reply-To: <20220318125331.53mdxhtrrddsbvws@wse-c0155>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Mar 2022 13:53:31 +0100 you wrote:
> Standalone ports use vid 0. Let the bridge use vid 1 when
> "vlan_default_pvid 0" is set to avoid collisions. Since no
> VLAN is created when default pvid is 0 this is set
> at "PORT_ATTR_SET" and handled in the Switchdev fdb handler.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: sparx5: Use vid 1 when bridge default vid 0 to avoid collision
    https://git.kernel.org/netdev/net-next/c/e6980b572fb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


