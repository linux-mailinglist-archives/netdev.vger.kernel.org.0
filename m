Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4475727058A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgIRT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:28:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgIRT2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 15:28:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJM34-00FHJO-Qd; Fri, 18 Sep 2020 21:27:58 +0200
Date:   Fri, 18 Sep 2020 21:27:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: dp83869: Add ability to advertise
 Fiber connection
Message-ID: <20200918192758.GB3640666@lunn.ch>
References: <20200918191453.13914-1-dmurphy@ti.com>
 <20200918191453.13914-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918191453.13914-3-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:14:52PM -0500, Dan Murphy wrote:
> Add the ability to advertise the Fiber connection if the strap or the
> op-mode is configured for 100Base-FX.
> 
> Auto negotiation is not supported on this PHY when in fiber mode.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
