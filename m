Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E7D2B5689
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgKQCFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:05:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgKQCFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:05:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keqMs-007S7z-Jy; Tue, 17 Nov 2020 03:05:14 +0100
Date:   Tue, 17 Nov 2020 03:05:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, f.fainelli@gmail.com
Subject: Re: [PATCH RFC v2 4/5] net: stmmac: dwmac-meson8b: move RGMII delays
 into a separate function
Message-ID: <20201117020514.GD1752213@lunn.ch>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
 <20201115185210.573739-5-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115185210.573739-5-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 07:52:09PM +0100, Martin Blumenstingl wrote:
> Newer SoCs starting with the Amlogic Meson G12A have more a precise
> RGMII RX delay configuration register. This means more complexity in the
> code. Extract the existing RGMII delay configuration code into a
> separate function to make it easier to read/understand even when adding
> more logic in the future.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
