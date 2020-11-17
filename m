Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB932B5683
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgKQCCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:02:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59114 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgKQCCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:02:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keqKA-007S5K-FA; Tue, 17 Nov 2020 03:02:26 +0100
Date:   Tue, 17 Nov 2020 03:02:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, f.fainelli@gmail.com
Subject: Re: [PATCH RFC v2 2/5] net: stmmac: dwmac-meson8b: fix enabling the
 timing-adjustment clock
Message-ID: <20201117020226.GB1752213@lunn.ch>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
 <20201115185210.573739-3-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115185210.573739-3-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 07:52:07PM +0100, Martin Blumenstingl wrote:
> The timing-adjustment clock only has to be enabled when a) there is a
> 2ns RX delay configured using device-tree and b) the phy-mode indicates
> that the RX delay should be enabled.
> 
> Only enable the RX delay if both are true, instead of (by accident) also
> enabling it when there's the 2ns RX delay configured but the phy-mode
> incicates that the RX delay is not used.
> 
> Fixes: 9308c47640d515 ("net: stmmac: dwmac-meson8b: add support for the RX delay configuration")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
