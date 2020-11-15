Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571052B35F7
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 16:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgKOP6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 10:58:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbgKOP6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 10:58:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keKPZ-007CHj-Gm; Sun, 15 Nov 2020 16:57:53 +0100
Date:   Sun, 15 Nov 2020 16:57:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lantiq: Wait for the GPHY firmware to be ready
Message-ID: <20201115155753.GC1701029@lunn.ch>
References: <20201115100623.257293-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201115100623.257293-1-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Add a 300ms delay after initializing all GPHYs to ensure that the GPHY
> firmware had enough time to initialize and to appear on the MDIO bus.
> Unfortunately there is no (known) documentation on what the minimum time
> to wait after releasing the reset on an internal PHY so play safe and
> take the one for the external variant. Only wait after the last GPHY
> firmware is loaded to not slow down the initialization too much (
> xRX200 has two GPHYs but newer SoCs have at least three GPHYs).

Hi Martin

Could this be moved into gswip_gphy_fw_list() where the actual
firmware download happens?

To me that seems like the more logical place.

Otherwise

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
