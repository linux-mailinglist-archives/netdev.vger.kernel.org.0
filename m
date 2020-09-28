Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D88C27B546
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgI1T3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:29:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60064 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgI1T3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 15:29:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMypU-00GZwO-8W; Mon, 28 Sep 2020 21:28:56 +0200
Date:   Mon, 28 Sep 2020 21:28:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH net-next v5 1/2] net: phy: dp83869: support Wake
 on LAN
Message-ID: <20200928192856.GB3950513@lunn.ch>
References: <20200928145135.20847-1-dmurphy@ti.com>
 <20200928145135.20847-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928145135.20847-2-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 09:51:34AM -0500, Dan Murphy wrote:
> This adds WoL support on TI DP83869 for magic, magic secure, unicast and
> broadcast.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
