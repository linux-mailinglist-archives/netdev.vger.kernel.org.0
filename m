Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C35536E47
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiE1T5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 15:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiE1T53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 15:57:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7254474B;
        Sat, 28 May 2022 12:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3495660C84;
        Sat, 28 May 2022 19:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CD4EC34117;
        Sat, 28 May 2022 19:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653766211;
        bh=LE5Pmj9FFmU1ckt7mZgAQoT947XRJVaEXYAznCha/NQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uzafZ4lhX1hDFn0JtQMswHl+cX/lxJlJzABcR23Qil2E26AZS7avImz8NsB02feu/
         uz6aTpig9NpCThihMUtrVPGlSfXCFcGOw0SBQGTrblfeqJnTTUxY9Iqn1HSIMK4a27
         fFC2enrm1NTCXyCs1N5ClaN2T1IFwzsgGns8kAb0iYJsSt1kN5Kg0O7ZojvwEhRI4h
         9NcmN0Oyh7ISvUZK4Pw6nUJVfk28yexA1rQPeNF2JFi8WmwHrbEAEETYf/I7E+uU3o
         pG/nuNs5NM4/URJYsomKOnEuqDpwJ7G/rUOLfJxjb5TkD20DrbKk196BcNQAPSZiB2
         f6dRou4Ym/Dyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 717FDF03944;
        Sat, 28 May 2022 19:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: enetc: Use pci_release_region() to release some
 resources
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165376621146.15448.670456967245992093.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 19:30:11 +0000
References: <b0dcb6124717d13900e48b2f1fa697b922f672b2.1653643529.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b0dcb6124717d13900e48b2f1fa697b922f672b2.1653643529.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 27 May 2022 11:25:47 +0200 you wrote:
> Some resources are allocated using pci_request_region().
> It is more straightforward to release them with pci_release_region().
> 
> Fixes: 231ece36f50d ("enetc: Add mdio bus driver for the PCIe MDIO endpoint")
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: enetc: Use pci_release_region() to release some resources
    https://git.kernel.org/netdev/net/c/18eeb4dea65c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


