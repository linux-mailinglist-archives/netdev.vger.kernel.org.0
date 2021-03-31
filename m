Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2263A350A51
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhCaWk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:40:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhCaWk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:40:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRjVX-00EFCD-S8; Thu, 01 Apr 2021 00:40:15 +0200
Date:   Thu, 1 Apr 2021 00:40:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 1/4] usbnet: add _mii suffix to
 usbnet_set/get_link_ksettings
Message-ID: <YGT6TwSpW22o4nEf@lunn.ch>
References: <20210330021651.30906-1-grundler@chromium.org>
 <20210330021651.30906-2-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330021651.30906-2-grundler@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 07:16:48PM -0700, Grant Grundler wrote:
> From: Oliver Neukum <oneukum@suse.com>
> 
> The generic functions assumed devices provided an MDIO interface (accessed
> via older mii code, not phylib). This is true only for genuine ethernet.
> 
> Devices with a higher level of abstraction or based on different
> technologies do not have MDIO. To support this case, first rename
> the existing functions with _mii suffix.
> 
> v2: rebased on changed upstream
> v3: changed names to clearly say that this does NOT use phylib
> v4: moved hunks to correct patch; reworded commmit messages
> 
> Signed-off-by : Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>
> Tested-by: Grant Grundler <grundler@chromium.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
