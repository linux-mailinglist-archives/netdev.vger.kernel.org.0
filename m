Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F8136F1E9
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 23:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhD2VVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 17:21:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46694 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237204AbhD2VU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 17:20:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcE4p-001iHP-Q3; Thu, 29 Apr 2021 23:20:03 +0200
Date:   Thu, 29 Apr 2021 23:20:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: Convert mdio-gpio to yaml
Message-ID: <YIsjA31lgCNuFLnp@lunn.ch>
References: <20210429192326.1148440-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429192326.1148440-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 07:23:26PM +0000, Corentin Labbe wrote:
> Converts net/mdio-gpio.txt to yaml
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

For the basic information contents:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

I cannot say anything about the YAML.

    Andrew
