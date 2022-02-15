Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25CD4B6EE6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbiBOOae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:30:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238630AbiBOOa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:30:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343ADEEA71;
        Tue, 15 Feb 2022 06:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1EB1CE2007;
        Tue, 15 Feb 2022 14:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42072C340F2;
        Tue, 15 Feb 2022 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644935410;
        bh=v+SPf+a3vwnc8GB4cem/OWq9z+vis9gvUbMbiWiq7B0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V00Sz8IQIvzW5oNSfMGKGtVzU7RImqIwyz81hmmRO2FSjzaIIH3FthMAHZS883iUY
         GyWMC3x5Aenc98dfuKYK+Kshqp//70vTkhBfGuesZYMSdBuHhujODTx7wB5UxE2I6E
         tO3tUX15MbTvh1aHONgmwjaftoM6Ht8+XRimbItWxpndYH0et/7iJRFcGxypuoBTEx
         Uo9hx/cpG9441fxSZCsHBctm+bDZXh10pPum2kERE84LGppPcAZiK8SmRnxVsfiYRY
         ao9L4qU+1jxoKIOCn7n9H6JvF23NfXkLy2jMARI55iDU4ZqgASlM0ETNujq1MwrVPG
         ZM6HpRy0NLSLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AEEBE6D447;
        Tue, 15 Feb 2022 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2022-02-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493541017.26708.4040304563113097967.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:30:10 +0000
References: <20220215093214.3709686-1-stefan@datenfreihafen.org>
In-Reply-To: <20220215093214.3709686-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Feb 2022 10:32:14 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net* tree.
> 
> Only a single fix this time.
> Miquel Raynal fixed the lifs/sifs periods in the ca82010 to take the actual
> symbol duration time into account.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2022-02-15
    https://git.kernel.org/netdev/net/c/b465c0dc83be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


