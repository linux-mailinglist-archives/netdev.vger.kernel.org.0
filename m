Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACC640ACC3
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhINLva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232195AbhINLv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 07:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AC447610D1;
        Tue, 14 Sep 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631620208;
        bh=HuWDJYmRqGdNHp6jp2wEjjFo8fXFOt6lzWQV0QRFetU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=snxvVIFLfKXz/SHOv+tkll5PfIe1kIYlDOquQ2jzVbjtITmT155R0XRE2qW5LGp8E
         4u4ibD83aMEIRLTgWyX6N4r3ImE99Gd6rGN059JuPf6MRBNZezYzEZNZvbRnjT6Iu2
         YTZqTLqG8nWqTJegxi4w6ClQeriqVOlSXIqgCO3WMPUhWfBdulFALBttR1HTq/OtpX
         RLo98KlfNMgw3l9Al3VyfMMA3tErGMQ9R/6gkkrMsk4gECH/dbMRx05Iu0SnTXDOb0
         3Ay17AEKTXVL7s+YGNLM96rZUNMuOy7mdF4Ol4SbDLvbIDLrC180CR542AfMLWHcMK
         M8qpyZgC1AbdQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A012760A7D;
        Tue, 14 Sep 2021 11:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] s390/net: updates 2021-09-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162020865.1096.6445816710213153187.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 11:50:08 +0000
References: <20210914083320.508996-1-kgraul@linux.ibm.com>
In-Reply-To: <20210914083320.508996-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, jwi@linux.ibm.com,
        christophe.jaillet@wanadoo.fr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 10:33:16 +0200 you wrote:
> Please apply the following patches to netdev's net-next tree.
> 
> Stop using the wrappers in include/linux/pci-dma-compat.h,
> and fix warnings about incorrect kernel-doc comments.
> 
> Christophe JAILLET (1):
>   s390/ism: switch from 'pci_' to 'dma_' API
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] s390/ctcm: remove incorrect kernel doc indicators
    https://git.kernel.org/netdev/net-next/c/a962cc4ba1a1
  - [net-next,2/4] s390/lcs: remove incorrect kernel doc indicators
    https://git.kernel.org/netdev/net-next/c/239686c11f6a
  - [net-next,3/4] s390/netiucv: remove incorrect kernel doc indicators
    https://git.kernel.org/netdev/net-next/c/478a31403b36
  - [net-next,4/4] s390/ism: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/a1ac1b6e4137

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


