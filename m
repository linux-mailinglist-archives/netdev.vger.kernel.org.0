Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE192B5680
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgKQCCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:02:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbgKQCBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:01:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keqJN-007S4p-J8; Tue, 17 Nov 2020 03:01:37 +0100
Date:   Tue, 17 Nov 2020 03:01:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, f.fainelli@gmail.com
Subject: Re: [PATCH RFC v2 1/5] dt-bindings: net: dwmac-meson: use
 picoseconds for the RGMII RX delay
Message-ID: <20201117020137.GA1752213@lunn.ch>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
 <20201115185210.573739-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115185210.573739-2-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 07:52:06PM +0100, Martin Blumenstingl wrote:
> Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
> delay register which allows picoseconds precision. Deprecate the old
> "amlogic,rx-delay-ns" in favour of a new "amlogic,rgmii-rx-delay-ps"
> property.
> 
> For older SoCs the only known supported values were 0ns and 2ns. The new
> SoCs have 200ps precision and support RGMII RX delays between 0ps and
> 3000ps.
> 
> While here, also update the description of the RX delay to indicate
> that:
> - with "rgmii" or "rgmii-id" the RX delay should be specified
> - with "rgmii-id" or "rgmii-rxid" the RX delay is added by the PHY so
>   any configuration on the MAC side is ignored
> - with "rmii" the RX delay is not applicable and any configuration is
>   ignored
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
