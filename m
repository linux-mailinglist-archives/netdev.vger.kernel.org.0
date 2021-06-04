Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B44639B8DD
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhFDMRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:17:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230030AbhFDMRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 08:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7UGIMtOwuhGkxnOu4hmmARx8NRAZCdOeHsLfDcmIe5E=; b=zESq3aQBtKYsd/prhXzeRJxNMK
        eZVhkDEITQC5w9qcjHcKL9i83i1YQ9yd/Fbnb9PuJZTpy0tIe5hD7TVCujfHyLqf8YW4xMofpTXde
        EubLGM3kiP0gxklZZcey8hWmz5T2YjJUE5EtTqnCGqyOSMUJbNypoRfOwK8LLlEr1chM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lp8jS-007nTK-NQ; Fri, 04 Jun 2021 14:15:22 +0200
Date:   Fri, 4 Jun 2021 14:15:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, vee.khee.wong@linux.intel.com,
        linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLoZWho/5a60wqPu@lunn.ch>
References: <20210603073438.33967-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603073438.33967-1-lxu@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config MXL_GPHY
> +	tristate "Maxlinear PHYs"
> +	help
> +	  Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
> +	  GPY241, GPY245 PHYs.

Do these PHYs have unique IDs in register 2 and 3? What is the format
of these IDs?

The OUI is fixed. But often the rest is split into two. The higher
part indicates the product, and the lower part is the revision. We
then have a struct phy_driver for each product, and the mask is used
to match on all the revisions of the product.

     Andrew
