Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6BD350A55
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhCaWnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:43:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhCaWme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:42:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRjXf-00EFEU-SN; Thu, 01 Apr 2021 00:42:27 +0200
Date:   Thu, 1 Apr 2021 00:42:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 3/4] net: cdc_ncm: record speed in status method
Message-ID: <YGT60zQuo1XW85wb@lunn.ch>
References: <20210330021651.30906-1-grundler@chromium.org>
 <20210330021651.30906-4-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330021651.30906-4-grundler@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 07:16:50PM -0700, Grant Grundler wrote:
> From: Oliver Neukum <oneukum@suse.com>
> 
> Until very recently, the usbnet framework only had support functions
> for devices which reported the link speed by explicitly querying the
> PHY over a MDIO interface. However, the cdc_ncm devices send
> notifications when the link state or link speeds change and do not
> expose the PHY (or modem) directly.
> 
> Support funtions (e.g. usbnet_get_link_ksettings_internal()) to directly
> query state recorded by the cdc_ncm driver were added in a previous patch.
> 
> So instead of cdc_ncm spewing the link speed into the dmesg buffer,
> record the link speed encoded in these notifications and tell the
> usbnet framework to use the new functions to get link speed/state.
> Link speed/state is now available via ethtool.
> 
> This is especially useful given all current RTL8156 devices emit
> a connection/speed status notification every 32ms and this would
> fill the dmesg buffer. This implementation replaces the one
> recently submitted in de658a195ee23ca6aaffe197d1d2ea040beea0a2 :
>    "net: usb: cdc_ncm: don't spew notifications"
> 
> v2: rebased on upstream
> v3: changed variable names
> v4: rewrote commit message
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
