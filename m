Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F97685ED3
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjBAFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjBAFUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A0515CBC;
        Tue, 31 Jan 2023 21:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D486A610E8;
        Wed,  1 Feb 2023 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 368A2C4339C;
        Wed,  1 Feb 2023 05:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228818;
        bh=RO8gSOx+buFwNV89ZvnYjkFyjMrH67Sd7nfK8wIEvkU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ih9zS7Jp2dBUUWFKpmFOKDHGe1fI9Ju/rMM4PBgM/SEEoPJyYRWtoDpevpmCImMny
         txpHY2qXi/f6r2rL0ZS+zbDf0ZV718ARpJ5+FlQG7ZmIE3Q1l4vRx13Lo3647P45Xh
         63OvAmXAEWy1lZaj2VsXYl7VD5D08+kq1TC2sQ63zfwAb/b2oyvLiUbPiFxKat4adE
         oKzAJgD2LOvvGc4ExJ0ADpdjpmeXXZ5BLTRfn/HL7QelexzN8JBzutMY1R/U760CKl
         IujTQPIVut2tdfCPvbQRFYokEzcLp8zEp4NWgzmU5yEr9/DAUYQVtMiXfOR5lDxuU/
         IkILMqBqtStEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 131AEE21EEC;
        Wed,  1 Feb 2023 05:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fix NULL pointer in skb_segment_list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522881807.32169.6049993626968458851.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:20:18 +0000
References: <Y9gt5EUizK1UImEP@debian>
In-Reply-To: <Y9gt5EUizK1UImEP@debian>
To:     Yan Zhai <yan@cloudflare.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, asml.silence@gmail.com,
        imagedong@tencent.com, keescook@chromium.org, jbenc@redhat.com,
        richardbgobert@gmail.com, willemb@google.com,
        steffen.klassert@secunet.com, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 30 Jan 2023 12:51:48 -0800 you wrote:
> Commit 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
> introduced UDP listifyed GRO. The segmentation relies on frag_list being
> untouched when passing through the network stack. This assumption can be
> broken sometimes, where frag_list itself gets pulled into linear area,
> leaving frag_list being NULL. When this happens it can trigger
> following NULL pointer dereference, and panic the kernel. Reverse the
> test condition should fix it.
> 
> [...]

Here is the summary with links:
  - net: fix NULL pointer in skb_segment_list
    https://git.kernel.org/netdev/net/c/876e8ca83667

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


