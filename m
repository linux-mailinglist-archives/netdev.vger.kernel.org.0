Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1CD350A63
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhCaWoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:44:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhCaWnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:43:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRjYt-00EFFS-L6; Thu, 01 Apr 2021 00:43:43 +0200
Date:   Thu, 1 Apr 2021 00:43:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Grundler <GrantGrundlergrundler@chromium.org>
Subject: Re: [PATCHv4 4/4] net: cdc_ether: record speed in status method
Message-ID: <YGT7H9lzypzAAIPR@lunn.ch>
References: <20210330021651.30906-1-grundler@chromium.org>
 <20210330021651.30906-5-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330021651.30906-5-grundler@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 07:16:51PM -0700, Grant Grundler wrote:
> From: Grant Grundler <Grant Grundler grundler@chromium.org>
> 
> Until very recently, the usbnet framework only had support functions
> for devices which reported the link speed by explicitly querying the
> PHY over a MDIO interface. However, the cdc_ether devices send
> notifications when the link state or link speeds change and do not
> expose the PHY (or modem) directly.
> 
> Support funtions (e.g. usbnet_get_link_ksettings_internal()) to directly
> query state recorded by the cdc_ether driver were added in a previous patch.
> 
> Instead of cdc_ether spewing the link speed into the dmesg buffer,
> record the link speed encoded in these notifications and tell the
> usbnet framework to use the new functions to get link speed/state.
> 
> User space can now get the most recent link speed/state using ethtool.
> 
> v4: added to series since cdc_ether uses same notifications
>     as cdc_ncm driver.
> 
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
