Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EB627B556
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgI1TeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:34:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60084 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgI1TeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 15:34:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMyua-00GZz7-7G; Mon, 28 Sep 2020 21:34:12 +0200
Date:   Mon, 28 Sep 2020 21:34:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH net-next v5 2/2] net: phy: dp83869: Add speed
 optimization feature
Message-ID: <20200928193412.GC3950513@lunn.ch>
References: <20200928145135.20847-1-dmurphy@ti.com>
 <20200928145135.20847-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928145135.20847-3-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 09:51:35AM -0500, Dan Murphy wrote:
> Set the speed optimization bit on the DP83869 PHY.
> 
> Speed optimization, also known as link downshift, enables fallback to 100M
> operation after multiple consecutive failed attempts at Gigabit link
> establishment. Such a case could occur if cabling with only four wires
> (two twisted pairs) were connected instead of the standard cabling with
> eight wires (four twisted pairs).
> 
> The number of failed link attempts before falling back to 100M operation is
> configurable. By default, four failed link attempts are required before
> falling back to 100M.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> +	default:
> +		phydev_err(phydev,
> +			   "Downshift count must be 1, 2, 4 or 8\n");
> +		return -EINVAL;
> +	}

At some point it would be good to plumb in extack so we could return
this to user space.

     Andrew
