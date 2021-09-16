Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A212A40DB7A
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbhIPNla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240173AbhIPNl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D2B0A61244;
        Thu, 16 Sep 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631799607;
        bh=gop266Plar6OHdCXOZ80GA89TmnAQ1Re4spw9NmFs7w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=udl4VK7t+/3Isi7eI9nBQOxz0QTdoYmWjowcVyfdqt07tJkG/L/r6jC1Ww2GxQhMo
         3ntP7/kmqnqSkCzzxUc0PObsInMX6wnUvVM1Qp/yMVxMTtErU/spBZMonTyN2m1dvF
         GWOxqa1uwybsBQvdFEi6uAXS2BNmkaRVdsZImm1ikkQfiW+h+PnU0ZbEa7RWUIFBuf
         mqTm2dowfjSLX+9nQoroQz1cD5UVBZqB3mDttB7peum0wQKD2rw/QC8Uf52/+emGzq
         uI1LDjxay1VUiskzvUnRPDOmAj273ONUNZn8YuuBMe0yUMEdZleP4XcKXZerHYliF/
         Cw1FP6HAb+sEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B606460A7D;
        Thu, 16 Sep 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] mlxbf_gige: clear valid_polarity upon open
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179960774.17264.3336487167553262857.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 13:40:07 +0000
References: <20210915180848.32166-1-davthompson@nvidia.com>
In-Reply-To: <20210915180848.32166-1-davthompson@nvidia.com>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        limings@nvidia.com, arnd@arndb.de, jgg@ziepe.ca,
        =caihuoqing@baidu.com, asmaa@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 15 Sep 2021 14:08:48 -0400 you wrote:
> The network interface managed by the mlxbf_gige driver can
> get into a problem state where traffic does not flow.
> In this state, the interface will be up and enabled, but
> will stop processing received packets.  This problem state
> will happen if three specific conditions occur:
>     1) driver has received more than (N * RxRingSize) packets but
>        less than (N+1 * RxRingSize) packets, where N is an odd number
>        Note: the command "ethtool -g <interface>" will display the
>        current receive ring size, which currently defaults to 128
>     2) the driver's interface was disabled via "ifconfig oob_net0 down"
>        during the window described in #1.
>     3) the driver's interface is re-enabled via "ifconfig oob_net0 up"
> 
> [...]

Here is the summary with links:
  - [net,v2] mlxbf_gige: clear valid_polarity upon open
    https://git.kernel.org/netdev/net/c/ee8a9600b539

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


