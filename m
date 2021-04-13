Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB66B35E8A9
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347002AbhDMWAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239106AbhDMWA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 202CE61249;
        Tue, 13 Apr 2021 22:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618351209;
        bh=fcuDnbaARUpS6WCEKkZX+fSfeuoXnVpyChMHuY/bggE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pRfXYq/x3NChnPT3V+vlDicX8nnL7LBskXc0As1i10weOhAMR5h1ptjOWzGSSnt/u
         LH8Vno/F2lSQ/HT70ZuIiHQrrK4S0/y2VzGS+ghIzH+K36tQ/BsBC93lZ7z9uT+Qfk
         XKq/HNE1k4ZWESA1hZfjJFdd947UdVwjXC3oIm/E7EBY/hyegsE8hi+rhe2FVQAl7O
         wtZhmsFWzYUcUVPpq101OwvUgBvf9PJliMR9QBr3Xc/yFyupROGECm85XHMMeZSz9/
         HUEWvs7vH5Qb5FG1acuYd/RtkzRnlMnsrcotcI9dWUzim/cz8qCOgKHgs9YmMRaPnI
         i3jrAzZn0vbGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0EE3860CCF;
        Tue, 13 Apr 2021 22:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ibmvnic: correctly use dev_consume/free_skb_irq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835120905.27588.8054740402054234192.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 22:00:09 +0000
References: <20210413083325.10533-1-lijunp213@gmail.com>
In-Reply-To: <20210413083325.10533-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Apr 2021 03:33:25 -0500 you wrote:
> It is more correct to use dev_kfree_skb_irq when packets are dropped,
> and to use dev_consume_skb_irq when packets are consumed.
> 
> Fixes: 0d973388185d ("ibmvnic: Introduce xmit_more support using batched subCRQ hcalls")
> Suggested-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] ibmvnic: correctly use dev_consume/free_skb_irq
    https://git.kernel.org/netdev/net/c/ca09bf7bb109

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


