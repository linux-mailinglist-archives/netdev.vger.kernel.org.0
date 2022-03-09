Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24414D28EC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiCIGVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiCIGVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:21:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9EBDEF9;
        Tue,  8 Mar 2022 22:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88A6D61931;
        Wed,  9 Mar 2022 06:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE45FC340EF;
        Wed,  9 Mar 2022 06:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646806809;
        bh=NhRWfcFvPi1Kumwtwa/A4ApGMbS/NIoS2EE+TZmmG1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d+w7F0pVyIvaWdmASD7R/y1/ejy+w8kp69W0as0mTPc/6nX9TjXEg2LDGwOTHimPR
         Eqp6iN0VHtssuvKh9MjZrP/PIdf5AuCGwGdY1L/sAC0vUVsgWXyXprrPnPjQZDAyRd
         GNZutf4//mLUWS8aSw2G2Fj7KDX1EdV+AHndJlREnwS/i6nJpb3ZGx0aZwc8GJ9H3u
         AsxQ51OTYL6gX0SJjDSpHcN4dV+STWIG4zSKMMuRL/UtKx3J9KiNlM8n00OHmpenf2
         jiWOAk2gi1tFDq1MneQTqU6a91ePTUSefUA+U9sq/yXAGYRgsfYR4eD8jikNTyYyFZ
         919eUCTkJB80g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C04ADE73C2D;
        Wed,  9 Mar 2022 06:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: Fix error handling in xemaclite_of_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164680680978.10719.6940364945225498751.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 06:20:09 +0000
References: <20220308024751.2320-1-linmq006@gmail.com>
In-Reply-To: <20220308024751.2320-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        arnd@arndb.de, andrew@lunn.ch, michael@walle.cc,
        prabhakar.mahadev-lad.rj@bp.renesas.com, yuehaibing@huawei.com,
        john.linn@xilinx.com, grant.likely@secretlab.ca,
        Sadanand.Mutyala@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Mar 2022 02:47:49 +0000 you wrote:
> This node pointer is returned by of_parse_phandle() with refcount
> incremented in this function. Calling of_node_put() to avoid the
> refcount leak. As the remove function do.
> 
> Fixes: 5cdaaa12866e ("net: emaclite: adding MDIO and phy lib support")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - ethernet: Fix error handling in xemaclite_of_probe
    https://git.kernel.org/netdev/net/c/b19ab4b38b06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


