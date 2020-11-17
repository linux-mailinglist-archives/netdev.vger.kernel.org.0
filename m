Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FAF2B5690
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgKQCHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:07:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgKQCHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:07:05 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keqOZ-007S9C-4V; Tue, 17 Nov 2020 03:06:59 +0100
Date:   Tue, 17 Nov 2020 03:06:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, f.fainelli@gmail.com
Subject: Re: [PATCH RFC v2 5/5] net: stmmac: dwmac-meson8b: add support for
 the RGMII RX delay on G12A
Message-ID: <20201117020659.GE1752213@lunn.ch>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
 <20201115185210.573739-6-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115185210.573739-6-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 07:52:10PM +0100, Martin Blumenstingl wrote:
> Amlogic Meson G12A (and newer: G12B, SM1) SoCs have a more advanced RX
> delay logic. Instead of fine-tuning the delay in the nanoseconds range
> it now allows tuning in 200 picosecond steps. This support comes with
> new bits in the PRG_ETH1[19:16] register.
> 
> Add support for validating the RGMII RX delay as well as configuring the
> register accordingly on these platforms.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
