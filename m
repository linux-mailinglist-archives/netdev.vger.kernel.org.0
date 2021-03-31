Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A14E350A53
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhCaWmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:42:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhCaWld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:41:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRjWe-00EFD7-3l; Thu, 01 Apr 2021 00:41:24 +0200
Date:   Thu, 1 Apr 2021 00:41:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/4] usbnet: add method for reporting speed without MII
Message-ID: <YGT6lBnBAMLKk6Zu@lunn.ch>
References: <20210330021651.30906-1-grundler@chromium.org>
 <20210330021651.30906-3-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330021651.30906-3-grundler@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 07:16:49PM -0700, Grant Grundler wrote:
> From: Oliver Neukum <oneukum@suse.com>
> 
> The old method for reporting link speed assumed a driver uses the
> generic phy (mii) MDIO read/write functions. CDC devices don't
> expose the phy.
> 
> Add a primitive internal version reporting back directly what
> the CDC notification/status operations recorded.
> 
> v2: rebased on upstream
> v3: changed names and made clear which units are used
> v4: moved hunks to correct patch; rewrote commmit messages
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> Tested-by: Grant Grundler <grundler@chromium.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
