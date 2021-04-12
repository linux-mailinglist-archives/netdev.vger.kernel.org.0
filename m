Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C7C35B7AA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhDLAKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235744AbhDLAKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 20:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3704561210;
        Mon, 12 Apr 2021 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618186211;
        bh=q4rIGpu+VhvsqQzVOr6mRunXB70yhfbgsnNn5SXyjiE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XpWSmKZL9TledEkeTszqgoGzmQffFZe7tY6n8+2Dq69q1WOnv1l9c7ll2sNyd4osA
         8RX6/IvjN9Les0uI1lL/DwGM9ayxZuphufvQDNZkipjcmvsVlNT2MPF3OoC2Rw++Z6
         N06AjoRbioa0ywknrWqIl3n+IWQCKwK42ZGdLSJHpFaddMxO51WUHLyfgNpo3GaN5g
         lpheHsuJyO/jUn7EJDOIHvC+dGG4117ngAbH3D5Ta5ZWw+jpK+T8/J2q9mTWqx1ua9
         UA+vi58F9ESPxavWPrWiDJlcZmXIxeUa8nEgJZNKAKUlK21eVFweAeZZdnpQYrfVEP
         VouI5QLS6U6aQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 255F960A4B;
        Mon, 12 Apr 2021 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ehea: add missing MODULE_DEVICE_TABLE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161818621114.2274.14467651748491474485.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 00:10:11 +0000
References: <20210409110911.214-1-linqiheng@huawei.com>
In-Reply-To: <20210409110911.214-1-linqiheng@huawei.com>
To:     Qiheng Lin <linqiheng@huawei.com>
Cc:     dougmill@linux.ibm.com, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 9 Apr 2021 19:09:11 +0800 you wrote:
> This patch adds missing MODULE_DEVICE_TABLE definition which generates
> correct modalias for automatic loading of this driver when it is built
> as an external module.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ehea: add missing MODULE_DEVICE_TABLE
    https://git.kernel.org/netdev/net-next/c/95291ced8169

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


