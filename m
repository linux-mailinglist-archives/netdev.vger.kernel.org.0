Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3014E2F04E8
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 04:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbhAJDat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 22:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbhAJDat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 22:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C9B622A99;
        Sun, 10 Jan 2021 03:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610249408;
        bh=3C7MHNz3pETE3F/EyTHofQk98d9pjJiQNYx17xWFBpk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pUJVxvKXmt60G4Igp7yF0e07xJn9talnM9trFXlsMAtCYFIfbe5OuV4SUhyfD5ueU
         qpV1tdq/sv85PPSLslDIGqN2ija9cLfALt8/mZQ/+ePPK2r8L+X1kVJuZLb2nROPYk
         LGQSA5qX0DUtYihkDdQ7isAc1F19TM3vOK5PfFAcxRkypPSOp2H/sIv4dLKI3wFoXZ
         vlpLQuc//TwhCuJ3Oxp4P4pIH6gcBLh3RWkFVZv14D3Epx7NQz14nNzkIVP9mVy1Wo
         m3Z+efT9wu2lk3hpk+nmIaTwA6AkivoL3kfJDvvxt8cY/FwaDdrA3eHul2A1EacS//
         zCZZVbLxeIH5g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 6D2B760387;
        Sun, 10 Jan 2021 03:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 1/3] dt-bindings: net: convert Broadcom
 Starfighter 2 binding to the json-schema
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161024940843.23531.2102406845233167916.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jan 2021 03:30:08 +0000
References: <20210106213202.17459-1-zajec5@gmail.com>
In-Reply-To: <20210106213202.17459-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  6 Jan 2021 22:32:00 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This helps validating DTS files. Only the current (not deprecated one)
> binding was converted.
> 
> Minor changes:
> 1. Dropped dsa/dsa.txt references
> 2. Updated node name to match dsa.yaml requirement
> 3. Fixed 2 typos in examples
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/3] dt-bindings: net: convert Broadcom Starfighter 2 binding to the json-schema
    https://git.kernel.org/netdev/net-next/c/c7ee3a40e76c
  - [V2,net-next,2/3] dt-bindings: net: dsa: sf2: add BCM4908 switch binding
    https://git.kernel.org/netdev/net-next/c/41bb4b087783
  - [V2,net-next,3/3] net: dsa: bcm_sf2: support BCM4908's integrated switch
    https://git.kernel.org/netdev/net-next/c/73b7a6047971

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


