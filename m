Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0525B3D1E19
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 08:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhGVFjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 01:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhGVFj3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 01:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1CD8D61264;
        Thu, 22 Jul 2021 06:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626934805;
        bh=6mx66zkzalEGLfRyEozsVKFILkze1aC0+UW1Gn88jXs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rjBPOTcu0kHj6zdMDDKoXGNqk8+jL0m8xbK+b6EJh1248O7Zan2vYMo/jlmz8LHlf
         pdzH7+T1TSyM5qrru9sWeNpHik7Vy5WHzVVmKMB5e5NDnO1EUc6Vj/dxpdW6k/kWH1
         knb/X0M2QU1P5PqFzNKIZZCl88eF2NV/87hDp2cj9Gh3YjNMLV1VFfm7El5ytfvjV4
         vd4DWUBMIEcPI3dELz5nU/e9TNHONCs+93qoCYtucPESNFeJVOWgM3ubXtb4y9aKRD
         AZUsIJHh30ZOYaOvGe/OAD/jv67Uig995YDvN8T1/NkWLPrjvuWA9i5R6bMbZk+xfX
         WBzm/+jGZhDtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1082B609AC;
        Thu, 22 Jul 2021 06:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] Fixes for KSZ DSA switch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162693480506.4679.7749029967895424392.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 06:20:05 +0000
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
In-Reply-To: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
To:     Lino Sanfilippo <linosanfilippo@gmx.de>
Cc:     woojung.huh@microchip.com, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, LinoSanfilippo@gmx.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Jul 2021 23:56:40 +0200 you wrote:
> These patches fix issues I encountered while using a KSZ9897 as a DSA
> switch with a broadcom GENET network device as the DSA master device.
> 
> PATCH 1 fixes an invalid access to an SKB in case it is scattered.
> PATCH 2 fixes incorrect hardware checksum calculation caused by the DSA
> tag.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: dsa: ensure linearized SKBs in case of tail taggers
    https://git.kernel.org/netdev/net/c/21cf377a9c40
  - [v2,2/2] net: dsa: tag_ksz: dont let the hardware process the layer 4 checksum
    https://git.kernel.org/netdev/net/c/37120f23ac89

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


