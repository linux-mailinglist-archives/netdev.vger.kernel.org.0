Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781E321B6E4
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgGJNpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:45:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgGJNou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 09:44:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jttKV-004TE6-SY; Fri, 10 Jul 2020 15:44:43 +0200
Date:   Fri, 10 Jul 2020 15:44:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 1/5] net: phy: micrel: use consistent
 indention after define
Message-ID: <20200710134443.GG1014141@lunn.ch>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
 <20200710120851.28984-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710120851.28984-2-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 02:08:47PM +0200, Oleksij Rempel wrote:
> This patch changes the indention to one space between "#define" and the
> macro.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
