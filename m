Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEF6471644
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 21:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhLKUs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 15:48:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhLKUs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 15:48:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VxSkwg6ghmArPl90zmq1KDncKWgwBOo/4YCVA6ZQIZ0=; b=WKUuktnDtTljfOtDuxTGqjRKCv
        Rj5TYqRF/nixGbCRjkW47LDtJzN0eELkVzTzAdkDfKKD+UMFZsZ9DcWjFW7E1g44YYP9RgIqX+K94
        rulzOqte5Jbl+Z8W/5fG5n1taRUZxYsucgz75IMF0atg+aEfVHibM07G9csjIZXG9hP4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mw9I5-00GHif-SC; Sat, 11 Dec 2021 21:48:21 +0100
Date:   Sat, 11 Dec 2021 21:48:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v4 2/7] net: phy: Add 10-BaseT1L registers
Message-ID: <YbUOlRWhbE+F9KCx@lunn.ch>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
 <20211210110509.20970-3-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210110509.20970-3-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 01:05:04PM +0200, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> The 802.3gc specification defines the 10-BaseT1L link
> mode for ethernet trafic on twisted wire pair.
> 
> PMA status register can be used to detect if the phy supports
> 2.4 V TX level and PCS control register can be used to
> enable/disable PCS level loopback.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
