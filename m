Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313213CBDCE
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 22:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhGPUdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 16:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230256AbhGPUdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 16:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 416B361403;
        Fri, 16 Jul 2021 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626467405;
        bh=MK1GsLhBEn/hgBoEV8Uu8Jfe2B9Z1OPb/MqUNRkaqSM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dg6Cv44+3LqYKWca5gpAAAIW2ln1trb8H2JUoRZVaDbR2d5dNUdH+2IRUXsXE8qZD
         qb++vF+y1EZ/8bUiBDfsD1OHEv7+FUr/hU3vEkq4v10LNoOXxXnFsZJYvGrdtF4Npp
         yonQJDn5bx8JIDxoXX0AxH3YLR1lbfttJEjQNrtcmuCpFcAl0g2pN/0F/EBNZzh88+
         frjoSUspKzHzo1lnJDjzM9tAa0QfLBYmlA4jryrEF8BHj5Sq1wAlSwePA9i7N/PbiV
         YOiZrLh0PbJATqqJ5kEYZk6Q6BbV9I2Td2HMT0xqK3EeqVs8477ep0tH98q1wtUpL1
         mXnDVHCziWjAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37EAA60A4E;
        Fri, 16 Jul 2021 20:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next,resend,V3] net: phy: marvell10g: enable WoL for 88X3310 and
 88E2110
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162646740522.5067.15786137740552625337.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 20:30:05 +0000
References: <20210716134645.2249943-1-pei.lee.ling@intel.com>
In-Reply-To: <20210716134645.2249943-1-pei.lee.ling@intel.com>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        weifeng.voon@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Jul 2021 21:46:45 +0800 you wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> Implement Wake-on-LAN feature for 88X3310 and 88E2110.
> 
> This is done by enabling WoL interrupt and WoL detection and
> configuring MAC address into WoL magic packet registers
> 
> [...]

Here is the summary with links:
  - [net-next,resend,V3] net: phy: marvell10g: enable WoL for 88X3310 and 88E2110
    https://git.kernel.org/netdev/net-next/c/08041a9af98c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


