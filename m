Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2C040ACF4
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhINMB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232464AbhINMBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DECBB61130;
        Tue, 14 Sep 2021 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631620807;
        bh=jDYSPGSsj1J8XaUWZqYTB+SaFo8BavEQKKS9GQk5W94=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pPQG5GGRoHEiTJhzi0jarTJc4DTDIdO18+JPi7oAc7cc5SC6wMdjhYFw/9sOOYAwV
         18oYGV/thHGSz9patXA0kZHfGuTbfOdmyIWsMiRz5B5cBqoIh/Qq0vXJv+OSZ9DmhO
         3emRarzOgEfmm8a3d7Gu2MehRPQIklaMjkcrcnCxePM0AvRvugf8/4kxZ/oQ5DF7Ob
         qHXptGoRFiXiAy803FqBwg5bn1kZIHYrrxEWWVG5FrEfLpgH8fJyXuiC3Zv3QCM2PD
         1WYFcmLSc/ILowekHuEo1wX9sG+9m138f/Vh8PSLv+XxHXb2rY9dh9IEMuZ3Mjjd51
         tY1F8B4xB3+Lg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D838F60A6F;
        Tue, 14 Sep 2021 12:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net/smc: add EID support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162080788.6005.3584458121489217986.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 12:00:07 +0000
References: <20210914083507.511369-1-guvenc@linux.ibm.com>
In-Reply-To: <20210914083507.511369-1-guvenc@linux.ibm.com>
To:     Guvenc Gulce <guvenc@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 10:35:04 +0200 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for smc to netdev's net-next
> tree. The series introduce the so called Enterprise ID support for smc
> protocol. Including the generic netlink based interface.
> 
> Thanks,
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net/smc: add support for user defined EIDs
    https://git.kernel.org/netdev/net-next/c/fa0866625543
  - [net-next,2/3] net/smc: keep static copy of system EID
    https://git.kernel.org/netdev/net-next/c/11a26c59fc51
  - [net-next,3/3] net/smc: add generic netlink support for system EID
    https://git.kernel.org/netdev/net-next/c/3c572145c24e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


