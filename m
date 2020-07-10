Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E325E21B6FA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgGJNrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:47:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57244 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgGJNrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 09:47:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jttMn-004TGH-DL; Fri, 10 Jul 2020 15:47:05 +0200
Date:   Fri, 10 Jul 2020 15:47:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 2/5] net: phy: micrel: apply resume errata
 workaround for ksz8873 and ksz8863
Message-ID: <20200710134705.GH1014141@lunn.ch>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
 <20200710120851.28984-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710120851.28984-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 02:08:48PM +0200, Oleksij Rempel wrote:
> The ksz8873 and ksz8863 switches are affected by following errata:

This should really be a patch on its own, aimed at net, so it gets
back ported to stable.

     Andrew
