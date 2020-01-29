Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D4D14CDD0
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 16:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgA2Pxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 10:53:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgA2Pxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 10:53:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ezDm4h5T9BcKd1plBnOqDsqZZcCMGu6snPuAmYW/PMQ=; b=GDiwUm0BnUXr3x9DgmIKtgeoXo
        iiiIHb4z/h/5c6QwMpReXLluMuJKXFYCkivTe7m81cQB0WXHqWC240RarLGjgOt/6rdDqUTVZPnDU
        Oim063Bp9P/ZeO6GJKHCSWtiaNSwFE+xlQ1Fz8AJbMiWX3Le+g5Kp/B9pZafXbo7ng1Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iwpf0-00071D-PO; Wed, 29 Jan 2020 16:53:46 +0100
Date:   Wed, 29 Jan 2020 16:53:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <mgr@pengutronix.de>
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH] mdio-bitbang: add support for lowlevel mdio read/write
Message-ID: <20200129155346.GG12180@lunn.ch>
References: <20191107154201.GF7344@lunn.ch>
 <20191218162919.5293-1-m.grzeschik@pengutronix.de>
 <20191221164110.GL30801@lunn.ch>
 <20200129154201.oaxjbqkkyifvf5gg@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129154201.oaxjbqkkyifvf5gg@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 29, 2020 at 04:42:01PM +0100, Michael Grzeschik wrote:
> Hi Andrew!
> 
> I tested your patch. But it works only partially. For the case that
> the upper driver is directly communicating in SMI mode with the phy,
> this works fine. But the regular MDIO connection does not work anymore
> afterwards.
> 
> The normals MDIO communication still needs to work, as mdio-gpio is
> calling of_mdiobus_register that on the other end calls get_phy_device
> and tries to communicate via regular MDIO to the device.

Do you mean you have a mix of devices on the bus, some standards
comformant, and others using this hacked up SMI0 mode?
You need to specify per device if SMI0 should be used?

    Andrew
