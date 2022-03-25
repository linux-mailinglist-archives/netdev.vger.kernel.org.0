Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1BD4E7D17
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiCYWvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 18:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiCYWvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 18:51:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472C819F22D
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 15:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D683E616EF
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 22:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37F03C340ED;
        Fri, 25 Mar 2022 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648248611;
        bh=QBYidZB5aHWTQz8G+BdBfxWwo74N5+B//h1ZCW6S58s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uXSfPx+bE8OFLJaCsf23VsH8tvc6XyEsF4FZkYMwqeqhsYmap9y6bcp46VNRirOSg
         BWqWXQ9Rm04CnCvjyQnbrWPKxqkEoIeGGrZwcNPnzUR50ak0I3uFMsf2Xmm7WdIREO
         dsUZoxS68328hZswKUDIKVJlLVB88tfzkNSQ3zklJ0GbH4vmeCNkaYs6Ciovi2W9W0
         B2vWrYy2v+Ja2zmUGNx5PTkD8OyNOUbm2VDNAh9MJb0va6QFUcnw5dWWx8FzgxSpSg
         r++Ys/YsYNuADLdhqyRQ4rOt0z2G9Q86O8/osbcfWPiexbok+fMdZf4IzgGDKp2Dqm
         bFV3cD4FK5vSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B625F03843;
        Fri, 25 Mar 2022 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: report software timestamping via
 SO_TIMESTAMPING
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164824861110.30104.1137041407077383035.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Mar 2022 22:50:11 +0000
References: <20220324161210.4122281-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220324161210.4122281-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, claudiu.manoil@nxp.com, michael@walle.cc,
        richardcochran@gmail.com
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

On Thu, 24 Mar 2022 18:12:10 +0200 you wrote:
> Let user space properly determine that the enetc driver provides
> software timestamps.
> 
> Fixes: 4caefbce06d1 ("enetc: add software timestamping")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: enetc: report software timestamping via SO_TIMESTAMPING
    https://git.kernel.org/netdev/net/c/feb13dcb1818

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


