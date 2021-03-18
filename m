Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE643410A8
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCRXKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhCRXKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 19:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4808764E42;
        Thu, 18 Mar 2021 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616109016;
        bh=i6xujkvjhfwrktEDNVjD8yjuJ9fSxP9GZdiT4eLMUmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mZuGhsFosy63lXQkNoiTDYRzVOqksS7w0zGnAO1JpeWrg/xnOqQQWM65C58xSzryK
         ooimq0Zh/3A7f8s7vyBBwQS0rMgINn4ZOmOcnG2pgqE8iZmM2tGenWcvQpPbT04QHi
         +mMEddub6kzwwaXLG9dXDq475wLsy+xmouAQCTRqxDDkMSjS5/Kn4XWasyD+3HUlh8
         H//eyhWDy/jtBGDBhttr+XV+GhZDVxCd4F7Kr9yFI617xIFHHctbKXcAxhcwzgCfwK
         GuqemNKPaJuHOcvOPVvTNUHp7Mvs/oJDsi7csEt1vMXGb9Czwqma5IjvOVlcuei9RD
         wq9oDIKQygDMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4405C60191;
        Thu, 18 Mar 2021 23:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/13] net: xps: improve the xps maps handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610901627.20140.6302515468377836877.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 23:10:16 +0000
References: <20210318183752.2612563-1-atenart@kernel.org>
In-Reply-To: <20210318183752.2612563-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 19:37:39 +0100 you wrote:
> Hello,
> 
> This series aims at fixing various issues with the xps code, including
> out-of-bound accesses and use-after-free. While doing so we try to
> improve the xps code maintainability and readability.
> 
> The main change is moving dev->num_tc and dev->nr_ids in the xps maps, to
> avoid out-of-bound accesses as those two fields can be updated after the
> maps have been allocated. This allows further reworks, to improve the
> xps code readability and allow to stop taking the rtnl lock when
> reading the maps in sysfs. The maps are moved to an array in net_device,
> which simplifies the code a lot.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/13] net-sysfs: convert xps_cpus_show to bitmap_zalloc
    https://git.kernel.org/netdev/net-next/c/ea4fe7e842f6
  - [net-next,v4,02/13] net-sysfs: store the return of get_netdev_queue_index in an unsigned int
    https://git.kernel.org/netdev/net-next/c/d9a063d207f0
  - [net-next,v4,03/13] net-sysfs: make xps_cpus_show and xps_rxqs_show consistent
    https://git.kernel.org/netdev/net-next/c/73f5e52b15e3
  - [net-next,v4,04/13] net: embed num_tc in the xps maps
    https://git.kernel.org/netdev/net-next/c/255c04a87f43
  - [net-next,v4,05/13] net: embed nr_ids in the xps maps
    https://git.kernel.org/netdev/net-next/c/5478fcd0f483
  - [net-next,v4,06/13] net: remove the xps possible_mask
    https://git.kernel.org/netdev/net-next/c/6f36158e0584
  - [net-next,v4,07/13] net: move the xps maps to an array
    https://git.kernel.org/netdev/net-next/c/044ab86d431b
  - [net-next,v4,08/13] net: add an helper to copy xps maps to the new dev_maps
    https://git.kernel.org/netdev/net-next/c/402fbb992e13
  - [net-next,v4,09/13] net: improve queue removal readability in __netif_set_xps_queue
    https://git.kernel.org/netdev/net-next/c/132f743b01b8
  - [net-next,v4,10/13] net-sysfs: move the rtnl unlock up in the xps show helpers
    https://git.kernel.org/netdev/net-next/c/d7be87a687cc
  - [net-next,v4,11/13] net-sysfs: move the xps cpus/rxqs retrieval in a common function
    https://git.kernel.org/netdev/net-next/c/2db6cdaebac8
  - [net-next,v4,12/13] net: fix use after free in xps
    https://git.kernel.org/netdev/net-next/c/2d05bf015308
  - [net-next,v4,13/13] net: NULL the old xps map entries when freeing them
    https://git.kernel.org/netdev/net-next/c/75b2758abc35

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


