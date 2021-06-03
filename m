Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1782639AC33
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhFCVB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhFCVBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 26B3461403;
        Thu,  3 Jun 2021 21:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622754005;
        bh=fJTH/xRRuDwLq6NBkRIE5tRwqzq6Y/YonrOYGQRqEOU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=djlZI3aKM7C7UudQ9KCZQO8bsE40GMqhktA2/4QVrcRgSFrXncMdysml/nwIA6m0z
         fUheQ1PeP/Qrn2B8J/ZsPZwsrnMYLuIO+T3fKQGz52cp5IHiodh3kOfyBORFipSeRm
         fSEMM0j8WdtGQs/z9fAKaK9y4AZ8ts5hUirkDYHmPwLhT/wQGlH+TLVyv6NRaPix5I
         ifTTXW7KHF0xBtgFppeFUoFJkJ3Ogz/2Gn9ixtCepTc6mYP+uKlK+p8HN0N89JIVU8
         D7os+Y26ta74OFhjth64Xe0GxNIN3kTYCbPtwepPRWiKzRQ4UBGQqNrVHjj9iLXsIp
         LnQ+AuDaiAQHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 202F960A02;
        Thu,  3 Jun 2021 21:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net/smc: updates 2021-06-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275400512.32659.7809586894785729146.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:00:05 +0000
References: <20210602085626.2877926-1-kgraul@linux.ibm.com>
In-Reply-To: <20210602085626.2877926-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hca@linux.ibm.com,
        raspl@linux.ibm.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 10:56:24 +0200 you wrote:
> Please apply the following patch series for smc to netdev's net-next tree.
> 
> Both patches are cleanups and remove unnecessary code.
> 
> Julian Wiedmann (1):
>   net/smc: no need to flush smcd_dev's event_wq before destroying it
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/smc: avoid possible duplicate dmb unregistration
    https://git.kernel.org/netdev/net-next/c/f8e0a68babae
  - [net-next,2/2] net/smc: no need to flush smcd_dev's event_wq before destroying it
    https://git.kernel.org/netdev/net-next/c/5e4a43ceb22a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


