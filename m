Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950208C1D2
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 22:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfHMUJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 16:09:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfHMUJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 16:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7aZwbEZYwkaMwsIk7S7vI8ZJhyHjXfPuMdvTzxY34DY=; b=Cdy/9K3IVmx0qfgQmAuRrYcHUN
        8GH+ld2ARKa1/OqDiVPReo4MDHJJH8PWbeMx77nvg1rFnUhaFlVel93ptXCSFObYCwlsACJ5Xwp+P
        JkuWkM1e0IX+dZi09+vjzRz1SiVcA54qdL3QsE6jNBezUvdnU0V/99NwaizlLwdy5Ejk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxd6b-0004Fy-Uf; Tue, 13 Aug 2019 22:09:17 +0200
Date:   Tue, 13 Aug 2019 22:09:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 3/4] net: phy: realtek: Add helpers for accessing
 RTL8211x extension pages
Message-ID: <20190813200917.GK15047@lunn.ch>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-4-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813191147.19936-4-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 12:11:46PM -0700, Matthias Kaehlcke wrote:
> Some RTL8211x PHYs have extension pages, which can be accessed
> after selecting a page through a custom method. Add a function to
> modify bits in a register of an extension page and a helper for
> selecting an ext page. Use rtl8211x_modify_ext_paged() in
> rtl8211e_config_init() instead of doing things 'manually'.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
