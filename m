Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43825532A61
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbiEXMa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237341AbiEXMa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C66941A0;
        Tue, 24 May 2022 05:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B60161582;
        Tue, 24 May 2022 12:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BA6EC34116;
        Tue, 24 May 2022 12:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653395454;
        bh=P+eoMO2UsS3962kAnFR+mi9kku9UDPwPYOVZ/mzhIKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b4VyluahGQY5NRqrxVMqFkhuqF7XUtWE60aEsJf87oIToNUeyusfCACKFOfKbJ0RZ
         FB60oonQ8UX+RRQkJyP1tVJ1aspMuB0LRKuvbG0CoQsKjIVfRo5YN077/J16FwQmn1
         eyuWUYOynskudJlb1gCBH2glXGKk3YobPryzAHGAofsVdvQk6GjF1Vq4jg2/NF9Kw0
         /sa38jERSWO3jh1KxPMZ8IJ3kgqVGStVt+0qtasgPcr2ORVci6AXmHJMYC8/JO8+v/
         Xttk7wkqinlULuIy0/HfaNlE87oHiZLmW2tX+NsQcJM/4ww/4YpxcWdi3pGc/XxcA1
         BuE/cw3gS3stg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B0D7F03942;
        Tue, 24 May 2022 12:30:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-05-23
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165339545450.7336.5284014033990163255.git-patchwork-notify@kernel.org>
Date:   Tue, 24 May 2022 12:30:54 +0000
References: <20220523200349.3322806-1-luiz.dentz@gmail.com>
In-Reply-To: <20220523200349.3322806-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 May 2022 13:03:49 -0700 you wrote:
> The following changes since commit 8c3b8dc5cc9bf6d273ebe18b16e2d6882bcfb36d:
> 
>   net/smc: fix listen processing for SMC-Rv2 (2022-05-23 10:08:33 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-05-23
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-05-23
    https://git.kernel.org/bluetooth/bluetooth-next/c/7fb0269720d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


