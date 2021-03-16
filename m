Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AA233E18C
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCPWke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231420AbhCPWkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD8EE64F51;
        Tue, 16 Mar 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615934410;
        bh=Jbkn2Vc242Wc1nH9miziEmPR74EttDi9bPeSKdGt4P8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RGbMKgINt1ikFzXE0a/hrE8S+B+EPkocygMLlXixs5CwH8rZJNb51AQE/YE5b+hdv
         1FdSAI+9PxVIWYjyNvnTgcxzSOgV3hOqrh+Yh5lRFIXg/egPkSg3oKxCG5yV5EJuY8
         Jg5HEaNF3yg091d+bxHE52RMmuMkMMQUMKR2vmvC+NynrrcLH6+TZEFDOLW6qhxtet
         AJ4u/J2tZu5XBHvICfah6Q2ig6EGpb88bKvRlaK6TpbUpWIlyhLdjGHAUsKkWE+lm1
         omzjvXMPBaAdyxsW8FBsJsmKpHd7CYyswz2EqLhuwjTTOHHqTP44/9TYlFRYh+2s68
         T0zh7/g4Izt/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D49B660A45;
        Tue, 16 Mar 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] dpaa2-switch: small cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593441086.11342.7562548452540199294.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:40:10 +0000
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
In-Reply-To: <20210316145512.2152374-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 16:55:07 +0200 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set addresses various low-hanging issues in both dpaa2-switch
> and dpaa2-eth drivers.
> Unused ABI functions are removed from dpaa2-switch, all the kernel-doc
> warnings are fixed up in both drivers and the coding style for the
> remaining ABIs is fixed-up a bit.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] dpaa2-switch: remove unused ABI functions
    https://git.kernel.org/netdev/net-next/c/cba0445633bc
  - [net-next,2/5] dpaa2-switch: fix kdoc warnings
    https://git.kernel.org/netdev/net-next/c/05b363608b5b
  - [net-next,3/5] dpaa2-switch: reduce the size of the if_id bitmap to 64 bits
    https://git.kernel.org/netdev/net-next/c/2b7e3f7d1b7e
  - [net-next,4/5] dpaa2-switch: fit the function declaration on the same line
    https://git.kernel.org/netdev/net-next/c/5ac2d254382c
  - [net-next,5/5] dpaa2-eth: fixup kdoc warnings
    https://git.kernel.org/netdev/net-next/c/4fe72de61ec8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


