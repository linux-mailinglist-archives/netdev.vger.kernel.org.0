Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB483A6F6E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhFNTwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234742AbhFNTwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:52:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 75ACA61246;
        Mon, 14 Jun 2021 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623700221;
        bh=OF4Rz0e11Pd0LgSyl1+ksRrZX8NjyX2T3cthL48Qx2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G/sV8W4v8swfsjYvbFui882j9ySOsPq9aK0z36kLm40TBB2Jn4fhbBU/17yUjipw1
         4eKEhg2h/iGZNOxGIwzxuiGT2FtLXOe9qSSrsTmCa2cjfn11CJFRhP9VEVJ0KD/8nL
         tf9uBeYaiVMQLitrlxy904Z1NMWyA5BZYEJiFDJy6EFKWnleBpE1SkH3K7adCApXZG
         N+hPALnri5jWgCB9cRuBZ864kvuaIEnyH4WmExi817qwT7SbXhoLqFBbnCiKK1StBf
         XwO9+KLlNuRLKc8+j/enJ5bYVWqUKzmAjrCVTukEjvpfKX/vfM3g9dJxLGLuSCNrpt
         BLOAz7GhPtuHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 634F0609E7;
        Mon, 14 Jun 2021 19:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: micrel: remove redundant assignment to pointer
 of_node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370022140.10983.8086940228900145661.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:50:21 +0000
References: <20210613132740.73854-1-colin.king@canonical.com>
In-Reply-To: <20210613132740.73854-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 13 Jun 2021 14:27:40 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer of_node is being initialized with a value that is never
> read and it is being updated later with a new value inside a do-while
> loop. The initialization is redundant and can be removed and the
> pointer dev is no longer required and can be removed too.
> 
> [...]

Here is the summary with links:
  - net: phy: micrel: remove redundant assignment to pointer of_node
    https://git.kernel.org/netdev/net-next/c/ce4f8afd85d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


