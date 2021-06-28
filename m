Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFD43B6B06
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbhF1Wmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233653AbhF1Wma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 18:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5618361CF9;
        Mon, 28 Jun 2021 22:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624920004;
        bh=lI1x18sgwhttMDRBy6XlYbKMaQWFdvyxZ1P/Q3gy36o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CstQ6+KledjTDryy6xL/1S+sSM4Rzr5ujkC+BUBL3j8PNsMHiVipbkbfm1HAR9V4V
         7XJ5/agR9vo22E1Kzv6y6qMWETf4tcyJP6BYIBvRtZtbdkRFHsMIl1fIDI9x1oSpkC
         +rqAxMgwI5LCcY0PqIMXPq3sFawM6qHRaJf7c6g9FwSuHUQLjQNTfWjuEEk18nNBOY
         DysEdsU5+gu3+on2W96dZt5Rrdw6I89odMtiFwvCBXQ7qNI+7J316bsTjOsrHtFOjt
         QxxOnjrcQawVDcf3/l0oDz4r65QKOMW7pNVITylY83XQlp8BC/qTAddsT3P2ZNAzvz
         8Z5Ewvm+tDdQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 49C1560CE2;
        Mon, 28 Jun 2021 22:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] sctp: add some size validations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162492000429.15052.17681742361896989241.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 22:40:04 +0000
References: <cover.1624904195.git.marcelo.leitner@gmail.com>
In-Reply-To: <cover.1624904195.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ivansprundel@ioactive.com, nhorman@tuxdriver.com,
        vyasevich@gmail.com, lucien.xin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 28 Jun 2021 16:13:40 -0300 you wrote:
> Ilja Van Sprundel reported that some size validations on inbound
> SCTP packets were missing. After some code review, I noticed two
> others that are all fixed here.
> 
> Thanks Ilja for reporting this.
> 
> Marcelo Ricardo Leitner (4):
>   sctp: validate from_addr_param return
>   sctp: add size validation when walking chunks
>   sctp: validate chunk size in __rcv_asconf_lookup
>   sctp: add param size validation for SCTP_PARAM_SET_PRIMARY
> 
> [...]

Here is the summary with links:
  - [net,1/4] sctp: validate from_addr_param return
    https://git.kernel.org/netdev/net/c/0c5dc070ff3d
  - [net,2/4] sctp: add size validation when walking chunks
    https://git.kernel.org/netdev/net/c/50619dbf8db7
  - [net,3/4] sctp: validate chunk size in __rcv_asconf_lookup
    https://git.kernel.org/netdev/net/c/b6ffe7671b24
  - [net,4/4] sctp: add param size validation for SCTP_PARAM_SET_PRIMARY
    https://git.kernel.org/netdev/net/c/ef6c8d6ccf0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


