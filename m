Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D802DC859
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 22:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgLPVas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 16:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgLPVas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 16:30:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608154207;
        bh=lQ/AU387V2OL0KtbNEhgxg6syYNIY20P6j7RtXGmFSE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B5xdJZEmuvsEmVEcHnVkQmZXqphCyQywOiFrg55nVf5vfzzGKzdh2RWNv2i8TvDId
         e9RXQpqdyVGr3TS2MzcDZgprW4TWPVT1RrWHRBgFYo3dg71UL+0Z36ytSYuXGjL/ud
         9J/dbHoxW3gWbwOlMweG++TZcP2UyHdvl95CZc6EWvOaEVi0GOiLfeV9MVYu8nYp+D
         ZaRw6R++XqZ5BG/948eFZjMJyC4FrzASQZEAJd9mzAoVa1TTZq4HWvwSixOkDLEu77
         J4qx4AQdssaCww/f5o350hIRDfZHihksLiOE7fanBMTGA2NyA2elDY+EqTQds6qVKh
         ENGW49M6iQDKg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] nfc: s3fwrn5: Refactor the s3fwrn5 module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160815420769.5654.2994290964993845851.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 21:30:07 +0000
References: <20201215065401.3220-1-bongsu.jeon@samsung.com>
In-Reply-To: <20201215065401.3220-1-bongsu.jeon@samsung.com>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     krzk@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bongsu.jeon@samsung.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 15 Dec 2020 15:53:59 +0900 you wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Refactor the s3fwrn5 module.
> 
> 1/2 is to remove the unneeded delay for NFC sleep.
> 2/2 is to remove the unused NCI prop commands.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] nfc: s3fwrn5: Remove the delay for NFC sleep
    https://git.kernel.org/netdev/net/c/7ec27c9e97f2
  - [v2,net-next,2/2] nfc: s3fwrn5: Remove unused NCI prop commands
    https://git.kernel.org/netdev/net/c/e2138e3f3537

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


