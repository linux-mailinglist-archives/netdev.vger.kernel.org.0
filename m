Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6A036E0C6
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 23:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhD1VLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 17:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhD1VKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 17:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14A326144C;
        Wed, 28 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619644210;
        bh=+dbcmKOGo0ltt86A/xPANIcMjprM4VJnYInKiPpHovc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WWO/YUxUF3GMM/4rXpKum8TIfgFRCTUBDeF0+YXu2xAnlfMYZ9DjlvlHC4wEXYB5n
         VJHVgcSrdrmom+IThG4vUKkotlyGkgBxP/gU/tlyoFRf7uC6bWPm2/xBiFMRngXMPX
         4IxM81Dscj6h7IQRcFQ6c5q01h7fLaRiEDn/T/LXpmnMtdgDbzB39TEKxc+bkhwK97
         U+qxxRZb5FTbcl+nflPa2FYaGGfTv8+YyR476U/sknaapb6u0a21QU4lrN1o/Kgy8b
         L9RteEfvWpHMTVIa60hJMMOMMJ6qFZKb50a1cVFkWk9Lu4mWYPj3NcyO/RKPzmmtjj
         vO74f6X1PEeEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0725C60A56;
        Wed, 28 Apr 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: phy: marvell: add downshift support for M88E1240
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161964421002.17892.9873004770450857264.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Apr 2021 21:10:10 +0000
References: <20210428095356.621536-1-fido_max@inbox.ru>
In-Reply-To: <20210428095356.621536-1-fido_max@inbox.ru>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Apr 2021 12:53:56 +0300 you wrote:
> Add downshift support for 88E1240, it uses the same downshift
> configuration registers as 88E1011.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> ---
>  drivers/net/phy/marvell.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [1/1] net: phy: marvell: add downshift support for M88E1240
    https://git.kernel.org/netdev/net-next/c/65ad85f63b15

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


