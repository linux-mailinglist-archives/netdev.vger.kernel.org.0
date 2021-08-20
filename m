Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEF33F3204
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhHTRJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231799AbhHTRJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 13:09:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD2B610CC;
        Fri, 20 Aug 2021 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629479314;
        bh=6Ad+ilmKXkBYKGB3YDYi+cYk50uXVwyBdAJ/McR8sZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EIPZ4n/dZwsQlmWUpqPYhQwFaRUfzhGvZfKn0PW/OZe7YeEPC3wfWmiLtZ7x2t8z6
         kA9XSKb8dF7fKkO5v8Vyec9FF+UhzhULfPQMY9z0BuEeNiK2fGqn8dAVXsM+1cFqb4
         4h0EP/SlhD/26WYauS6CFyPzx5YMviKWCukQ/qDYCStTSxfsONu+WkA1rKSUSMFVNP
         4KICGbswo34oyUFlnkbNsG2op/SZRWSGhCkP2dhvP/VKI4VWNblD50yYtXzilo9VHX
         UuZzPjC9qQpuU5D6rlZTH5B0VU11HaZUFEHvrA/0Bg/L+seYwOZpMjCEnQaBKNINZz
         dfIXM8qQTvS3A==
Date:   Fri, 20 Aug 2021 10:08:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: usb: asix: ax88772: move embedded PHY
 detection as early as possible
Message-ID: <20210820100832.4b548200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210820095243.2452-1-o.rempel@pengutronix.de>
References: <20210820095243.2452-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021 11:52:43 +0200 Oleksij Rempel wrote:
> Some HW revisions need additional MAC configuration before the embedded PHY
> can be enabled. If this is not done, we won't be able to get response
> from the internal PHY.
> 
> This issue was detected on chipcode == AX_AX88772_CHIPCODE variant,
> where ax88772_hw_reset() was executed with missing embd_phy flag.
> 
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Reported-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Does not apply to net, please rebase
