Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880413D7EC7
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhG0UAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhG0UAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 16:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ED0CF60FA0;
        Tue, 27 Jul 2021 20:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627416014;
        bh=7gbluUXqRRDrRRn0YT85HoIea0afHl4fXkBq3wS8myc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZuKh0QZIr0bo4IkkVxJ+KGIS7CN6C3qN0vMjFXehfb5lPWADe0PwPwsnk1qMM5vvO
         HlWCTVM4ZzSaJEPtmoNUa1vsliz463WcrdCQN1lkHHswUKgaNNtq29styVqu3BjN7r
         JYjOpWXSrkVvfQxj9Ek6rU+aJOXdBkncGx3bb9Y1mzLSX2u2tkkakG1hfNRYcUUq4e
         inTy+HHa8/MPQbmrfH3/IPLKgDL9lIMIjHc7+pUM2DHjS9wtjN7iT01LHakbA2lpny
         sQF0HUZcKsDMvVwqgSaSNCqv1JR5iOvrYNY91Aq7W+oxmNXRaUF211VLnU6VOI+NyL
         UUZx8tXVJZbzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E1C38609CC;
        Tue, 27 Jul 2021 20:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/31] ndo_ioctl rework
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162741601391.17427.11630081272562695042.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 20:00:13 +0000
References: <20210727134517.1384504-1-arnd@kernel.org>
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, arnd@arndb.de,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        rajur@chelsio.com, t.sailer@alumni.ethz.ch, jreuter@yaina.de,
        jpr@f6fbb.org, jes@trained-monkey.org, khc@pm.waw.pl,
        kevin.curtis@farsite.co.uk, qiang.zhao@nxp.com, ms@dev.tdt.de,
        kvalo@codeaurora.org, j@w1.fi, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, courmisch@gmail.com, andrew@lunn.ch,
        hch@lst.de, linux-parisc@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-ppp@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-x25@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Jul 2021 15:44:46 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This series is a follow-up to the series for removing
> compat_alloc_user_space() and copy_in_user() that has now
> been merged.
> 
> I wanted to be sure I address all the ways that 'struct ifreq' is used
> in device drivers through .ndo_do_ioctl, originally to prove that
> my approach of changing the struct definition was correct, but then
> I discarded that approach and went on anyway.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/31] net: split out SIOCDEVPRIVATE handling from dev_ioctl
    https://git.kernel.org/netdev/net-next/c/b9067f5dc4a0
  - [net-next,v3,02/31] staging: rtlwifi: use siocdevprivate
    https://git.kernel.org/netdev/net-next/c/89939e890605
  - [net-next,v3,03/31] staging: wlan-ng: use siocdevprivate
    https://git.kernel.org/netdev/net-next/c/3343c49a959d
  - [net-next,v3,04/31] hostap: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/3f3fa5340745
  - [net-next,v3,05/31] bridge: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/561d8352818f
  - [net-next,v3,06/31] phonet: use siocdevprivate
    https://git.kernel.org/netdev/net-next/c/4747c1a8bc50
  - [net-next,v3,07/31] tulip: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/029a4fef6b22
  - [net-next,v3,08/31] bonding: use siocdevprivate
    https://git.kernel.org/netdev/net-next/c/232ec98ec35d
  - [net-next,v3,09/31] appletalk: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/dbecb011eb78
  - [net-next,v3,10/31] hamachi: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/99b78a37a371
  - [net-next,v3,11/31] tehuti: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/32d05468c462
  - [net-next,v3,12/31] eql: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/d92f7b59d32b
  - [net-next,v3,13/31] fddi: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/043393d8b478
  - [net-next,v3,14/31] net: usb: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/ef1b5b0c30bc
  - [net-next,v3,15/31] slip/plip: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/76b5878cffab
  - [net-next,v3,16/31] qeth: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/18787eeebd71
  - [net-next,v3,17/31] cxgb3: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/ebb4a911e09a
  - [net-next,v3,18/31] hamradio: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/25ec92fbdd23
  - [net-next,v3,19/31] airo: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/ae6af0120dda
  - [net-next,v3,20/31] ip_tunnel: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/3e7a1c7c561e
  - [net-next,v3,21/31] hippi: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/81a68110a22a
  - [net-next,v3,22/31] sb1000: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/cc0aa831a0d9
  - [net-next,v3,23/31] ppp: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/34f7cac07c4e
  - [net-next,v3,24/31] wan: use ndo_siocdevprivate
    https://git.kernel.org/netdev/net-next/c/73d74f61a559
  - [net-next,v3,25/31] wan: cosa: remove dead cosa_net_ioctl() function
    https://git.kernel.org/netdev/net-next/c/8fb75b79cd98
  - [net-next,v3,26/31] dev_ioctl: pass SIOCDEVPRIVATE data separately
    https://git.kernel.org/netdev/net-next/c/a554bf96b49d
  - [net-next,v3,27/31] dev_ioctl: split out ndo_eth_ioctl
    https://git.kernel.org/netdev/net-next/c/a76053707dbf
  - [net-next,v3,28/31] net: split out ndo_siowandev ioctl
    https://git.kernel.org/netdev/net-next/c/ad7eab2ab014
  - [net-next,v3,29/31] net: socket: return changed ifreq from SIOCDEVPRIVATE
    https://git.kernel.org/netdev/net-next/c/88fc023f7de2
  - [net-next,v3,30/31] net: bridge: move bridge ioctls out of .ndo_do_ioctl
    https://git.kernel.org/netdev/net-next/c/ad2f99aedf8f
  - [net-next,v3,31/31] net: bonding: move ioctl handling to private ndo operation
    https://git.kernel.org/netdev/net-next/c/3d9d00bd1885

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


