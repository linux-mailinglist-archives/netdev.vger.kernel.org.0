Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886F1481C82
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbhL3Na2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239561AbhL3NaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEC1C06173E;
        Thu, 30 Dec 2021 05:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40F32B81C50;
        Thu, 30 Dec 2021 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05403C36AF0;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871013;
        bh=/AegKOx3X/KefJOLb1Q2Y0xCtfSmLKeTx54o9vm6Smk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FQxzILK+DX/OcAPh1TC0PQopERDWUkW2JwueTyAtRJdaopJ002K1LkHO2HxnWtjVb
         qCXsaxfPhBzEDfAtQlumUR53qK9VMB6L3Y0zCECOh3lZLQrLrUS3EzMcAlYAkKZGnw
         Tud6uh83vg3x8vnoPXOqtCDNnS0b+wHiMYsTXWgg8Ja14YaiA2+sp5Ft8/gghIpaV/
         wmdNALfjfow0oCYQS3rONw8slmF2p++hvpqclnxmfumzSnzXn3M8UIghLEr2DMb0P0
         Lel6prueuVY0LFSOOC9TwXgF9JxxVHRewS3mua/lD4N99KlZarnZvoMzijgqsbSI+p
         UGn3YdRY9TKEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E20A3C395EA;
        Thu, 30 Dec 2021 13:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux] ethtool: Remove redundant ret assignments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087101292.9335.11468907409311500847.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:12 +0000
References: <20211230062644.586079-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211230062644.586079-1-luo.penghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo.penghao@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 06:26:44 +0000 you wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> The assignment here will be overwritten, so it should be deleted
> 
> The clang_analyzer complains as follows:
> 
> net/ethtool/netlink.c:
> 
> [...]

Here is the summary with links:
  - [linux] ethtool: Remove redundant ret assignments
    https://git.kernel.org/netdev/net-next/c/c09f103e89f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


