Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1111C36DF73
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 21:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243937AbhD1TU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 15:20:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239291AbhD1TU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 15:20:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbpif-001YKH-04; Wed, 28 Apr 2021 21:19:33 +0200
Date:   Wed, 28 Apr 2021 21:19:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        linus.walleij@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: Convert mdio-gpio to yaml
Message-ID: <YIm1REuYDPUwqSYf@lunn.ch>
References: <20210428163120.3657234-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428163120.3657234-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  gpios:
> +    minItems: 2
> +    description: |
> +      MDC and MDIO lines connected to GPIO controllers are listed in
> +      the gpios property as described in section VIII.1 in the
> +      following order: MDC, MDIO.

You should probably add maxItems: 3, or however you describe this in
yaml. You often find with x86 machines you don't have GPIOs, just GPI
and GPO, and you need to combine two to form the MDIO line of the MDIO
bus.

	Andrew
