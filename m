Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4F53145A5
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhBIBau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:30:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhBIBas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:30:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9Hqw-004zH0-DH; Tue, 09 Feb 2021 02:30:06 +0100
Date:   Tue, 9 Feb 2021 02:30:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2] net: phy: broadcom: remove BCM5482
 1000Base-BX support
Message-ID: <YCHlnr7dFWuECcqv@lunn.ch>
References: <20210208231706.31789-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208231706.31789-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 12:17:06AM +0100, Michael Walle wrote:
> It is nowhere used in the kernel. It also seems to be lacking the
> proper fiber advertise flags. Remove it.

Maybe also remove the #define for PHY_BCM_FLAGS_MODE_1000BX? Maybe
there is an out of tree driver using this? By removing the #define, it
will fail at compile time, making it obvious the support has been
removed?

Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
