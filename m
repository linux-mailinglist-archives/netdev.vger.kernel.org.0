Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3EF437BC3
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbhJVRW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231893AbhJVRW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:22:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1270F60FBF;
        Fri, 22 Oct 2021 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634923210;
        bh=5WrfZBH4dudcmt09PoRMo9VUuGBiPBVwLQHiEXWX24Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J1U4DBlrRUIxxMD0II/uhfFpTYvPLRZr8J8W1IpoKYmGTUE8p4gKEGJMgme/EgxtO
         5UL2K7p4kIE8wWceFs2lC/A7jnraaP8PKy97058GAK/Ojcx0TQn5t2exdHfsKGU19T
         Veh8Cxb1LvWzjWEOuR9p0n1xJQGPSf2coNC5Jm+FJue1Kxfcrq1Ve0n57uFJpKfVDT
         mZFJHW4QfbpQEgYZmhMfI/WQIZPe8HnpEvWkWrBObhWzgSbwyNG0BDhQLY7OfwSlcJ
         uVTAdT1DYYEbAzB5E3yiSt2Car+O5gqE4OT3rsK6nNVwEZ4W8W0Qwo+mLan8a/98mN
         QwwQ7iZKr78TQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 06CCD60A2A;
        Fri, 22 Oct 2021 17:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/12] net: don't write directly to
 netdev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163492321002.27565.17266900633363672746.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 17:20:10 +0000
References: <20211021131214.2032925-1-kuba@kernel.org>
In-Reply-To: <20211021131214.2032925-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Oct 2021 06:12:02 -0700 you wrote:
> More conversions, mostly in usb/net.
> 
> v2: leave out catc (patch 4)
> 
> Jakub Kicinski (12):
>   net: xen: use eth_hw_addr_set()
>   usb: smsc: use eth_hw_addr_set()
>   net: qmi_wwan: use dev_addr_mod()
>   net: usb: don't write directly to netdev->dev_addr
>   fddi: defxx,defza: use dev_addr_set()
>   fddi: skfp: constify and use dev_addr_set()
>   net: fjes: constify and use eth_hw_addr_set()
>   net: hippi: use dev_addr_set()
>   net: s390: constify and use eth_hw_addr_set()
>   net: plip: use eth_hw_addr_set()
>   net: sb1000,rionet: use eth_hw_addr_set()
>   net: hldc_fr: use dev_addr_set()
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/12] net: xen: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/93772114413e
  - [net-next,v2,02/12] usb: smsc: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/a7021af707a3
  - [net-next,v2,03/12] net: qmi_wwan: use dev_addr_mod()
    https://git.kernel.org/netdev/net-next/c/18867486fea3
  - [net-next,v2,04/12] net: usb: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/2674e7ea22ba
  - [net-next,v2,05/12] fddi: defxx,defza: use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/1e9258c389ee
  - [net-next,v2,06/12] fddi: skfp: constify and use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/2e0566aeb9ff
  - [net-next,v2,07/12] net: fjes: constify and use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/ed088907563d
  - [net-next,v2,08/12] net: hippi: use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/5ed5b1912a81
  - [net-next,v2,09/12] net: s390: constify and use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/978bb0ae8b83
  - [net-next,v2,10/12] net: plip: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/7996acffd7cc
  - [net-next,v2,11/12] net: sb1000,rionet: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/5f07da89bcd0
  - [net-next,v2,12/12] net: hldc_fr: use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/65a4fbbf2263

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


