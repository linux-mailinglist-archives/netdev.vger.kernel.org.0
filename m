Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C99334068B
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhCRNK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:10:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231424AbhCRNK0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 09:10:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMsPt-00Bfly-Ts; Thu, 18 Mar 2021 14:10:21 +0100
Date:   Thu, 18 Mar 2021 14:10:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 08/10] of: of_net: Provide function name and param
 description
Message-ID: <YFNRPVAvew4ulo3d@lunn.ch>
References: <20210318104036.3175910-1-lee.jones@linaro.org>
 <20210318104036.3175910-9-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318104036.3175910-9-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 10:40:34AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/of/of_net.c:104: warning: Function parameter or member 'np' not described in 'of_get_mac_address'
>  drivers/of/of_net.c:104: warning: expecting prototype for mac(). Prototype was for of_get_mac_address() instead
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Thanks for fixing it up.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
