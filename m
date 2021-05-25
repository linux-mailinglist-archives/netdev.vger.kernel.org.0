Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A956138F844
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhEYCmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:42:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhEYCmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 22:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xLSB6yAwlIYP5Rwoe+Qr3GziprPh6dAvPKbAnns+1+Q=; b=5GqsPCqp4GPV1o3kJPFymZkGVI
        +e2fTkEPAAjFQIEFArVWI7ht5vHrtolonqeSKD9Vm6XuIokQCZF05Qz2xfVCyXewC8NH9EKWPeuub
        fkpZK+k6cbJAnfkYnJWWr+FdqLJIIkCJJdxa4fM8xkC4Z7lf8PqWahtKLjFnuybPrfrk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llMzy-0064hn-Of; Tue, 25 May 2021 04:40:50 +0200
Date:   Tue, 25 May 2021 04:40:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 03/13] net: dsa: sja1105: the 0x1F0000 SGMII
 "base address" is actually MDIO_MMD_VEND2
Message-ID: <YKxjslZ8BDfxPXbh@lunn.ch>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524232214.1378937-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Except that the 0x1f0000 is not a base address at all, it seems. It is
> 0x1f << 16 | 0x0000, and 0x1f is coding for the vendor-specific MMD2.
> So, it turns out, the Synopsys PCS implements all its registers inside
> the vendor-specific MMDs 1 and 2 (0x1e and 0x1f).

Any idea if this is specific to this device, or how the Synopsys PCS
does this in general? I was wondering if the code could be pulled out
and placed in driver/net/pcs, if it could be shared with other devices
using this IP?

      Andrew
