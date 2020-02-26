Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2A31702F4
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgBZPpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:45:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35314 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgBZPpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 10:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3E7w4HszEsiPDzMy+hldTRLgCjGx/tQUMWCGTcQGxQk=; b=UkD16FX8hvXHmFGyhjZqRRhRH6
        mjoU2CVba/ZujN7LKUqyesGD4xtSdK3Yx4ptzi5N4x4MjSk5J81Fbu43Y4RLaFHW8Nig2Pnkxw6kk
        RtaOATBPgUdBCSfwyIvNkOtb+lqduriwo+u0WXqRr5+cceEl89J/pLsElx8tKQ0Pcc4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6ysL-0006hw-8c; Wed, 26 Feb 2020 16:45:29 +0100
Date:   Wed, 26 Feb 2020 16:45:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: Re: [PATCH net] net: phy: mscc: fix firmware paths
Message-ID: <20200226154529.GJ7663@lunn.ch>
References: <20200226152650.1525515-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226152650.1525515-1-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 04:26:50PM +0100, Antoine Tenart wrote:
> The firmware paths for the VSC8584 PHYs not not contain the leading
> 'microchip/' directory, as used in linux-firmware, resulting in an
> error when probing the driver. This patch fixes it.
> 
> Fixes: a5afc1678044 ("net: phy: mscc: add support for VSC8584 PHY")
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
