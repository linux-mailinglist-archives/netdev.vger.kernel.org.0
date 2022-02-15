Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62DF4B73A4
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbiBOPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:00:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239385AbiBOPAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9D06C947;
        Tue, 15 Feb 2022 07:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B046161521;
        Tue, 15 Feb 2022 15:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D374C340F1;
        Tue, 15 Feb 2022 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644937211;
        bh=G88olntChB3S8bFzM9P3swMi/WCvEb5gb4eSGyTeYO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NLaG9GSwkVzusfVRrcdB3UoRgTmWrlqsf4LyKVcAcNtNelHct9l8OTM7DXCUCFRgB
         8y7IFfEsVFp/YvRMMBSZ8OpCitem+TSLwPUyczzGUyjD3xyF60X0odeEH6gv/NNcCO
         ErVNHv5/ftKyN+cjSIWKNH2Ui10i5WdlRTgfrNKhIhFEH+hvPNG/D01RFb/+b+MzaA
         z9XUHmDb15cf4gbMvBjWRV1zbBf2MaGbjkYVW2kwWya8bLrUekrOdQxqPh07NBH8Y/
         3Nw4YYm6JxliY4t3/rcaPgWnuVYLjZnAFcAwa/2p8v4/ddXj23R4J+qw9bTZmt+qvL
         QkcDj77jnTQ6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04D29E6D458;
        Tue, 15 Feb 2022 15:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] CDC-NCM: avoid overflow in sanity checking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493721101.12867.17864293347718933449.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 15:00:11 +0000
References: <20220215103547.29599-1-oneukum@suse.com>
In-Reply-To: <20220215103547.29599-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gregKH@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 15 Feb 2022 11:35:47 +0100 you wrote:
> A broken device may give an extreme offset like 0xFFF0
> and a reasonable length for a fragment. In the sanity
> check as formulated now, this will create an integer
> overflow, defeating the sanity check. Both offset
> and offset + len need to be checked in such a manner
> that no overflow can occur.
> And those quantities should be unsigned.
> 
> [...]

Here is the summary with links:
  - CDC-NCM: avoid overflow in sanity checking
    https://git.kernel.org/netdev/net/c/8d2b1a1ec9f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


