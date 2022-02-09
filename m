Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01DE4AF216
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiBIMuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbiBIMuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:50:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABACC05CBBB
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CFA761920
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC233C340EB;
        Wed,  9 Feb 2022 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644411008;
        bh=agUcKdODCdDCMpyjGyo58YEaw8ugNxjQeryuPCkAwv8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QGXQv4LmvaegMcxEu/urGIs+rTM3Tx7T/gSsPAgMALWo44UlaHGHqLdxUi4U4lHZt
         i1eQrfXJG+SXPh+UAkklwVDlG5j8p4rIR1UspBDo/E5aeUdauoLPLJLkPPPHyAddgW
         WS2tFiWzrDmAh9N901YT7BsiXfzzi5b6yyHIq2t6LgEiwNATy3NNYwWevwAW5Zou6v
         Y0IfehN9QjQHW1ya9M1Y1X0fnaPTX8cuEcpCMqHrLS2RjmR79UdbHcVa/KLRItYWed
         WymJm8U+cW8ikypTZhGP3LreDvmDR900Ui7vuBzwoKA7MyunrSt2x/bbx3LLDTycff
         zp9pDX1/W7naA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8E04E6D458;
        Wed,  9 Feb 2022 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net,
 v2] tipc: rate limit warning for received illegal binding update
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441100875.3630.7253473908279805257.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:50:08 +0000
References: <20220209032237.1161090-1-jmaloy@redhat.com>
In-Reply-To: <20220209032237.1161090-1-jmaloy@redhat.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Feb 2022 22:22:37 -0500 you wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> It would be easy to craft a message containing an illegal binding table
> update operation. This is handled correctly by the code, but the
> corresponding warning printout is not rate limited as is should be.
> We fix this now.
> 
> [...]

Here is the summary with links:
  - [net,v2] tipc: rate limit warning for received illegal binding update
    https://git.kernel.org/netdev/net/c/c7223d687758

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


