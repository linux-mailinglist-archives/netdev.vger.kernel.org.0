Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A111B165D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgDTT6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:58:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDTT6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 15:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tLugyWjcfpEvL/gdShZ4IltWicY81kM4RiZczduWvrQ=; b=lOuWEGBUrJ8J5Px7b033XRMuh8
        f7PkSB4KMvh1ZsEFBhjRU6cnz0uO3CsjMAHCuscCL7Qvb6wg89qGo13ei1JAjZ+fa6VI/VpyRiAKR
        pZKSJckJrmmoYlm6QQdrQ7ECcgOoh2XmQz1zC0p8E/dYtbtC/ek5IHtGyNQeKA2HFAH0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQcYS-003tQI-Hj; Mon, 20 Apr 2020 21:58:08 +0200
Date:   Mon, 20 Apr 2020 21:58:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 3/3] net: phy: bcm54140: add hwmon support
Message-ID: <20200420195808.GH917792@lunn.ch>
References: <20200420182113.22577-1-michael@walle.cc>
 <20200420182113.22577-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420182113.22577-3-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 08:21:13PM +0200, Michael Walle wrote:
> The PHY supports monitoring its die temperature as well as two analog
> voltages. Add support for it.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Acked-by: Guenter Roeck <linux@roeck-us.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
