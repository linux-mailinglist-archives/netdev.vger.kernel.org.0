Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D839334CB2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhCJXkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhCJXkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9058B64FC3;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615419611;
        bh=q+aCw48oNWbFN9Y8roaOoc9QHE064WSJdrT1+65QYVA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=epcpmDdij/OLDFE8LkCLfTLJ7Ko+FJsTNzOXYlrbgbm2oWv02RIZQR2HiXixJNH1L
         apFrLefR0P52yPHwYBE/IoXdfn4Iq+IsQxF0hBTC1UYPyLIZ5dItXlu8RbjgCK1zR4
         0cjI2b89FA4MExGq2v4JlBJ6jj3Ks4OFX4nRCRKo1m76MbZbqbGHHem5Uou6TGcOak
         VcnwCrwFhMsZ3ypSBN0NadJm3cPMrJtkM4UpfvPc7SoMpsQM8RM40SrE+GNY5JNGHA
         aMeLnBLUojtqc/E6hq5X6eyo6n623u5yQrhHCqeoDZcDxp9o9OnGVXAr/UyWGYaP+L
         Rwv2yohkyJIMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F8EE609B8;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: bcm_sf2: use 2 Gbps IMP port link on BCM4908
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541961151.10035.15785257181859046216.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 23:40:11 +0000
References: <20210310125159.28533-1-zajec5@gmail.com>
In-Reply-To: <20210310125159.28533-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 13:51:59 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> BCM4908 uses 2 Gbps link between switch and the Ethernet interface.
> Without this BCM4908 devices were able to achieve only 2 x ~895 Mb/s.
> This allows handling e.g. NAT traffic with 940 Mb/s.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> [...]

Here is the summary with links:
  - net: dsa: bcm_sf2: use 2 Gbps IMP port link on BCM4908
    https://git.kernel.org/netdev/net/c/8373a0fe9c71

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


