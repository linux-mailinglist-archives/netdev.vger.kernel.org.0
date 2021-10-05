Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452094225B1
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbhJELwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhJELv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 07:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BB5D361216;
        Tue,  5 Oct 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633434608;
        bh=iY2o5KFYKdPZEoPHLQU/Nlk05wOviuLuLgjkbhRjnt4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tiS85YRMKUTZJ/mEDWX7hKRy9iFEQrut+F0HNb6DS9LAay1A3FCoC8jE2rv7Nuy3i
         1Zkl05TCbsi6JvmGK0qLPAKM1pZqHk31auoiNCoE2jTXwVP4ZsaGLD4bpsa/TqNgwe
         TQuUzAFuY0GvVU+wHuT7rMPJ7cGfDXOEGjX26c53XangwbhVc4bcNB3iuSkTmJFLts
         4rL3XNPXWdyC/I0/udIWItFNvqotS6AFicknyNnF2htdIU0hz5/fM/AZtUG/5GRNGK
         //+5rp05m6kowdrM12s1cz9l3ofgfILDxTkFTpeCj5ihuPfPdWI7U0PrpSePWYYgn/
         SJWLMI5T6WC+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEFED609BA;
        Tue,  5 Oct 2021 11:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] etherdevice: use __dev_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343460871.12488.234099908948681917.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 11:50:08 +0000
References: <20211004230140.2547271-1-kuba@kernel.org>
In-Reply-To: <20211004230140.2547271-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  4 Oct 2021 16:01:40 -0700 you wrote:
> Andrew points out that eth_hw_addr_set() replaces memcpy()
> calls so we can't use ether_addr_copy() which assumes
> both arguments are 2-bytes aligned.
> 
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] etherdevice: use __dev_addr_set()
    https://git.kernel.org/netdev/net/c/3f6cffb8604b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


