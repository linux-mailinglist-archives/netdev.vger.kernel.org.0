Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F9D4E6C30
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357674AbiCYBph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357578AbiCYBox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:44:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FA89D4FB;
        Thu, 24 Mar 2022 18:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2709B8273B;
        Fri, 25 Mar 2022 01:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CF88C340ED;
        Fri, 25 Mar 2022 01:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648172411;
        bh=1LEi+hjduhYbdGvnPdqTbms6toEqykEY8xqhZYQgWcA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u2ddPzNg87OGHLuYxojsnNXnZ0gmUujn3uq0jYD/bnA1JmXGWRs28vqfJZ6gL8fvi
         ziQJVn2uMTHbSaK8aY2k9e++4CxkDdX8K6HR6nzeOkQJYf1TO9qrhGN+nmD8/YeYSi
         L666ifg74Nt/BochnasbVHXWXrpVrxD/k88nFJKcNx8s/GKq2pD4vCf7FWzQij1S7C
         CRDBdbL6MSBAkROp/yd7YnpgDLKl1RLqAwgEYroQBMk9ZA9QZ6R6Gyqvaa0zfKDPC8
         IB9vsUgd600CavYdhGZDGtYvRElfJq2w9D2S6cXacqbU/W9RojTXT8EasxIe1fSlhV
         z9YRzljeYCz4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F1B5F03843;
        Fri, 25 Mar 2022 01:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: ax88179_178a: add Allied Telesis AT-UMCs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164817241151.12279.16145196404450564240.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Mar 2022 01:40:11 +0000
References: <20220323220024.GA36800@test-HP-EliteDesk-800-G1-SFF>
In-Reply-To: <20220323220024.GA36800@test-HP-EliteDesk-800-G1-SFF>
To:     Greg Jesionowski <jesionowskigreg@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, 23 Mar 2022 15:00:24 -0700 you wrote:
> Adds the driver_info and IDs for the AX88179 based Allied Telesis AT-UMC
> family of devices.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Greg Jesionowski <jesionowskigreg@gmail.com>
> ---
>  drivers/net/usb/ax88179_178a.c | 51 ++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)

Here is the summary with links:
  - net: usb: ax88179_178a: add Allied Telesis AT-UMCs
    https://git.kernel.org/netdev/net/c/9fe087dda5bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


