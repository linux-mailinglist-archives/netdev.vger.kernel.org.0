Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7833D7B20
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhG0QgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:36:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhG0QgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 12:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N9IVrWRXxsCuaImLb/sEKG+W00sCSXz/eWKQb2ovXDI=; b=pHO962RwMvRrn6xdjmJTk8PliN
        7Xg5BMuKiBZu8S4HYdwIEgxhmzijuW5QZGy/e8o7wTtjpW0+PR3CbnOGVpEs8yPdupykteATCMx+C
        QnJCw961S9UBlt/syE/hOtkslblz63SzDvg/uKTH3myE9nnU6qeQIbOZLGVZtazo8i+4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8Q3r-00F2WS-6M; Tue, 27 Jul 2021 18:36:07 +0200
Date:   Tue, 27 Jul 2021 18:36:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     alexandru.tachici@analog.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH v2 3/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <YQA19+65/nOr/qCb@lunn.ch>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-4-alexandru.tachici@analog.com>
 <20210727064746.lsz3ip7jyjbjkskj@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727064746.lsz3ip7jyjbjkskj@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Please compare the PHY datasheet with 802.3.2018 and 802.3cg-2019, and
> implement common parts as phy generic code.

+1

Thanks
	Andrew
