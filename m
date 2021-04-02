Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904A03530C1
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhDBVaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhDBVaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 17:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B83861167;
        Fri,  2 Apr 2021 21:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617399012;
        bh=a46Y2i4i5bvIamUHN/3G9bX5ipZMCswPeZ6CjvPsBkc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bItPlJum3SGweCX2DpCTJPmQhVgrkDwz6G2QXQm5/6hXWmLhDuQl1cpKwof9tj9ZO
         AXYVBVs1GqEhvYs8U4WAJghgO4mZbIPelhXQc9osbDA9/ShmtAOiVtUgWF6OE+y9EU
         mh3HBllPDafS9toYMvVBwwUlqiY/68iAayhDEZwR6KXQ2esQms904GSGySz0svfoC6
         0msJKQhjNYJZVQG/Qirvr4wgsnePJy8eNdcYAIRWl0WhcjmWA6O0cM1sdfKy2ASAv/
         Dut/qibF/G+zt4TrX1cZtN8Pc6Wjwi4aacm9OOtdXBBTsMily6djhJ+XBratGYL/Wv
         xvPWTQJRZgSqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 832A0609D3;
        Fri,  2 Apr 2021 21:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] ionic: add PTP and hw clock support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161739901253.1946.16665494812910399760.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Apr 2021 21:30:12 +0000
References: <20210401175610.44431-1-snelson@pensando.io>
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 10:55:58 -0700 you wrote:
> This patchset adds support for accessing the DSC hardware clock and
> for offloading PTP timestamping.
> 
> Tx packet timestamping happens through a separate Tx queue set up with
> expanded completion descriptors that can report the timestamp.
> 
> Rx timestamping can happen either on all queues, or on a separate
> timestamping queue when specific filtering is requested.  Again, the
> timestamps are reported with the expanded completion descriptors.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] ionic: add new queue features to interface
    https://git.kernel.org/netdev/net-next/c/57a3a98d7c0a
  - [net-next,02/12] ionic: add handling of larger descriptors
    https://git.kernel.org/netdev/net-next/c/0ec9f6669a7d
  - [net-next,03/12] ionic: add hw timestamp structs to interface
    https://git.kernel.org/netdev/net-next/c/3da258439e89
  - [net-next,04/12] ionic: split adminq post and wait calls
    https://git.kernel.org/netdev/net-next/c/4f1704faa013
  - [net-next,05/12] ionic: add hw timestamp support files
    https://git.kernel.org/netdev/net-next/c/fee6efce565d
  - [net-next,06/12] ionic: link in the new hw timestamp code
    https://git.kernel.org/netdev/net-next/c/61db421da31b
  - [net-next,07/12] ionic: add rx filtering for hw timestamp steering
    https://git.kernel.org/netdev/net-next/c/ab470bbe7aba
  - [net-next,08/12] ionic: set up hw timestamp queues
    https://git.kernel.org/netdev/net-next/c/f0790bcd3606
  - [net-next,09/12] ionic: add and enable tx and rx timestamp handling
    https://git.kernel.org/netdev/net-next/c/a8771bfe0554
  - [net-next,10/12] ionic: add ethtool support for PTP
    https://git.kernel.org/netdev/net-next/c/f8ba81da73fc
  - [net-next,11/12] ionic: ethtool ptp stats
    https://git.kernel.org/netdev/net-next/c/196f56c07f91
  - [net-next,12/12] ionic: advertise support for hardware timestamps
    https://git.kernel.org/netdev/net-next/c/afeefec67736

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


