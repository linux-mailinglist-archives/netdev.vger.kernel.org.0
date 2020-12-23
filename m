Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5B82E15A7
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731229AbgLWCuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbgLWCus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5A16122A83;
        Wed, 23 Dec 2020 02:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608691807;
        bh=8VFXTEfHDGjNESRmbEEfEo5L/KJO3UHHaAHamquqEoQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rzI03I4pbTjxU0N2WSCSMJpYVJX/MjsP24v1Rz3Hov6OSRHasrvk5xB7lP1XWgcQi
         o8kwj5M8r9hAG/kpuiL4jPwc6Wd++5rdUO0aQk0cGlNZfsveEir0bpkwvUXIlcie2Q
         kagTdULleRX29NlCW/8S5RQVUP5NbGKkfGxPnHRnmnzmBZmREcpMruFKQEktPfEJPu
         DKRZ4X/3KnYRZ8f1WViLhyHY4WMJQlimQr53rBnRGTCRQ6RRBMvoock4DKfJDPO/ce
         C8xtbkSckGTltbaBcD9dNZg79KnZb67uFb3urDB/eoLe9sEkEXPXCw1r0dwLsBrkud
         Ed72tqzn1MrvQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 4A03F60593;
        Wed, 23 Dec 2020 02:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: remove names from mailing list maintainers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160869180729.29227.5706578456404319351.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 02:50:07 +0000
References: <20201219185538.750076-1-kuba@kernel.org>
In-Reply-To: <20201219185538.750076-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pv-drivers@vmware.com,
        doshir@vmware.com, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, woojung.huh@microchip.com,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        drivers@pensando.io, snelson@pensando.io, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        bryan.whitehead@microchip.com, o.rempel@pengutronix.de,
        kernel@pengutronix.de, robin@protonic.nl, hkallweit1@gmail.com,
        nic_swsd@realtek.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, linux-kernel@vger.kernel.org,
        corbet@lwn.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 19 Dec 2020 10:55:38 -0800 you wrote:
> When searching for inactive maintainers it's useful to filter
> out mailing list addresses. Such "maintainers" will obviously
> never feature in a "From:" line of an email or a review tag.
> 
> Since "L:" entries only provide the address of a mailing list
> without a fancy name extend this pattern to "M:" entries.
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: remove names from mailing list maintainers
    https://git.kernel.org/netdev/net/c/8b0f64b113d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


