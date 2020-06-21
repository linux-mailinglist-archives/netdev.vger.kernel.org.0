Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638B8202B7F
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgFUP4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:56:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729210AbgFUP4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 11:56:40 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jn2Kk-001Xe3-OS; Sun, 21 Jun 2020 17:56:38 +0200
Date:   Sun, 21 Jun 2020 17:56:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v2 0/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200621155638.GD338481@lunn.ch>
References: <20200621110005.23306-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621110005.23306-1-ioana.ciornei@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Also, there is already a precedent of a PCS module (mdio-xpcs.c, the
> model of which I have followed) and without also changing that
> (which I am not comfortable doing) there is no point of changing
> this one.

I don't give this much value. You often need a couple of
implementation before you can see what the right structure should
be. And then you refactor. Jose is pretty active, and will probably
help refactor his driver if we ask him.

     Andrew
