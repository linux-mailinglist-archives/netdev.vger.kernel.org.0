Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6F232DD06
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhCDWaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:30:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231431AbhCDWaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D849864FF1;
        Thu,  4 Mar 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614897007;
        bh=8ssPmJtGBqQkXCdtQjvYxaPmMnkbq6AhuqBarW8yexA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NwWFLxQApms+Jk8VJqbTZhaHg1ipIMWwbGdKroWftHgM4LMrdpm2NeQp+ZxUqRooP
         vQM4HvX3Yboa7ZVvlNc/+5tvRzehD6BOBE0spbHonIdq1rfJY655SH+P4ovPKjaR64
         gE3nhdvoDfH+yCKUrdQ30gz+B/EWXFtZ/R9TwGoPeCxOUW9ea+UTw+I6FdgcTLNy93
         pmQlLe9Cqms5/Rp0CyqZ/gyMDUJE84aur/Kcsq4MUxFoM/6PL3dWl9dSYdT5nbEccy
         /1O/ZHKYOMI/2lQzgzLOwoc+oiYL3fPqJvCEF+3hRfvhOsiAwIRQ6CZyXZC3TuHkuQ
         31a+AatrBbykg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D055160139;
        Thu,  4 Mar 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: allow qmimux add/del with master up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489700784.12854.11363864827224671683.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:30:07 +0000
References: <20210304131513.3052-1-dnlplm@gmail.com>
In-Reply-To: <20210304131513.3052-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        aleksander@aleksander.es
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 14:15:13 +0100 you wrote:
> There's no reason for preventing the creation and removal
> of qmimux network interfaces when the underlying interface
> is up.
> 
> This makes qmi_wwan mux implementation more similar to the
> rmnet one, simplifying userspace management of the same
> logical interfaces.
> 
> [...]

Here is the summary with links:
  - [1/1] net: usb: qmi_wwan: allow qmimux add/del with master up
    https://git.kernel.org/netdev/net/c/6c59cff38e66

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


