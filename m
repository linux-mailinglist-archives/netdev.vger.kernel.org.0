Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 818135EE95
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 23:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfGCVdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 17:33:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52380 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbfGCVdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 17:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DwOQ1VhqzOlKO8GcPOTAjm30bxi+tef4PCN5in+ERJQ=; b=4D1D82b7l3oxNLiNgWPNJH70tZ
        av10Vp1R7e8O4us3SP9fUgWsEl4zL0VLCWoNZOouCgsIC7YKPWeIxAYBF7g5VKcf1QOaSXe7kx9AO
        T/LacQKMGHL+qLmc7wObJvUsSswpjRlmIh0wfEXC+66B4ewmezgzopsoxdDhTlEFCkIU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1himsZ-0008CN-3n; Wed, 03 Jul 2019 23:33:27 +0200
Date:   Wed, 3 Jul 2019 23:33:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 1/7] dt-bindings: net: Add bindings for Realtek PHYs
Message-ID: <20190703213327.GH18473@lunn.ch>
References: <20190703193724.246854-1-mka@chromium.org>
 <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think if we're going to have custom properties for phys, we should
> have a compatible string to at least validate whether the custom
> properties are even valid for the node.

Hi Rob

What happens with other enumerable busses where a compatible string is
not used?

The Ethernet PHY subsystem will ignore the compatible string and load
the driver which fits the enumeration data. Using the compatible
string only to get the right YAML validator seems wrong. I would
prefer adding some other property with a clear name indicates its is
selecting the validator, and has nothing to do with loading the
correct driver. And it can then be used as well for USB and PCI
devices etc.

	Andrew


