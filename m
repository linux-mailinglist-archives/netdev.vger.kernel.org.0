Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081302D0EF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfE1VXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:23:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbfE1VXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 17:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hLzdQvSQZea2/OazsFQ3XOutPinlv9mR5JFfTttDKFM=; b=S7qMwruypPZ+a15XUIUzHYD/V3
        2l0UptKcECUggtl4ddv9ibv0zp3sxu4I6FTLqyoUpGsmMv/rvNRVOE56Wq4cf+crl18kAeNxHfkyN
        M+mqpsxLD6Z7oi+waV6sBLd7PvviLD2RhStYtlhLcwR4/vH0m5E5IAciJsbOh9SY4p4s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVjYa-00039p-JQ; Tue, 28 May 2019 23:22:52 +0200
Date:   Tue, 28 May 2019 23:22:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V2] net: phy: tja11xx: Add IRQ support to the driver
Message-ID: <20190528212252.GW18059@lunn.ch>
References: <20190528192324.28862-1-marex@denx.de>
 <96793717-a55c-7844-f7c0-cc357c774a19@gmail.com>
 <4f33b529-6c3c-07ee-6177-2d332de514c6@denx.de>
 <cc8db234-4534-674d-eece-5a797a530cdf@gmail.com>
 <ca63964a-242c-bb46-bd4e-76a270dbedb3@denx.de>
 <20190528195806.GV18059@lunn.ch>
 <15906cc0-3d8f-7810-27ed-d64bdbcfa7e7@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15906cc0-3d8f-7810-27ed-d64bdbcfa7e7@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The link detection on the TJA1100 (not TJA1101) seems unstable at best,
> so I better use all the interrupt sources to nudge the PHY subsystem and
> have it check the link change.

Then it sounds like you should just ignore interrupts and stay will
polling for the TJA1100.

	Andrew
