Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61BE6B8606
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCMXUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjCMXUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D7823110
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91FDC61542
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02A22C433EF;
        Mon, 13 Mar 2023 23:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678749618;
        bh=TSq439GvEtFmmDB8WUFrcNZCJBFXmJxdBntg5jCtBOs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h/f+oROdhF3YfQSR+ZN0HPKYc6rGyMZWyLAYiN2zmdzG4MrThMkruEniaJqQ2wVlP
         If1lcugxzwZPlnTPeyHq8QCla8HmSXPD1hpr/Luv81G2c2TPdUxUs7St2F38HsRUy3
         laiLri14qnS0R3TNXdJQsh2Cr464Rghext6m8f4fkME34+VjRMWBAagJn0kcjCiqkr
         a3neJDz8l/hxIKtDE2SSaSI3H8N4NZs7GgMQgXbSnGrZWcTfqjHq32tIqigLoqhw8F
         glIl+QIIxgZfQNZDr025HuC2CvKqRsYSdkZYCGlYdL9BKJI1TImi4PS7O1NcXmHxy5
         zUy4I/vRCZNKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D93B8C43161;
        Mon, 13 Mar 2023 23:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: hsr: Don't log netdev_err message on unknown prp dst
 node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167874961788.24202.18430297135894238843.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 23:20:17 +0000
References: <20230309092302.179586-1-koverskeid@gmail.com>
In-Reply-To: <20230309092302.179586-1-koverskeid@gmail.com>
To:     Kristian Overskeid <koverskeid@gmail.com>
Cc:     netdev@vger.kernel.org, m-karicheri2@ti.com, bigeasy@linutronix.de,
        yuehaibing@huawei.com, arvid.brodin@alten.se
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Mar 2023 10:23:02 +0100 you wrote:
> If no frames has been exchanged with a node for HSR_NODE_FORGET_TIME, the
> node will be deleted from the node_db list. If a frame is sent to the node
> after it is deleted, a netdev_err message for each slave interface is
> produced. This should not happen with dan nodes because of supervision
> frames, but can happen often with san nodes, which clutters the kernel
> log. Since the hsr protocol does not support sans, this is only relevant
> for the prp protocol.
> 
> [...]

Here is the summary with links:
  - [v2] net: hsr: Don't log netdev_err message on unknown prp dst node
    https://git.kernel.org/netdev/net-next/c/4821c186b9c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


